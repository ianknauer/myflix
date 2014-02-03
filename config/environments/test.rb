Myflix::Application.configure do
  config.cache_classes = true

  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=3600"

  config.eager_load = false

  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  config.action_dispatch.show_exceptions = false
  config.action_mailer.default_url_options = { host: 'localhost:3000' }

  config.action_controller.allow_forgery_protection    = false

  config.action_mailer.delivery_method = :test
  config.active_support.deprecation = :stderr
  
  ActionMailer::Base.smtp_settings = {
     :port           => ENV['MAILGUN_SMTP_PORT'],
     :address        => ENV['MAILGUN_SMTP_SERVER'],
     :user_name      => ENV['MAILGUN_SMTP_LOGIN'],
     :password       => ENV['MAILGUN_SMTP_PASSWORD'],
     :domain         => 'sheltered-badlands-1944.heroku.com',
     :authentication => :plain,
   }

   ActionMailer::Base.delivery_method = :smtp
end
