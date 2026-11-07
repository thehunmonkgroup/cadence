# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
# require "active_storage/engine"
require 'action_controller/railtie'
require 'action_mailer/railtie'
# require "action_mailbox/engine"
# require "action_text/engine"
require 'action_view/railtie'
# require "action_cable/engine"
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Cadence
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1
    # The dashboard always inspects durable queues, including when tests use Active Job's test adapter.
    config.mission_control.jobs.adapters = [:solid_queue]
    config.active_job.log_arguments = false

    initializer 'cadence.logging', before: :initialize_logger do |app|
      app.config.log_tags = [:request_id]
      app.config.log_level = ENV.fetch('RAILS_LOG_LEVEL', Rails.env.production? ? 'info' : 'debug')
      stdout_default = Rails.env.production? ? '1' : '0'
      destination = if ENV.fetch('RAILS_LOG_TO_STDOUT', stdout_default) == '1'
                      $stdout
                    else
                      ENV.fetch('RAILS_LOGFILE_PATH', Rails.root.join('log', "#{Rails.env}.log").to_s)
                    end
      logger = ActiveSupport::Logger.new(destination)
      logger.formatter = app.config.log_formatter
      app.config.logger = ActiveSupport::TaggedLogging.new(logger)
    end

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
