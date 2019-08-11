require 'open-uri'
require 'nokogiri'

class GitController < ApplicationController
  def index
  end

  def search
    content = open('https://github.com/search?q=' + params[:term]) {|io| io.read}
    document = Nokogiri::HTML(content)

    @term = params[:term]
    @counter = 0
    @repositories = []

    counter = document.xpath('//*[@id="js-pjax-container"]/div/div[3]/div/div[1]/h3')
    if counter.nil?
      @counter = "Error parsing results"
      return respond_to do |format|
        format.js
      end
    end

    @counter = counter.text.strip
    @repositories = []
    document.xpath('//*[@id="js-pjax-container"]/div/div[3]/div/ul/*').each do |element|
      descriptor = JSON.parse(element.at_css('a').attr('data-hydro-click'))
      @repositories << descriptor['payload']['result']['url']
    end

    respond_to do |format|
      format.js
    end
  end
end
