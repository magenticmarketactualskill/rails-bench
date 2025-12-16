# frozen_string_literal: true

# Define the configuration module for ActiveDataFlow
module ActiveDataFlow
  module Runtime
    module Heartbeat
      class Configuration
        attr_accessor :authentication_enabled,
                      :authentication_token,
                      :ip_whitelisting_enabled,
                      :whitelisted_ips

        def initialize
          @authentication_enabled = false
          @authentication_token = nil
          @ip_whitelisting_enabled = false
          @whitelisted_ips = []
        end
      end

      class << self
        def config
          @config ||= Configuration.new
        end

        def configure
          yield config
        end
      end
    end
  end
end

ActiveDataFlow::Runtime::Heartbeat.configure do |config|
  config.authentication_enabled = false
  config.ip_whitelisting_enabled = false
end
