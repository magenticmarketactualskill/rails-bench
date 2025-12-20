module GitTemplate
  module Generators
    module Migration
      def self.included(base)
        base.class_eval do
          @migration_name = nil
          @version = "[7.2]"
          @changes = []
        end
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        attr_reader :migration_name, :version, :changes
        
        def golden_text
          build_migration_content
        end
        
        private
        
        def build_migration_content
          lines = ["class #{@migration_name} < ActiveRecord::Migration#{@version}"]
          lines << "  def change"
          
          @changes&.each { |change| lines << "    #{change}" }
          
          lines << "  end"
          lines << "end"
          lines.join("\n")
        end
      end
    end
  end
end
