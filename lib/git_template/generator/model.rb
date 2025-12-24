require_relative '../../class_content_builder'

module GitTemplate
  module Generators
    module Model
      include ClassContentBuilder::Generator

      generator_type :class
      default_parent "ApplicationRecord"
      attribute :model_name
      attribute :attributes, default: []
      attribute :associations, default: []
      attribute :validations, default: []

      def self.build_content(builder)
        builder.open_definition
        @_attributes[:associations]&.each { |assoc| builder.association(assoc) }
        @_attributes[:validations]&.each { |valid| builder.validation(valid) }
        builder.close_definition
      end
    end
  end
end
