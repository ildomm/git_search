class GitController < ApplicationController
  protect_from_forgery with: :exception, unless: -> { request.format.js? }

  def index
  end

  def search
    @term = sanitized_term
    @counter = 0
    @repositories = []

    return render_error("Search term is required", :unprocessable_entity) unless @term.present?

    begin
      # Make the HTTP request with timeout and validation
      content = fetch_github_search_content
      document = Nokogiri::HTML(content)

      counter = document.xpath('//*[@id="js-pjax-container"]/div/div[3]/div/div[1]/h3')
      if counter.nil? || counter.empty?
        @counter = "No results found"
      else
        @counter = counter.text.strip
      end

      document.xpath('//*[@id="js-pjax-container"]/div/div[3]/div/ul/*').each do |element|
        begin
          descriptor = JSON.parse(element.at_css('a')&.attr('data-hydro-click') || '{}')
          url = descriptor.dig('payload', 'result', 'url')
          @repositories << url if valid_url?(url)
        rescue JSON::ParserError
          Rails.logger.warn "Skipping invalid JSON in GitHub response"
          next
        end
      end
    rescue StandardError => e
      Rails.logger.error "Search failed: #{e.message}"
      return render_error("Failed to fetch results from GitHub", :service_unavailable)
    end

    respond_to do |format|
      format.js
    end
  end

  private

  # Sanitize and validate the search term
  def sanitized_term
    term = params[:term]&.strip
    return nil unless term.present?
    # Limit length and remove dangerous characters
    term[0..100].gsub(/[^a-zA-Z0-9\-_\s]/, '')
  end

  # Fetch content from GitHub with security constraints
  def fetch_github_search_content
    uri = URI.parse("https://github.com/search?q=#{URI.encode_www_form_component(@term)}")
    raise "Invalid URL scheme" unless uri.scheme == 'https' && uri.host == 'github.com'

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.read_timeout = 5 # seconds
    http.open_timeout = 5 # seconds

    request = Net::HTTP::Get.new(uri.request_uri)
    request['User-Agent'] = 'GitSearch/1.0 (lala@example.com)'

    response = http.request(request)
    raise "GitHub request failed: #{response.code}" unless response.is_a?(Net::HTTPSuccess)

    response.body
  end

  # Validate repository URL
  def valid_url?(url)
    return false unless url.present? && url.is_a?(String)
    uri = URI.parse(url)
    uri.scheme == 'https' && uri.host == 'github.com' && uri.path.match?(/^\/[\w-]+\/[\w-]+/)
  rescue URI::InvalidURIError
    false
  end

  # Render error response consistently
  def render_error(message, status)
    @counter = message
    respond_to do |format|
      format.js { render status: status }
    end
  end
end