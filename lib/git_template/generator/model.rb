module GitTemplate
  module Generators
    module Model
      def self.included(base)
        base.class_eval do
          @model_name = nil
          @parent_class = "ApplicationRecord"
          @attributes = []
          @associations = []
          @validations = []
        end
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        attr_reader :model_name, :parent_class, :attributes, :associations, :validations
        
        def golden_text
          build_model_content
        end
        
        private
        
        def build_model_content
          lines = ["class #{@model_name} < #{@parent_class}"]
          
          @associations&.each { |assoc| lines << "  #{assoc}" }
          @validations&.each { |valid| lines << "  #{valid}" }
          
          lines << "end"
          lines.join("\n")
        end
      end
    end
  end
end
