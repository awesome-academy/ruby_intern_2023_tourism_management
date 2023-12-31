source "https://rubygems.org"
git_source(:github){|repo| "https://github.com/#{repo}.git"}

ruby "3.0.2"

gem "activerecord-import"
gem "active_storage_validations"
gem "bcrypt", "~> 3.1", ">= 3.1.11"
gem "bootsnap", ">= 1.4.4", require: false
gem "bootstrap-sass"
gem "cancancan", "~> 3.5"
gem "cocoon"
gem "config"
gem "devise", "~> 4.9", ">= 4.9.2"
gem "faker"
gem "figaro"
gem "grape"
gem "grape-entity", "~> 1.0"
gem "grape_on_rails_routes"
gem "grape-pagy"
gem "grape-swagger"
gem "grape-swagger-rails"
gem "i18n-js", "~> 3.0", ">= 3.0.2"
gem "image_processing", ">= 1.2"
gem "jbuilder", "~> 2.7"
gem "jwt"
gem "mini_magick"
gem "mysql2", "~> 0.5"
gem "pagy"
gem "pry-rails"
gem "puma", "~> 5.0"
gem "rails", "~> 6.1.7", ">= 6.1.7.3"
gem "rails-i18n"
gem "ransack", "~> 3.2", ">= 3.2.1"
gem "sass-rails", ">= 6"
gem "sidekiq", "~> 6.0"
gem "turbolinks", "~> 5"
gem "webpacker", "~> 5.0"

group :development, :test do
  gem "bullet"
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rails-controller-testing"
  %w(rspec rspec-core rspec-expectations rspec-mocks rspec-support).each do |lib|
    gem lib, git: "https://github.com/rspec/#{lib}.git", branch: "main"
  end
  gem "factory_bot_rails"
  gem "simplecov"
  gem "simplecov-rcov"
end

group :development do
  gem "listen", "~> 3.3"
  gem "rack-mini-profiler", "~> 2.0"
  gem "spring"
  gem "web-console", ">= 4.1.0"
end

group :test do
  gem "capybara", ">= 3.26"
  gem "selenium-webdriver", ">= 4.0.0.rc1"
  gem "webdrivers"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :development, :test do
  gem "rubocop", "~> 1.26", require: false
  gem "rubocop-checkstyle_formatter", require: false
  gem "rubocop-rails", "~> 2.14.0", require: false
end

group :development, :test do
  gem "rspec-rails", "~> 4.0.1"
end
