module GitTemplate
  module Generators
    module Mailer
      def self.included(base)
        base.class_eval do
          @mailer_name = nil
          @parent_class = "ApplicationMailer"
          @methods = []
        end
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        attr_reader :mailer_name, :parent_class, :methods
        
        def golden_text
          build_mailer_content
        end
        
        private
        
        def build_mailer_content
          lines = ["class #{@mailer_name} < #{@parent_class}"]
          
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
