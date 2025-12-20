module GitTemplate
  module Generators
    module Helper
      def self.included(base)
        base.class_eval do
          @helper_name = nil
          @methods = []
        end
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        attr_reader :helper_name, :methods
        
        def golden_text
          build_helper_content
        end
        
        private
        
        def build_helper_content
          lines = ["module #{@helper_name}"]
          
          @methods&.each do |method|
            lines << "  def #{method}"
            lines << "  end"
            lines << ""
          end
          
          lines << "end"
          lines.join("\n")
        end
      end
    end
  end
end
