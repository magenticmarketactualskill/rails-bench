# RunTemplatePart Command
#
# This command executes individual template part files from .git_template/template_part directories

require_relative 'base'
require 'pathname'
require 'stringio'
require_relative '../status_command_errors'

module GitTemplate
  module Command
    module RunTemplatePart
      include StatusCommandErrors
      
      def self.included(base)
        base.class_eval do
          desc "run_template_part --path=PATH", "Execute a specific template part file"
          add_common_options
          option :path, type: :string, required: true, desc: "Path to the template part file to execute"
          option :target_dir, type: :string, desc: "Target directory to execute the template part in (defaults to current directory)"
          
          def run_template_part
            execute_with_error_handling("run_template_part", options) do
              log_command_execution("run_template_part", [], options)
              setup_environment(options)
              
              template_part_path = validate_template_part_path(options[:path])
              target_directory = options[:target_dir] || Dir.pwd
              
              # Validate target directory
              unless File.directory?(target_directory)
                return create_error_response("run_template_part", "Target directory does not exist: #{target_directory}")
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
                
                create_success_response("run_template_part", {
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
                
                create_error_response("run_template_part", result[:error] || "Template part execution failed")
              end
            end
          end
          
          private
          
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