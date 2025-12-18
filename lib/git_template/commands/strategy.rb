# StrategyCommand Concern
#
# This command analyzes and reports on iteration strategies for template development,
# providing detailed analysis of what actions can be taken and prerequisites needed.

require_relative 'base'
require_relative '../services/folder_analyzer'
require_relative '../services/iteration_strategy'

module GitTemplate
  module Command
    module Strategy
      def self.included(base)
        base.class_eval do
          
          desc "strategy [PATH]", "Analyze iteration strategy for template development"
          add_common_options
          option :validate, type: :boolean, default: true, desc: "Include validation checks"
          
          define_method :strategy do |folder_path = "."|
            execute_with_error_handling("strategy", options) do
              log_command_execution("strategy", [folder_path], options)
              setup_environment(options)
              
              folder_analyzer = Services::FolderAnalyzer.new
              iteration_strategy_service = Services::IterationStrategy.new
              
              # Validate and analyze folder
              validated_path = validate_directory_path(folder_path, must_exist: false)
              
              # Analyze folder for iteration
              analysis = iteration_strategy_service.analyze_folder_for_iteration(validated_path, folder_analyzer)
              
              # Determine iteration strategy
              result = iteration_strategy_service.determine_iteration_strategy(analysis, options)
              
              # All results inherit from Models::Result::Base and handle their own formatting
              puts result.format_output(options[:format], options)
              result
            end
          end
          

        end
      end
    end
  end
end