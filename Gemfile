source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.0"
gem "mysql2", ">= 0.4.4"
gem "rails", "~> 6.1.4", ">= 6.1.4.1"
gem "sqlite3", "~> 1.4"
gem "puma", "~> 5.0"
gem "sass-rails", ">= 6"
gem "webpacker", "~> 5.0"
gem "turbolinks", "~> 5"
gem "jbuilder", "~> 2.7"
gem "bootsnap", ">= 1.4.4", require: false
gem "bootstrap-sass", "3.4.1"
gem "rails-i18n"
gem "config"
gem "bcrypt"
gem "paranoia", "~> 2.2"
gem "simplecov"
gem "simplecov-rcov"
gem "mini_magick", "4.9.5"
gem "image_processing", "1.9.3"
gem "active_storage_validations", "0.8.2"
gem "kaminari"
gem "bootstrap-kaminari-views"
gem "acts_as_paranoid"
gem "devise"
gem "font-awesome-rails"
gem "ransack"
gem "omniauth"
gem "omniauth-facebook"
gem "omniauth-google-oauth2"
gem "omniauth-rails_csrf_protection"
gem "figaro"
gem "cancancan"
gem "chartkick"
gem "groupdate"
gem "faker"
gem "activemerchant"
gem "paypal-checkout-sdk"
gem 'whenever', require: false
gem "sidekiq"

group :development, :test do
  gem "rspec-rails", "~> 4.0.1"
  gem "rubocop", "~> 0.74.0", require: false
  gem "rubocop-checkstyle_formatter", require: false
  gem "rubocop-rails", "~> 2.3.2", require: false
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem "web-console", ">= 4.1.0"
  gem "rack-mini-profiler", "~> 2.0"
  gem "listen", "~> 3.3"
  gem "spring"
end

group :test do
  gem "capybara", ">= 3.26"
  gem "selenium-webdriver"
  gem "webdrivers"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
