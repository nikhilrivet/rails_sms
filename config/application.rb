require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SmsRivet
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.time_zone = 'Asia/Dubai'
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.action_mailer.delivery_method = :smtp
    ActionMailer::Base.smtp_settings = {
        address: "smtp.gmail.com",
        enable_starttls_auto: true,
        port: 587,
        authentication: :plain,
        user_name: ENV["MAIL_USERNAME"],
        password: ENV["MAIL_PASSWORD"],
        openssl_verify_mode: 'none'
    }

    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(env_file)
    end

  end
end


