module GitTemplate
  module Generators
    module Config
      def self.included(base)
        base.class_eval do
          @config_lines = []
        end
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        attr_reader :config_lines
        
        def golden_text
          build_config_content
        end
        
        private
        
        def build_config_content
          @config_lines&.join("\n") || ""
        end
      end
    end
  end
end
