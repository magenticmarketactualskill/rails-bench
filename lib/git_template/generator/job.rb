module GitTemplate
  module Generators
    module Job
      def self.included(base)
        base.class_eval do
          @job_name = nil
          @parent_class = "ApplicationJob"
          @queue_name = "default"
        end
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        attr_reader :job_name, :parent_class, :queue_name
        
        def golden_text
          build_job_content
        end
        
        private
        
        def build_job_content
          lines = ["class #{@job_name} < #{@parent_class}"]
          lines << "  queue_as :#{@queue_name}" if @queue_name
          lines << ""
          lines << "  def perform(*args)"
          lines << "    # Do something later"
          lines << "  end"
          lines << "end"
          lines.join("\n")
        end
      end
    end
  end
end
