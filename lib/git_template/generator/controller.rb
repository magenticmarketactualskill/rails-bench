require_relative '../../class_content_builder'

module GitTemplate
  module Generators
    module Controller
      include ClassContentBuilder::Generator

      generator_type :class
      default_parent "ApplicationController"
      attribute :controller_name
      attribute :actions, default: []
      attribute :before_actions, default: []

      def self.build_content(builder)
        builder.open_definition
        @_attributes[:before_actions]&.each { |ba| builder.before_action(ba) }
        builder.blank_line if @_attributes[:before_actions]&.any?
        @_attributes[:actions]&.each do |action|
          builder.method_def(action)
          builder.blank_line
        end
        builder.close_definition
      end
    end
  end
end
