require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module TourismManagement
  class Application < Rails::Application

    config.load_defaults 6.1

    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]
    config.i18n.available_locales = [:en, :vi]
    config.i18n.default_locale = :vi

    config.middleware.use I18n::JS::Middleware

    config.active_job.queue_adapter = :sidekiq

    config.autoload_paths << Rails.root.join("lib")
  end
end
