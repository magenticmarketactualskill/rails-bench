require_relative '../../class_content_builder'

module GitTemplate
  module Generators
    module Job
      include ClassContentBuilder::Generator

      generator_type :class
      default_parent "ApplicationJob"
      attribute :job_name
      attribute :queue_name, default: "default"

      def self.build_content(builder)
        builder.open_definition
        builder.queue_as(@_attributes[:queue_name]) if @_attributes[:queue_name]
        builder.blank_line
        builder.method_def("perform", args: "*args", body: "# Do something later")
        builder.close_definition
      end
    end
  end
end
