# RecreateRepoCommand Concern
#
# This command performs a full repository iteration, recreating the templated folder
# from scratch and comparing it with the source application folder.

require_relative 'base'
require_relative '../services/template_iteration'
require_relative '../services/folder_analyzer'
require_relative '../services/iteration_strategy'
require_relative '../models/result/iteration_result'
require_relative '../models/result/iterate_command_result'
require_relative '../status_command_errors'

module GitTemplate
  module Command
    module RecreateRepo
      def self.included(base)
        base.class_eval do
          desc "recreate-repo [PATH]", "Perform full repository iteration and comparison"
          add_common_options
          option :clean_before, type: :boolean, default: true, desc: "Clean templated folder before recreation"
          option :detailed_comparison, type: :boolean, default: true, desc: "Generate detailed comparison report"
          
          define_method :recreate_repo do |path = "."|
            execute_with_error_handling("recreate_repo", options) do
              log_command_execution("recreate_repo", [path], options)
              setup_environment(options)
              
              template_iteration_service = Services::TemplateIteration.new
              folder_analyzer = Services::FolderAnalyzer.new
              iteration_strategy_service = Services::IterationStrategy.new
              
              # Validate and analyze folder
              validated_path = validate_directory_path(path, must_exist: true)
              analysis = iteration_strategy_service.analyze_folder_for_iteration(validated_path, folder_analyzer)
              
              # Check if folder is suitable for repo iteration
              folder_analysis = analysis[:folder_analysis]
              unless folder_analysis[:exists]
                result = Models::Result::IterateCommandResult.new(
                  success: false,
                  operation: "recreate_repo",
                  error_message: "Source folder does not exist: #{validated_path}"
                )
                puts result.format_output(options[:format], options)
                return result
              end
              
              # Check if templated folder exists
              unless folder_analysis[:templated_folder_exists]
                result = Models::Result::IterateCommandResult.new(
                  success: false,
                  operation: "recreate_repo",
                  error_message: "No templated folder found. Use create-templated-folder first."
                )
                puts result.format_output(options[:format], options)
                return result
              end
              
              # Execute full iteration
              iteration_data = template_iteration_service.execute_repo_iteration(analysis, options)
              
              # Create result object
              result = Models::Result::IterationResult.new(iteration_data)
              
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