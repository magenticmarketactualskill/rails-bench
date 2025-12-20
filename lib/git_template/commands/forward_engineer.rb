# ForwardEngineer Command
#
# This command combines the functionality of run_template_part and rerun_template.
# It allows running either a specific template part or the full template processing.

require_relative 'base'
require_relative 'submodule_protection'
require_relative '../services/template_processor'
require_relative '../services/folder_analyzer'
require_relative '../models/result/iterate_command_result'
require_relative '../status_command_errors'
require 'pathname'
require 'stringio'

module GitTemplate
  module Command
    module ForwardEngineer
      include StatusCommandErrors
      
      def self.included(base)
        base.class_eval do
          include SubmoduleProtection
          
          desc "forward-engineer", "Run template processing (full template or specific part)"
          add_common_options
          option :template_part, type: :string, desc: "Path to specific template part file to execute"
          option :full, type: :boolean, default: false, desc: "Run full template processing (rerun entire template)"
          option :target_dir, type: :string, desc: "Target directory (defaults to current directory)"
          option :update_content, type: :boolean, default: true, desc: "Update template content based on current state (for full mode)"
          
          def forward_engineer
            execute_with_error_handling("forward_engineer", options) do
              log_command_execution("forward_engineer", [], options)
              setup_environment(options)
              
              # Validate that either --template_part or --full is specified
              has_template_part = options[:template_part] && !options[:template_part].empty?
              has_full = options[:full]
              
              if !has_template_part && !has_full
                return create_error_response(
                  "forward_engineer",
                  "Must specify either --template_part=PATH or --full. Use --help for more information."
                )
              end
              
              if has_template_part && has_full
                return create_error_response(
                  "forward_engineer",
                  "Cannot specify both --template_part and --full. Choose one mode."
                )
              end
              
              # Execute appropriate mode
              if has_template_part
                execute_template_part_mode(options)
              else
                execute_full_template_mode(options)
              end
            end
          end
          
          private
          
          # Execute a specific template part (run_template_part functionality)
          def execute_template_part_mode(options)
            template_part_path = validate_template_part_path(options[:template_part])
            target_directory = options[:target_dir] || Dir.pwd
            
            # Validate target directory
            unless File.directory?(target_directory)
              return create_error_response("forward_engineer", "Target directory does not exist: #{target_directory}")
            end
            
            puts "🚀 Executing template part: #{File.basename(template_part_path)}"
            puts "📁 Target directory: #{target_directory}"
            puts "📄 Template part path: #{template_part_path}"
            puts "=" * 60
            
            # Execute the template part
            result = execute_template_part(template_part_path, target_directory, options)
            
            if result[:success]
              puts "\n✅ Template part executed successfully!"
              if result[:output] && !result[:output].strip.empty?
                puts "\n📋 Output:"
                puts result[:output]
              end
              
              create_success_response("forward_engineer", {
                mode: "template_part",
                template_part_path: template_part_path,
                target_directory: target_directory,
                execution_time: result[:execution_time],
                output: result[:output]
              })
            else
              puts "\n❌ Template part execution failed!"
              if result[:error]
                puts "Error: #{result[:error]}"
              end
              
              create_error_response("forward_engineer", result[:error] || "Template part execution failed")
            end
          end
          
          # Execute full template processing (rerun_template functionality)
          def execute_full_template_mode(options)
            path = options[:target_dir] || "."
            
            # Check if path is a submodule - if so, reject the operation
            protection_result = check_submodule_protection(path, "forward_engineer")
            if protection_result
              puts protection_result.format_output(options[:format], options)
              return protection_result
            end
            
            template_processor = Services::TemplateProcessor.new
            folder_analyzer = Services::FolderAnalyzer.new
            
            # Validate templated folder
            validated_path = validate_directory_path(path, must_exist: true)
            
            # Analyze folder to ensure it has template configuration
            analysis = folder_analyzer.analyze_template_development_status(validated_path)
            folder_analysis = analysis[:folder_analysis]
            
            # Check if folder has template configuration
            unless folder_analysis[:has_template_configuration]
              result = Models::Result::IterateCommandResult.new(
                success: false,
                operation: "forward_engineer",
                error_message: "No template configuration found at #{validated_path}. Use create-templated-folder first."
              )
              puts result.format_output(options[:format], options)
              return result
            end
            
            puts "🚀 Running full template processing"
            puts "📁 Target directory: #{validated_path}"
            puts "=" * 60
            
            # Apply template to regenerate application files
            template_path = File.join(validated_path, '.git_template')
            
            begin
              apply_result = template_processor.apply_template(template_path, validated_path, options)
              
              # Check if template application was successful
              if apply_result[:success]
                puts "\n✅ Full template executed successfully!"
                
                result = Models::Result::IterateCommandResult.new(
                  success: true,
                  operation: "forward_engineer",
                  data: {
                    mode: "full_template",
                    template_path: apply_result[:template_path],
                    target_path: apply_result[:target_path],
                    applied_template: apply_result[:applied_template],
                    output: apply_result[:output]
                  }
                )
              else
                puts "\n❌ Full template execution failed!"
                
                result = Models::Result::IterateCommandResult.new(
                  success: false,
                  operation: "forward_engineer",
                  error_message: "Template execution failed",
                  data: {
                    mode: "full_template",
                    template_path: apply_result[:template_path],
                    target_path: apply_result[:target_path],
                    applied_template: apply_result[:applied_template],
                    output: apply_result[:output]
                  }
                )
              end
            rescue => e
              result = Models::Result::IterateCommandResult.new(
                success: false,
                operation: "forward_engineer",
                error_message: "Template application failed: #{e.message}"
              )
            end
            
            # Output result
            puts result.format_output(options[:format], options)
            result
          end
          
          def validate_template_part_path(path)
            # Expand the path
            expanded_path = File.expand_path(path)
            
            # Check if file exists
            unless File.exist?(expanded_path)
              raise InvalidPathError.new("Template part file does not exist: #{expanded_path}")
            end
            
            # Check if it's a file (not directory)
            unless File.file?(expanded_path)
              raise InvalidPathError.new("Path is not a file: #{expanded_path}")
            end
            
            # Validate that it's either in a template_part directory or is a template.rb file
            path_parts = Pathname.new(expanded_path).each_filename.to_a
            filename = File.basename(expanded_path)
            
            is_template_part = path_parts.include?('template_part') || path_parts.include?('template_parts')
            is_main_template = filename == 'template.rb' && path_parts.include?('.git_template')
            
            unless is_template_part || is_main_template
              raise InvalidPathError.new("File must be in a 'template_part' directory or be a 'template.rb' file in '.git_template'")
            end
            
            expanded_path
          end
          
          def execute_template_part(template_part_path, target_directory, options)
            start_time = Time.now
            
            begin
              # Change to target directory
              original_dir = Dir.pwd
              Dir.chdir(target_directory)
              
              # Load required GitTemplate modules before executing template part
              require_relative '../../git_template'
              require_relative '../../template_generator_registry'
              
              # Capture output
              output_buffer = StringIO.new
              original_stdout = $stdout
              $stdout = output_buffer if options[:verbose]
              
              begin
                # Load and execute the template part
                puts "Loading template part from: #{template_part_path}" if options[:verbose]
                
                # Read the template part content
                template_content = File.read(template_part_path)
                
                # Execute the template part in the current context
                eval(template_content, binding, template_part_path)
                
                execution_time = Time.now - start_time
                output = output_buffer.string
                
                {
                  success: true,
                  output: output,
                  execution_time: execution_time.round(2)
                }
                
              rescue => e
                execution_time = Time.now - start_time
                {
                  success: false,
                  error: "#{e.class}: #{e.message}",
                  execution_time: execution_time.round(2),
                  backtrace: e.backtrace&.first(5)
                }
              ensure
                $stdout = original_stdout
              end
              
            ensure
              # Always return to original directory
              Dir.chdir(original_dir)
            end
          end
        end
      end
    end
  end
end
