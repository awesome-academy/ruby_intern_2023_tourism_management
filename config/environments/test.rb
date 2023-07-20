require "active_support/core_ext/integer/time"

Rails.application.configure do

  config.cache_classes = false
  config.action_view.cache_template_loading = true

  config.eager_load = false

  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.hour.to_i}"
  }

  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  config.action_dispatch.show_exceptions = false

  config.action_controller.allow_forgery_protection = false

  config.active_storage.service = :test

  config.action_mailer.perform_caching = false

  config.action_mailer.delivery_method = :test

  config.active_support.deprecation = :stderr

  config.active_support.disallowed_deprecation = :raise

  config.active_support.disallowed_deprecation_warnings = []

  config.active_job.queue_adapter = :inline

  config.action_mailer.delivery_method = :smtp

  config.action_mailer.default_url_options = {host: ENV["host"]}

  config.action_mailer.smtp_settings = {
    user_name: ENV["mail_user_name"],
    password: ENV["mail_user_password"],
    address: ENV["mail_address"],
    port: ENV["mail_port"],
    authentication: :cram_md5,
    enable_starttls_auto: true
  }
end
