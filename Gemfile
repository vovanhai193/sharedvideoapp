source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"
gem "rails", "~> 7.0.4", ">= 7.0.4.3"
gem "sprockets-rails"
gem 'pg', '~> 1.4', '>= 1.4.6'
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "stimulus-rails"
gem 'turbo-rails'
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem 'bootstrap', '~> 5.1.3'
gem "devise", "4.9.2"
gem 'kaminari'

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "pry"
  gem 'faker'
  gem "factory_bot_rails"
  gem 'dotenv-rails'
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "rspec"
  gem "rspec-rails"
  gem 'rails-controller-testing',  '~> 1.0.1',  require: false
  gem 'shoulda-matchers',          '~> 3.1.1',  require: false
end
