require_relative '../../class_content_builder'

module GitTemplate
  module Generators
    module Migration
      include ClassContentBuilder::Generator

      generator_type :class
      default_parent "ActiveRecord::Migration[7.2]"
      attribute :migration_name
      attribute :version, default: "[7.2]"
      attribute :changes, default: []

      def self.golden_text
        build_migration_content
      end

      def self.build_migration_content
        lines = ["class #{@_name} < ActiveRecord::Migration#{@_attributes[:version]}"]
        lines << "  def change"
        @_attributes[:changes]&.each { |change| lines << "    #{change}" }
        lines << "  end"
        lines << "end"
        lines.join("\n")
      end
    end
  end
end
