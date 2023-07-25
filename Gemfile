# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.0'

gem 'rails', '~> 7.0.6'

# Assets
gem 'sassc-rails'
gem 'sprockets-rails'

# DB
gem 'pg'
gem 'redis', '~> 4.0'

# Server
gem 'puma', '~> 5.0'

# Hotwire
gem 'stimulus-rails'
gem 'turbo-rails'

# Serializers
gem 'jbuilder'

# Caching
gem 'bootsnap', require: false

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[ mingw mswin x64_mingw jruby ]

group :development, :test do
  gem 'debug', platforms: %i[ mri mingw x64_mingw ]
  gem 'rubocop'
  gem 'rubocop-factory_bot'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
end

group :development do
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end
