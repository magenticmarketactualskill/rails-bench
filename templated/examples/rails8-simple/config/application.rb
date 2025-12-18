# Minimal Rails application configuration for template processing
require_relative "boot"
require "rails/all"

module TemplateTestApp
  class Application < Rails::Application
    config.load_defaults 7.0
  end
end
