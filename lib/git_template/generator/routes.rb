module GitTemplate
  module Generators
    module Routes
      def self.included(base)
        base.class_eval do
          @routes = []
        end
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        attr_reader :routes
        
        def golden_text
          build_routes_content
        end
        
        private
        
        def build_routes_content
          lines = ["Rails.application.routes.draw do"]
          
          @routes&.each do |route|
            lines << "  #{route}"
          end
          
          lines << "end"
          lines.join("\n")
        end
      end
    end
  end
end
