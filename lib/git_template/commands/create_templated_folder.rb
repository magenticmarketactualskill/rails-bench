# CreateTemplatedFolder Concern
#
# This command creates a templated folder structure with basic template configuration
# for a given source application folder.

require_relative 'base'
require_relative '../services/template_processor'
require_relative '../services/folder_analyzer'
require_relative '../models/result/iterate_command_result'
require_relative '../status_command_errors'

module GitTemplate
  module Command
    module CreateTemplatedFolder
      def self.included(base)
        base.class_eval do
          desc "create-templated-folder", "Create templated folder structure with template configuration"
          add_common_options
          option :template_content, type: :string, desc: "Custom template content"
          option :path, type: :string, default: ".", desc: "Source folder path (defaults to current directory)"
          
          define_method :create_templated_folder do
            execute_with_error_handling("create_templated_folder", options) do
              path = options[:path] || "."
              log_command_execution("create_templated_folder", [path], options)
              setup_environment(options)
              
              template_processor = Services::TemplateProcessor.new
              folder_analyzer = Services::FolderAnalyzer.new
              
              # Validate source folder
              validated_path = validate_directory_path(path, must_exist: true)
              
              # Analyze source folder
              analysis = folder_analyzer.analyze_template_development_status(validated_path)
              folder_analysis = analysis[:folder_analysis]
              
              # Check if source folder is suitable
              unless folder_analysis[:exists]
                result = Models::Result::IterateCommandResult.new(
                  success: false,
                  operation: "create_templated_folder",
                  error_message: "Source folder does not exist: #{validated_path}"
                )
                puts result.format_output(options[:format], options)
                return result
              end
              
              # Create templated folder structure
              result = template_processor.create_templated_folder(validated_path, options)
              
              # Output result
              puts result.format_output(options[:format], options)
              result
            end
          end
        end
      end
    end
  end
end