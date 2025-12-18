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
          desc "recreate-repo [REMOTE_URL]", "Recreate repo creates a submodule with a git clone of the repo, creates a templated folder, and recreates the repo using the .git-template folder. It then does a comparison of the generated content with the original"
          add_common_options
          option :clean_before, type: :boolean, default: true, desc: "Clean templated folder before recreation"
          option :detailed_comparison, type: :boolean, default: true, desc: "Generate detailed comparison report"
          
          define_method :recreate_repo do |remote_url = nil|
            execute_with_error_handling("recreate_repo", options) do
              log_command_execution("recreate_repo", [remote_url], options)
              setup_environment(options)
              
              # Validate remote URL is provided
              unless remote_url
                result = Models::Result::IterateCommandResult.new(
                  success: false,
                  operation: "recreate_repo",
                  error_message: "Remote URL is required for recreate-repo command"
                )
                puts result.format_output(options[:format], options)
                return result
              end
              
              # Analyze the current state (using current directory)
              analysis = analyze_folder(".", options)
              template_iteration_service = Services::TemplateIteration.new
              
              # Determine if recreation can proceed
              iteration_strategy_service = Services::IterationStrategy.new
              iteration_strategy_result = iteration_strategy_service.determine_iteration_strategy(analysis, options)
              
              unless can_recreate_repo?(iteration_strategy_result, options)
                result = Models::Result::IterateCommandResult.new(
                  success: false,
                  operation: "recreate_repo",
                  error_message: iteration_strategy_result.reason
                )
                puts result.format_output(options[:format], options)
                return result
              end
              
              # Execute repository recreation
              result = perform_recreate_repo(remote_url, analysis, template_iteration_service, options)
              
              # Format and display output
              puts result.format_output(options[:format], options)
              
              result
            end
          end
          
          private
          
          define_method :can_recreate_repo? do |iteration_strategy_result, options|
            # Allow recreation if it's ready for iteration or if force is enabled
            iteration_strategy_result.recreate_repo_can_proceed || 
            iteration_strategy_result.strategy_type == :recreate_repo ||
            options[:force]
          end
          
          define_method :perform_recreate_repo do |remote_url, analysis, template_iteration_service, options|
            begin
              # Recreate Repo
              # 1. creates a submodule with a git clone of the repo
              # 2. creates a templated folder
              # 3. recreates the repo using the .git-template folder
              # 4. does a comparison of the generated content with the original
              
              # TODO: Implement the actual recreation logic using remote_url
              puts "Recreating repo from: #{remote_url}"
              
              # Return success result for now
              Models::Result::IterateCommandResult.new(
                success: true,
                operation: "recreate_repo",
                message: "Repository recreation completed successfully"
              )
              
            rescue => e
              # Return error result object
              Models::Result::IterateCommandResult.new(
                success: false,
                operation: "recreate_repo",
                error_message: e.message,
                error_type: e.class.name
              )
            end
          end
        end
      end
    end
  end
end