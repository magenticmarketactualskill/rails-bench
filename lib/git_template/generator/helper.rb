require_relative '../../class_content_builder'

module GitTemplate
  module Generators
    module Helper
      include ClassContentBuilder::Generator

      generator_type :module
      attribute :helper_name
      attribute :methods, default: []

      def self.build_content(builder)
        builder.open_definition
        @_attributes[:methods]&.each do |method|
          builder.method_def(method)
          builder.blank_line
        end
        builder.close_definition
      end
    end
  end
end
