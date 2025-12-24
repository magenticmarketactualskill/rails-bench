require_relative '../../class_content_builder'

module GitTemplate
  module Generators
    module Config
      include ClassContentBuilder::Generator

      attribute :config_lines, default: []

      def self.golden_text
        @_attributes[:config_lines]&.join("\n") || ""
      end
    end
  end
end
