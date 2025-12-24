require_relative '../../class_content_builder'

module GitTemplate
  module Generators
    module Routes
      include ClassContentBuilder::Generator

      attribute :routes, default: []

      # Parse a routes.rb file and extract route definitions
      def self.parse(file_path)
        content = File.read(file_path)
        routes = []

        content.each_line do |line|
          stripped = line.strip

          next if stripped.empty? || stripped.start_with?('#')
          next if stripped.include?('routes.draw')
          next if stripped == 'end'

          if stripped.match?(/^\s*(get|post|put|patch|delete|resource|resources|root|namespace|scope|match)\s+/)
            routes << stripped
          end
        end

        routes
      end

      def self.golden_text
        lines = ["Rails.application.routes.draw do"]
        @_attributes[:routes]&.each { |route| lines << "  #{route}" }
        lines << "end"
        lines.join("\n")
      end
    end
  end
end
