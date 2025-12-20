module GitTemplate
  module Generators
    module Controller
      def self.included(base)
        base.class_eval do
          @controller_name = nil
          @parent_class = "ApplicationController"
          @actions = []
          @before_actions = []
        end
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        attr_reader :controller_name, :parent_class, :actions, :before_actions
        
        def golden_text
          build_controller_content
        end
        
        private
        
        def build_controller_content
          lines = ["class #{@controller_name} < #{@parent_class}"]
          
          @before_actions&.each { |ba| lines << "  #{ba}" }
          lines << "" if @before_actions&.any?
          
          @actions&.each do |action|
            lines << "  def #{action}"
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
