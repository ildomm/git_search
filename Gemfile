source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
ruby File.read('.ruby-version').chomp

gem 'rails', '~> 7'
gem 'puma', '~> 6'
gem 'sqlite3'
gem 'sass-rails', '~> 5.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'

group :development, :test do
  gem 'rubocop'
end

group :test do
  gem "rspec-rails"
  gem 'rails-controller-testing'
  gem 'webmock'
end

