require "thor"
require "fileutils"
require_relative "commands/status_command"
require_relative "commands/clone_command"
require_relative "commands/iterate_command"
require_relative "commands/update_command"
require_relative "commands/push_command"
require_relative "commands/push_command"
require_relative "models/diff_result_command"

module GitTemplate
  class CLI < Thor
    desc "apply [PATH]", "Apply the git-template to current directory or specified path"
    option :rails_new, type: :boolean, default: false, desc: "Create new Rails application"
    def apply(path = ".")
      begin
        if options[:rails_new]
          puts "Creating new Rails application with git-template..."
          # This would be used with: rails new myapp -m git-template
          puts "Use: rails new myapp -m git-template"
          return
        end
        
        puts "Applying git-template to #{File.expand_path(path)}..."
        
        # Check if we're in a Rails application directory
        unless File.exist?(File.join(path, "config", "application.rb"))
          puts "Error: Not a Rails application directory. Please run from Rails app root or use --rails-new option."
          exit 1
        end
        
        # Apply template to existing Rails app
        Dir.chdir(path) do
          template_path = TemplateResolver.gem_template_path
          puts "Using template: #{template_path}"
          
          # Execute the template using Rails' template system
          system("bin/rails app:template LOCATION=#{template_path}")
        end
        
        puts "\n" + "=" * 60
        puts "✅ git-template application completed successfully!"
        puts "=" * 60
        puts "\nYour Rails application has been enhanced with:"
        puts "  • Structured template lifecycle management"
        puts "  • Modern frontend setup (Vite, Tailwind, Juris.js)"
        puts "  • Organized phase-based configuration"
        puts "\nNext steps:"
        puts "  1. Start the development server: bin/dev"
        puts "  2. Visit http://localhost:3000"
        puts "  3. Explore the template structure in template/ directory"
        puts "\nFor more information: git-template help"
        
      rescue => e
        puts "❌ Error applying template: #{e.message}"
        puts e.backtrace if ENV["DEBUG"]
        exit 1
      end
    end

    desc "version", "Show git-template version"
    def version
      puts "git-template version #{GitTemplate::VERSION}"
    end

    desc "list", "List available templates"
    def list
      puts "Available templates:"
      puts "  • Rails 8 + Juris.js (default) - Modern Rails app with Juris.js frontend"
    end

    desc "path", "Show path to bundled template"
    def path
      puts TemplateResolver.gem_template_path
    end

    # New status command system commands
    desc "status FOLDER", "Check the status of application folders for template development"
    option :format, type: :string, default: "detailed", desc: "Output format: detailed, summary, json"
    option :verbose, type: :boolean, default: false, desc: "Show verbose output"
    option :debug, type: :boolean, default: false, desc: "Show debug information"
    def status(folder_path)
      setup_environment(options)
      
      begin
        command = Commands::StatusCommand.new
        result = command.execute(folder_path, options.to_h.symbolize_keys)
        
        if result[:success]
          puts result[:report] if result[:report]
          puts result[:summary] if result[:summary] && !result[:report]
        else
          handle_command_error("status", result)
        end
      rescue => e
        handle_unexpected_command_error("status", e, options)
      end
    end

    desc "clone GIT_URL [TARGET_FOLDER]", "Clone remote applications for template development"
    option :branch, type: :string, desc: "Specific branch to clone"
    option :depth, type: :numeric, desc: "Create shallow clone with specified depth"
    option :quiet, type: :boolean, default: false, desc: "Suppress output"
    option :create_template_config, type: :boolean, default: false, desc: "Create basic template configuration"
    option :debug, type: :boolean, default: false, desc: "Show debug information"
    def clone(git_url, target_folder = nil)
      setup_environment(options)
      validate_command_prerequisites
      
      begin
        command = Commands::CloneCommand.new
        result = command.execute(git_url, target_folder, options.to_h.symbolize_keys)
        
        if result[:success]
          puts "✅ Successfully cloned #{result[:git_url]} to #{result[:target_path]}"
        else
          handle_command_error("clone", result)
        end
      rescue => e
        handle_unexpected_command_error("clone", e, options)
      end
    end

    desc "iterate FOLDER", "Iterate on templates to refine accuracy through comparison"
    option :detailed_comparison, type: :boolean, default: false, desc: "Show detailed comparison results"
    option :create_templated_folder, type: :boolean, default: false, desc: "Create templated folder if it doesn't exist"
    option :verbose, type: :boolean, default: false, desc: "Show verbose output"
    option :debug, type: :boolean, default: false, desc: "Show debug information"
    def iterate(folder_path)
      setup_environment(options)
      
      begin
        command = Commands::IterateCommand.new
        result = command.execute(folder_path, options.to_h.symbolize_keys)
        
        if result[:success]
          puts "✅ Template iteration completed"
          puts "   Application folder: #{result[:application_folder]}"
          puts "   Templated folder: #{result[:templated_folder]}"
          puts "   Template applied: #{result[:template_applied] ? 'Yes' : 'No'}"
          puts "   Differences found: #{result[:differences_count]} changes"
          puts "   Cleanup updated: #{result[:cleanup_updated] ? 'Yes' : 'No'}"
        else
          handle_command_error("iterate", result)
        end
      rescue => e
        handle_unexpected_command_error("iterate", e, options)
      end
    end

    desc "update FOLDER", "Update templates to incorporate refinements and maintain accuracy"
    option :refresh_structure, type: :boolean, default: false, desc: "Refresh template structure analysis"
    option :fix_issues, type: :boolean, default: false, desc: "Fix common template issues"
    option :update_metadata, type: :boolean, default: false, desc: "Update template metadata"
    option :all, type: :boolean, default: false, desc: "Perform all update operations"
    option :verbose, type: :boolean, default: false, desc: "Show verbose output"
    option :debug, type: :boolean, default: false, desc: "Show debug information"
    def update(folder_path)
      setup_environment(options)
      
      begin
        command = Commands::UpdateCommand.new
        result = command.execute(folder_path, options.to_h.symbolize_keys)
        
        if result[:success]
          puts "✅ Template update completed"
          puts "   Operations performed: #{result[:operations_performed].length}"
          result[:operations_performed].each { |op| puts "   - #{op}" }
          
          validation = result[:validation_result]
          puts "   Template valid: #{validation[:valid] ? 'Yes' : 'No'}"
          if validation[:validation_errors].any?
            puts "   Validation errors:"
            validation[:validation_errors].each { |error| puts "     - #{error}" }
          end
        else
          handle_command_error("update", result)
        end
      rescue => e
        handle_unexpected_command_error("update", e, options)
      end
    end

    desc "push FOLDER [REMOTE_URL]", "Push application folders to remote repositories"
    option :remote_name, type: :string, default: "origin", desc: "Remote name to use"
    option :branch, type: :string, desc: "Branch to push"
    option :commit_changes, type: :boolean, default: false, desc: "Commit changes before pushing"
    option :commit_message, type: :string, desc: "Commit message to use"
    option :initialize_if_needed, type: :boolean, default: false, desc: "Initialize git repository if needed"
    option :force, type: :boolean, default: false, desc: "Force push"
    option :verbose, type: :boolean, default: false, desc: "Show verbose output"
    option :debug, type: :boolean, default: false, desc: "Show debug information"
    def push(folder_path, remote_url = nil)
      setup_environment(options)
      validate_command_prerequisites
      
      begin
        command = Commands::PushCommand.new
        result = command.execute(folder_path, remote_url, options.to_h.symbolize_keys)
        
        if result[:success]
          puts "✅ Successfully pushed #{result[:folder_path]}"
          puts "   Remote URL: #{result[:remote_url]}" if result[:remote_url]
          puts "   Repository initialized: Yes" if result[:repository_initialized]
          puts "   Changes committed: Yes" if result[:changes_committed]
        else
          handle_command_error("push", result)
        end
      rescue => e
        handle_unexpected_command_error("push", e, options)
      end
    end

    desc "to_md FOLDER", "Convert template.rb to template.rb.md with markdown documentation"
    option :output_file, type: :string, desc: "Output file name (default: template.rb.md)"
    option :verbose, type: :boolean, default: false, desc: "Show verbose output"
    def to_md(folder_path)
      begin
        # Validate folder path
        unless File.directory?(folder_path)
          puts "❌ Error: Folder '#{folder_path}' does not exist"
          exit 1
        end
        
        # Look for template.rb file
        template_file = File.join(folder_path, '.git_template', 'template.rb')
        unless File.exist?(template_file)
          puts "❌ Error: template.rb not found at #{template_file}"
          exit 1
        end
        
        # Determine output file
        output_file = options[:output_file] || File.join(folder_path, '.git_template', 'template.rb.md')
        
        puts "🔄 Converting template.rb to markdown documentation..." if options[:verbose]
        puts "   Source: #{template_file}" if options[:verbose]
        puts "   Output: #{output_file}" if options[:verbose]
        
        # Read and parse template.rb
        template_content = File.read(template_file)
        markdown_content = convert_template_to_markdown(template_content, folder_path)
        
        # Write markdown file
        File.write(output_file, markdown_content)
        
        puts "✅ Successfully created #{output_file}"
        puts "📄 Template documentation generated with #{count_sections(markdown_content)} sections"
        
      rescue => e
        puts "❌ Error converting template to markdown: #{e.message}"
        puts "   #{e.backtrace.first}" if options[:verbose]
        exit 1
      end
    end

    desc "test", "Test git-template with a specific templated app"
    option :templated_app_path, type: :string, required: true, desc: "Path to templated app (e.g., examples/rails/rails8-juris)"
    def test
      require "fileutils"
      require "tmpdir"
      require "time"
      
      templated_app_path = options[:templated_app_path]
      
      # Create log directory and timestamp
      timestamp = Time.now.strftime("%Y%m%d_%H%M%S")
      log_dir = File.join(Dir.pwd, "log", "git-template-test", timestamp)
      FileUtils.mkdir_p(log_dir)
      
      # Create log files
      main_log = File.join(log_dir, "test_execution.log")
      git_status_log = File.join(log_dir, "git_status.log")
      git_diff_log = File.join(log_dir, "git_diff.log")
      summary_log = File.join(log_dir, "summary.log")
      
      puts "🧪 Starting git-template test..."
      puts "Templated app path: #{templated_app_path}"
      puts "📁 Logs will be saved to: #{log_dir}"
      
      # Start logging
      File.open(main_log, 'w') do |log|
        log.puts "Git Template Test Execution Log"
        log.puts "=" * 50
        log.puts "Timestamp: #{Time.now}"
        log.puts "Templated app path: #{templated_app_path}"
        log.puts "Log directory: #{log_dir}"
        log.puts "=" * 50
        log.puts ""
      
        # Step 1: Confirm .git_template path exists
        git_template_root = File.expand_path("../..", __dir__)
        puts "\n1️⃣ Checking .git_template path..."
        puts "Git template root: #{git_template_root}"
        log.puts "1️⃣ Checking .git_template path..."
        log.puts "Git template root: #{git_template_root}"
        
        unless File.directory?(git_template_root)
          error_msg = "❌ Error: .git_template path does not exist: #{git_template_root}"
          puts error_msg
          log.puts error_msg
          exit 1
        end
        puts "✅ .git_template path exists"
        log.puts "✅ .git_template path exists"
      
        # Step 2: Validate .git_template contents
        puts "\n2️⃣ Validating .git_template contents..."
        log.puts "\n2️⃣ Validating .git_template contents..."
        
        # Check for git-template library
        lib_path = File.join(git_template_root, "lib/git_template.rb")
        unless File.exist?(lib_path)
          error_msg = "❌ Error: Required path missing: lib/git_template.rb"
          puts error_msg
          log.puts error_msg
          exit 1
        end
        puts "✅ Found: lib/git_template.rb"
        log.puts "✅ Found: lib/git_template.rb"
        
        # Check for the templated app path
        app_path = File.join(git_template_root, templated_app_path)
        unless File.exist?(app_path)
          error_msg = "❌ Error: Required path missing: #{templated_app_path}"
          puts error_msg
          log.puts error_msg
          exit 1
        end
        puts "✅ Found: #{templated_app_path}"
        log.puts "✅ Found: #{templated_app_path}"
        
        # Check for template file in the app
        template_file = File.join(app_path, ".git_template/template.rb")
        unless File.exist?(template_file)
          error_msg = "❌ Error: Required template file missing: #{templated_app_path}/.git_template/template.rb"
          puts error_msg
          log.puts error_msg
          exit 1
        end
        puts "✅ Found: #{templated_app_path}/.git_template/template.rb"
        log.puts "✅ Found: #{templated_app_path}/.git_template/template.rb"
      
        # Step 3: Create folder template_test
        puts "\n3️⃣ Creating template_test folder..."
        log.puts "\n3️⃣ Creating template_test folder..."
        test_dir = File.join(Dir.pwd, "template_test")
        
        if File.exist?(test_dir)
          cleanup_msg = "🗑️  Removing existing template_test directory..."
          puts cleanup_msg
          log.puts cleanup_msg
          FileUtils.rm_rf(test_dir)
        end
        
        FileUtils.mkdir_p(test_dir)
        created_msg = "✅ Created: #{test_dir}"
        puts created_msg
        log.puts created_msg
      
        # Step 4: Copy JUST the template folder to template_test/[templated_app_path]
        puts "\n4️⃣ Copying template to test directory..."
        log.puts "\n4️⃣ Copying template to test directory..."
        source_path = File.join(git_template_root, templated_app_path)
        dest_path = File.join(test_dir, templated_app_path)
        
        FileUtils.mkdir_p(File.dirname(dest_path))
        FileUtils.cp_r(source_path, dest_path)
        copy_msg = "✅ Copied #{templated_app_path} to #{dest_path}"
        puts copy_msg
        log.puts copy_msg
      
        # Step 5: Clean up files to remove problematic references
        puts "\n5️⃣ Cleaning up files for testing..."
        log.puts "\n5️⃣ Cleaning up files for testing..."
        
        # Clean up Gemfile
        gemfile_path = File.join(dest_path, "Gemfile")
        if File.exist?(gemfile_path)
          gemfile_content = File.read(gemfile_path)
          
          # Comment out problematic path-based gems
          problematic_patterns = [
            /^gem\s+["']active_data_flow.*$/,
            /^gem\s+["']redis-emulator.*$/,
            /^#gem\s+['"]submoduler-core.*$/
          ]
          
          problematic_patterns.each do |pattern|
            gemfile_content.gsub!(pattern) { |match| "# #{match} # Commented out for testing" }
          end
          
          File.write(gemfile_path, gemfile_content)
          gemfile_msg = "✅ Cleaned up Gemfile"
          puts gemfile_msg
          log.puts gemfile_msg
        end
        
        # Clean up boot.rb
        boot_path = File.join(dest_path, "config", "boot.rb")
        if File.exist?(boot_path)
          boot_content = File.read(boot_path)
          boot_content.gsub!(/^require\s+['"]active_data_flow['"].*$/, "# require 'active_data_flow' # Commented out for testing")
          File.write(boot_path, boot_content)
          boot_msg = "✅ Cleaned up boot.rb"
          puts boot_msg
          log.puts boot_msg
        end
        
        # Clean up or remove ActiveDataFlow initializer
        initializer_path = File.join(dest_path, "config", "initializers", "active_data_flow.rb")
        if File.exist?(initializer_path)
          File.delete(initializer_path)
          init_msg = "✅ Removed ActiveDataFlow initializer"
          puts init_msg
          log.puts init_msg
        end
      
        # Step 6: Run the template and capture git diff
        puts "\n6️⃣ Running git-template and capturing changes..."
        log.puts "\n6️⃣ Running git-template and capturing changes..."
        
        # Initialize template_result variable before Dir.chdir block
        template_result = false
        
        Dir.chdir(dest_path) do
          # Initialize git repo if not exists
          unless File.directory?(".git")
            git_init_msg = "📝 Initializing git repository..."
            puts git_init_msg
            log.puts git_init_msg
            system("git init", out: File::NULL, err: File::NULL)
            system("git add .", out: File::NULL, err: File::NULL)
            system("git commit -m 'Initial commit before template'", out: File::NULL, err: File::NULL)
          end
          
          # Install gems first
          bundle_msg = "📦 Installing gems..."
          puts bundle_msg
          log.puts bundle_msg
          system("bundle install")
          
          # Apply the template
          # First check if there's a local .git_template/template.rb
          local_template_path = File.join(Dir.pwd, ".git_template", "template.rb")
          template_path = if File.exist?(local_template_path)
            local_template_path
          else
            File.join(git_template_root, "template.rb")
          end
          
          template_msg = "🔧 Applying template: #{template_path}"
          puts template_msg
          log.puts template_msg
          
          # Run the template (assuming it's a Rails app)
          if File.exist?("bin/rails")
            # Set environment variables to make template non-interactive
            env_vars = {
              "RAILS_TEMPLATE_NON_INTERACTIVE" => "true",
              "TEMPLATE_USE_REDIS" => "false",
              "TEMPLATE_USE_ACTIVE_DATA_FLOW" => "false", 
              "TEMPLATE_USE_DOCKER" => "false",
              "TEMPLATE_GENERATE_SAMPLE_MODELS" => "false",
              "TEMPLATE_SETUP_ADMIN" => "false",
              "THOR_MERGE" => "true",  # Auto-overwrite files without prompting
              "THOR_SHELL" => "Basic",  # Use basic shell (non-interactive)
              "RAILS_ENV" => "development"  # Ensure consistent environment
            }
            
            puts "Environment variables:"
            log.puts "Environment variables:"
            env_vars.each do |k, v| 
              env_line = "  #{k}=#{v}"
              puts env_line
              log.puts env_line
            end
            puts ""
            log.puts ""
            
            # Use non-interactive template execution
            template_result = execute_template_non_interactive(template_path, env_vars, log)
            result_msg = "Template execution result: #{template_result}"
            puts result_msg
            log.puts result_msg
          else
            warning_msg = "⚠️  Warning: Not a Rails app, skipping template application"
            puts warning_msg
            log.puts warning_msg
            template_result = true  # Consider it successful if no Rails app to process
          end
          
          # Capture git status and diff to separate log files
          puts "\n📊 Capturing git changes to log files..."
          log.puts "\n📊 Capturing git changes to log files..."
          
          # Capture git status
          status_output = `git status --porcelain`
          File.write(git_status_log, status_output)
          
          # Capture git diff
          system("git add .")
          diff_output = `git diff --cached --no-color`
          File.write(git_diff_log, diff_output)
          
          # Show status on console
          puts "\n📋 Git Status:"
          puts status_output
          
          # Count changes for summary
          modified_files = status_output.lines.select { |line| line.start_with?(' M') }.count
          new_files = status_output.lines.select { |line| line.start_with?('??') }.count
          deleted_files = status_output.lines.select { |line| line.start_with?(' D') }.count
          
          # Check if template is repeatable (no changes on second run)
          total_changes = modified_files + new_files + deleted_files
          is_repeatable = total_changes == 0 && template_result
          
          # Determine test result
          test_result = if is_repeatable
            "✅ No difference, test passed"
          elsif template_result && total_changes > 0
            "⚠️  Template applied successfully but made changes"
          else
            "❌ Template execution failed or had errors"
          end
          
          # Create summary
          summary_content = <<~SUMMARY
            Git Template Test Summary
            ========================
            Timestamp: #{Time.now}
            Templated app path: #{templated_app_path}
            Test directory: #{dest_path}
            
            Results:
            • #{modified_files} files modified
            • #{new_files} new files created
            • #{deleted_files} files deleted
            • Template execution: #{template_result ? 'SUCCESS' : 'FAILED'}
            • Test result: #{test_result}
            
            Repeatability: #{is_repeatable ? 'PASSED - Template is idempotent' : 'FAILED - Template makes changes on repeat runs'}
            
            Log Files:
            • Main execution log: #{main_log}
            • Git status: #{git_status_log}
            • Git diff: #{git_diff_log}
            • This summary: #{summary_log}
          SUMMARY
          
          File.write(summary_log, summary_content)
          
          puts "\n📊 Summary:"
          puts "  • #{modified_files} files modified"
          puts "  • #{new_files} new files created"
          puts "  • #{deleted_files} files deleted"
          puts "  • Template execution: #{template_result ? 'SUCCESS' : 'FAILED'}"
          puts ""
          puts "🔄 Repeatability Test:"
          if is_repeatable
            puts "  ✅ No difference, test passed"
            puts "  📋 Template is idempotent (safe to run multiple times)"
          else
            puts "  ⚠️  Template made changes on this run"
            puts "  📋 This may be expected for first-time application"
          end
          puts ""
          puts "📁 Test results available in: #{dest_path}"
          puts "📋 Logs saved to: #{log_dir}"
          puts "  • Main log: #{File.basename(main_log)}"
          puts "  • Git status: #{File.basename(git_status_log)}"
          puts "  • Git diff: #{File.basename(git_diff_log)}"
          puts "  • Summary: #{File.basename(summary_log)}"
          
          log.puts "\n📊 Summary:"
          log.puts "  • #{modified_files} files modified"
          log.puts "  • #{new_files} new files created"
          log.puts "  • #{deleted_files} files deleted"
          log.puts "  • Template execution: #{template_result ? 'SUCCESS' : 'FAILED'}"
          log.puts "  • Test result: #{test_result}"
          log.puts "  • Repeatability: #{is_repeatable ? 'PASSED' : 'FAILED'}"
          log.puts "📁 Test results available in: #{dest_path}"
          log.puts "📋 Logs saved to: #{log_dir}"
        end
      end
      
    rescue => e
      error_msg = "❌ Error during template test: #{e.message}"
      puts error_msg
      
      # Log error if log file is available
      if defined?(log) && log
        log.puts error_msg
        log.puts "Backtrace:" if ENV["DEBUG"]
        log.puts e.backtrace.join("\n") if ENV["DEBUG"]
      end
      
      puts e.backtrace if ENV["DEBUG"]
      exit 1
    end

    desc "prepare_templated_folder FOLDER", "Prepare a templated folder with Ruby and Rails versions from source folder"
    option :verbose, type: :boolean, default: false, desc: "Show verbose output"
    option :debug, type: :boolean, default: false, desc: "Show debug information"
    def prepare_templated_folder(folder_path)
      setup_environment(options)
      
      begin
        puts "🔧 Preparing templated folder for #{folder_path}..."
        
        # Step 1: Create TemplaterFolder instance
        templater_folder = GitTemplate::Models::TemplaterFolder.new(folder_path)
        
        unless templater_folder.exists?
          puts "❌ Error: Source folder '#{folder_path}' does not exist"
          exit 1
        end
        
        # Step 2: Determine templated folder path
        templated_path = templater_folder.templated_folder_path
        if templated_path.nil?
          # Create default templated path
          templated_path = File.join('templated', folder_path)
        end
        
        puts "📁 Source folder: #{templater_folder.expanded_path}"
        puts "📁 Templated folder: #{File.expand_path(templated_path)}"
        
        # Step 3: Create templated folder
        puts "\n1️⃣ Creating templated folder structure..."
        FileUtils.mkdir_p(templated_path)
        puts "✅ Created: #{templated_path}"
        
        # Step 4: Copy source folder to templated folder
        puts "\n2️⃣ Copying source folder to templated location..."
        Dir.glob(File.join(templater_folder.expanded_path, "*"), File::FNM_DOTMATCH).each do |item|
          next if File.basename(item) == '.' || File.basename(item) == '..'
          
          dest_item = File.join(templated_path, File.basename(item))
          if File.directory?(item)
            FileUtils.cp_r(item, dest_item)
          else
            FileUtils.cp(item, dest_item)
          end
        end
        puts "✅ Copied source folder contents"
        
        # Step 5: Read version files from source
        puts "\n3️⃣ Reading version requirements from source folder..."
        
        ruby_version_file = File.join(templater_folder.expanded_path, '.ruby-version')
        rails_version_file = File.join(templater_folder.expanded_path, '.rails-version')
        
        ruby_version = nil
        rails_version = nil
        
        if File.exist?(ruby_version_file)
          ruby_version = File.read(ruby_version_file).strip
          puts "📋 Found Ruby version: #{ruby_version}"
        else
          puts "⚠️  No .ruby-version file found in source"
        end
        
        if File.exist?(rails_version_file)
          rails_version = File.read(rails_version_file).strip
          puts "📋 Found Rails version: #{rails_version}"
        else
          puts "⚠️  No .rails-version file found in source"
        end
        
        # Step 6: Prepare Ruby environment
        puts "\n4️⃣ Preparing Ruby environment..."
        Dir.chdir(templated_path) do
          if ruby_version
            # Check current Ruby version
            current_ruby = RUBY_VERSION
            if Gem::Version.new(current_ruby) >= Gem::Version.new(ruby_version)
              puts "✅ Ruby #{current_ruby} meets requirement (>= #{ruby_version})"
            else
              puts "⚠️  Ruby #{current_ruby} is below required #{ruby_version}"
              puts "   Consider using rbenv or rvm to switch Ruby versions"
            end
            
            # Ensure .ruby-version exists in templated folder
            unless File.exist?('.ruby-version')
              File.write('.ruby-version', ruby_version)
              puts "✅ Created .ruby-version file"
            end
          else
            puts "⚠️  No Ruby version specified, using current: #{RUBY_VERSION}"
          end
        end
        
        # Step 7: Prepare Rails environment
        puts "\n5️⃣ Preparing Rails environment..."
        Dir.chdir(templated_path) do
          if rails_version
            # Check if Rails is available and meets version requirement
            begin
              require 'rails'
              current_rails = Rails::VERSION::STRING
              if Gem::Version.new(current_rails) >= Gem::Version.new(rails_version)
                puts "✅ Rails #{current_rails} meets requirement (>= #{rails_version})"
              else
                puts "⚠️  Rails #{current_rails} is below required #{rails_version}"
                puts "   Consider updating Rails: gem install rails -v '~> #{rails_version}'"
              end
            rescue LoadError
              puts "⚠️  Rails not available, may need to install Rails #{rails_version}"
              puts "   Install with: gem install rails -v '~> #{rails_version}'"
            end
            
            # Ensure .rails-version exists in templated folder
            unless File.exist?('.rails-version')
              File.write('.rails-version', rails_version)
              puts "✅ Created .rails-version file"
            end
            
            # Install gems if Gemfile exists
            if File.exist?('Gemfile')
              puts "📦 Installing gems..."
              if system('bundle install')
                puts "✅ Gems installed successfully"
              else
                puts "⚠️  Gem installation had issues, may need manual intervention"
              end
            end
          else
            puts "⚠️  No Rails version specified"
          end
        end
        
        # Step 8: Summary
        puts "\n✅ Templated folder preparation completed!"
        puts "📁 Templated folder: #{File.expand_path(templated_path)}"
        puts "🔧 Ruby version: #{ruby_version || 'not specified'}"
        puts "🚀 Rails version: #{rails_version || 'not specified'}"
        puts ""
        puts "Next steps:"
        puts "  1. Add .git_template configuration to: #{templated_path}/.git_template/"
        puts "  2. Create template.rb file for your template logic"
        puts "  3. Test the template with: git-template iterate #{folder_path}"
        
      rescue => e
        puts "❌ Error preparing templated folder: #{e.message}"
        puts e.backtrace if options[:debug]
        exit 1
      end
    end

    desc "verify_templated_folder FOLDER", "Verify templated folder setup and version compatibility"
    option :verbose, type: :boolean, default: false, desc: "Show verbose output"
    option :debug, type: :boolean, default: false, desc: "Show debug information"
    option :check_templated, type: :boolean, default: true, desc: "Also check the templated version folder"
    def verify_templated_folder(folder_path)
      setup_environment(options)
      
      begin
        puts "🔍 Verifying templated folder setup for #{folder_path}..."
        
        # Step 1: Analyze source folder
        puts "\n1️⃣ Analyzing source folder..."
        source_folder = GitTemplate::Models::TemplaterFolder.new(folder_path)
        
        unless source_folder.exists?
          puts "❌ Error: Source folder '#{folder_path}' does not exist"
          exit 1
        end
        
        puts "📁 Source folder: #{source_folder.expanded_path}"
        
        # Check source folder structure
        puts "\n📋 Source Folder Analysis:"
        puts "  • Exists: #{source_folder.exists? ? '✅' : '❌'}"
        puts "  • Git repository: #{source_folder.git_repository? ? '✅' : '⚠️'}"
        puts "  • Template configuration: #{source_folder.has_template_configuration? ? '✅' : '⚠️'}"
        
        # Step 2: Check version compatibility in source
        puts "\n2️⃣ Checking version compatibility in source folder..."
        source_versions = source_folder.version_check_results
        
        # Ruby version check
        ruby_check = source_versions[:ruby]
        puts "\n🔴 Ruby Version Check:"
        puts "  • .ruby-version file: #{ruby_check[:file_exists] ? '✅' : '❌'}"
        if ruby_check[:file_exists]
          puts "  • Required version: #{ruby_check[:required]}"
          puts "  • Current version: #{ruby_check[:current]}"
          puts "  • Compatible: #{ruby_check[:compatible] ? '✅' : '❌'}"
        end
        
        # Rails version check
        rails_check = source_versions[:rails]
        puts "\n🚀 Rails Version Check:"
        puts "  • .rails-version file: #{rails_check[:file_exists] ? '✅' : '❌'}"
        if rails_check[:file_exists]
          puts "  • Required version: #{rails_check[:required]}"
          puts "  • Current version: #{rails_check[:current] || 'Not available'}"
          puts "  • Available: #{rails_check[:available] ? '✅' : '❌'}"
          puts "  • Compatible: #{rails_check[:compatible] ? '✅' : '❌'}"
        end
        
        # Step 3: Check templated folder if it exists and option is enabled
        if options[:check_templated] && source_folder.templated_folder_exists?
          puts "\n3️⃣ Analyzing templated folder..."
          templated_folder = source_folder.templated_folder
          puts "📁 Templated folder: #{templated_folder.expanded_path}"
          
          puts "\n📋 Templated Folder Analysis:"
          puts "  • Exists: #{templated_folder.exists? ? '✅' : '❌'}"
          puts "  • Git repository: #{templated_folder.git_repository? ? '✅' : '⚠️'}"
          puts "  • Template configuration: #{templated_folder.has_template_configuration? ? '✅' : '❌'}"
          
          # Check version compatibility in templated folder
          templated_versions = templated_folder.version_check_results
          
          puts "\n🔄 Templated Folder Version Compatibility:"
          
          # Compare Ruby versions
          templated_ruby = templated_versions[:ruby]
          puts "\n🔴 Ruby (Templated):"
          puts "  • .ruby-version file: #{templated_ruby[:file_exists] ? '✅' : '❌'}"
          if templated_ruby[:file_exists]
            puts "  • Required version: #{templated_ruby[:required]}"
            puts "  • Matches source: #{ruby_check[:required] == templated_ruby[:required] ? '✅' : '❌'}"
            puts "  • Compatible: #{templated_ruby[:compatible] ? '✅' : '❌'}"
          end
          
          # Compare Rails versions
          templated_rails = templated_versions[:rails]
          puts "\n🚀 Rails (Templated):"
          puts "  • .rails-version file: #{templated_rails[:file_exists] ? '✅' : '❌'}"
          if templated_rails[:file_exists]
            puts "  • Required version: #{templated_rails[:required]}"
            puts "  • Matches source: #{rails_check[:required] == templated_rails[:required] ? '✅' : '❌'}"
            puts "  • Available: #{templated_rails[:available] ? '✅' : '❌'}"
            puts "  • Compatible: #{templated_rails[:compatible] ? '✅' : '❌'}"
          end
        elsif options[:check_templated]
          puts "\n3️⃣ Templated folder check requested but folder doesn't exist"
          puts "📁 Expected location: #{source_folder.templated_folder_path || 'Not determined'}"
          puts "💡 Use 'git-template prepare_templated_folder #{folder_path}' to create it"
        end
        
        # Step 4: Overall assessment
        puts "\n4️⃣ Overall Assessment:"
        
        issues = []
        warnings = []
        
        # Check for critical issues
        issues << "Source folder does not exist" unless source_folder.exists?
        issues << "Ruby version incompatible" if ruby_check[:file_exists] && !ruby_check[:compatible]
        issues << "Rails not available" if rails_check[:file_exists] && !rails_check[:available]
        issues << "Rails version incompatible" if rails_check[:file_exists] && rails_check[:available] && !rails_check[:compatible]
        
        # Check for warnings
        warnings << "No .ruby-version file found" unless ruby_check[:file_exists]
        warnings << "No .rails-version file found" unless rails_check[:file_exists]
        warnings << "Source folder is not a git repository" unless source_folder.git_repository?
        warnings << "No template configuration found" unless source_folder.has_template_configuration?
        
        if options[:check_templated] && source_folder.templated_folder_exists?
          templated_versions = source_folder.templated_folder.version_check_results
          issues << "Templated folder Ruby version mismatch" if ruby_check[:required] != templated_versions[:ruby][:required]
          issues << "Templated folder Rails version mismatch" if rails_check[:required] != templated_versions[:rails][:required]
        end
        
        # Display results
        if issues.empty?
          puts "✅ No critical issues found!"
        else
          puts "❌ Critical Issues Found:"
          issues.each { |issue| puts "  • #{issue}" }
        end
        
        if warnings.any?
          puts "\n⚠️  Warnings:"
          warnings.each { |warning| puts "  • #{warning}" }
        end
        
        # Recommendations
        puts "\n💡 Recommendations:"
        if issues.empty? && warnings.empty?
          puts "  • Setup looks good! Ready for template development."
        else
          puts "  • Address critical issues before proceeding with template development"
          puts "  • Consider resolving warnings for better template reliability"
          
          if !source_folder.templated_folder_exists?
            puts "  • Run: git-template prepare_templated_folder #{folder_path}"
          end
          
          if ruby_check[:file_exists] && !ruby_check[:compatible]
            puts "  • Upgrade Ruby to version #{ruby_check[:required]} or higher"
          end
          
          if rails_check[:file_exists] && !rails_check[:available]
            puts "  • Install Rails: gem install rails -v '~> #{rails_check[:required]}'"
          elsif rails_check[:file_exists] && !rails_check[:compatible]
            puts "  • Upgrade Rails to version #{rails_check[:required]} or higher"
          end
        end
        
        # Exit with appropriate code
        exit 1 unless issues.empty?
        
      rescue => e
        puts "❌ Error verifying templated folder: #{e.message}"
        puts e.backtrace if options[:debug]
        exit 1
      end
    end

    desc "unrun_template FOLDER", "Delete all files except .git_template folder to reset template state"
    option :verbose, type: :boolean, default: false, desc: "Show verbose output"
    option :debug, type: :boolean, default: false, desc: "Show debug information"
    option :force, type: :boolean, default: false, desc: "Skip confirmation prompt"
    option :preserve_git, type: :boolean, default: true, desc: "Preserve .git folder"
    option :preserve_files, type: :array, default: [], desc: "Additional files/folders to preserve (e.g., --preserve-files=README.md,.env)"
    def unrun_template(folder_path)
      setup_environment(options)
      
      begin
        puts "🧹 Preparing to unrun template for #{folder_path}..."
        
        # Step 1: Validate folder
        templater_folder = GitTemplate::Models::TemplaterFolder.new(folder_path)
        
        unless templater_folder.exists?
          puts "❌ Error: Folder '#{folder_path}' does not exist"
          exit 1
        end
        
        unless templater_folder.has_template_configuration?
          puts "❌ Error: Folder '#{folder_path}' does not have a .git_template configuration"
          puts "   This command is only for folders with template configurations"
          exit 1
        end
        
        puts "📁 Target folder: #{templater_folder.expanded_path}"
        puts "🔧 Template config: #{templater_folder.template_configuration_path}"
        
        # Step 2: Determine what to preserve
        preserved_items = ['.git_template']
        preserved_items << '.git' if options[:preserve_git]
        
        # Handle preserve_files - split comma-separated values and flatten
        if options[:preserve_files].any?
          additional_files = options[:preserve_files].flat_map { |item| item.split(',') }.map(&:strip)
          preserved_items.concat(additional_files)
        end
        
        puts "\n📋 Items to preserve:"
        preserved_items.each { |item| puts "  • #{item}" }
        
        # Step 3: Scan for items to delete
        items_to_delete = []
        
        Dir.glob(File.join(templater_folder.expanded_path, "*"), File::FNM_DOTMATCH).each do |item|
          item_name = File.basename(item)
          next if item_name == '.' || item_name == '..'
          next if preserved_items.include?(item_name)
          
          # Check if it matches any preserve pattern
          should_preserve = preserved_items.any? do |pattern|
            File.fnmatch(pattern, item_name, File::FNM_DOTMATCH)
          end
          
          items_to_delete << item unless should_preserve
        end
        
        if items_to_delete.empty?
          puts "\n✅ No items to delete - folder already contains only preserved items"
          return
        end
        
        puts "\n🗑️  Items to delete:"
        items_to_delete.each do |item|
          item_type = File.directory?(item) ? "📁" : "📄"
          puts "  #{item_type} #{File.basename(item)}"
        end
        
        puts "\n📊 Summary:"
        puts "  • #{items_to_delete.count} items will be deleted"
        puts "  • #{preserved_items.count} items will be preserved"
        
        # Step 4: Confirmation
        unless options[:force]
          puts "\n⚠️  WARNING: This action cannot be undone!"
          puts "Are you sure you want to delete #{items_to_delete.count} items from #{folder_path}?"
          print "Type 'yes' to continue: "
          
          response = STDIN.gets.chomp.downcase
          unless response == 'yes'
            puts "❌ Operation cancelled"
            exit 0
          end
        end
        
        # Step 5: Delete items
        puts "\n🗑️  Deleting items..."
        deleted_count = 0
        errors = []
        
        items_to_delete.each do |item|
          begin
            item_name = File.basename(item)
            
            if File.directory?(item)
              FileUtils.rm_rf(item)
              puts "  📁 Deleted directory: #{item_name}" if options[:verbose]
            else
              FileUtils.rm(item)
              puts "  📄 Deleted file: #{item_name}" if options[:verbose]
            end
            
            deleted_count += 1
          rescue => e
            error_msg = "Failed to delete #{File.basename(item)}: #{e.message}"
            errors << error_msg
            puts "  ❌ #{error_msg}"
          end
        end
        
        # Step 6: Results
        puts "\n📊 Results:"
        puts "  • #{deleted_count} items deleted successfully"
        puts "  • #{errors.count} errors encountered" if errors.any?
        
        if errors.any?
          puts "\n❌ Errors encountered:"
          errors.each { |error| puts "  • #{error}" }
        end
        
        # Step 7: Verify template configuration still exists
        if templater_folder.has_template_configuration?
          puts "\n✅ Template configuration preserved successfully"
          puts "📁 Template folder: #{templater_folder.template_configuration_path}"
          
          # Show what's left
          remaining_items = Dir.glob(File.join(templater_folder.expanded_path, "*"), File::FNM_DOTMATCH)
                              .reject { |item| ['.', '..'].include?(File.basename(item)) }
          
          puts "\n📋 Remaining items:"
          remaining_items.each do |item|
            item_type = File.directory?(item) ? "📁" : "📄"
            puts "  #{item_type} #{File.basename(item)}"
          end
          
          puts "\n💡 Next steps:"
          puts "  1. The folder is now reset to template-only state"
          puts "  2. You can apply the template again with: git-template iterate #{folder_path}"
          puts "  3. Or modify the template configuration in: #{File.basename(templater_folder.template_configuration_path)}"
        else
          puts "\n❌ Warning: Template configuration appears to have been deleted!"
        end
        
        if errors.any?
          exit 1
        end
        
      rescue => e
        puts "❌ Error unrunning template: #{e.message}"
        puts e.backtrace if options[:debug]
        exit 1
      end
    end

    desc "run_template FOLDER", "Clean folder to template-only state, copy version files, and execute template"
    option :verbose, type: :boolean, default: false, desc: "Show verbose output"
    option :debug, type: :boolean, default: false, desc: "Show debug information"
    option :force, type: :boolean, default: false, desc: "Skip confirmation prompt for cleanup"
    option :source_folder, type: :string, desc: "Source folder to copy version files from (defaults to corresponding source folder)"
    def run_template(folder_path)
      setup_environment(options)
      
      begin
        puts "🚀 Running template for #{folder_path}..."
        
        # Step 1: Validate folder and find source
        templater_folder = GitTemplate::Models::TemplaterFolder.new(folder_path)
        
        unless templater_folder.exists?
          puts "❌ Error: Folder '#{folder_path}' does not exist"
          exit 1
        end
        
        unless templater_folder.has_template_configuration?
          puts "❌ Error: Folder '#{folder_path}' does not have a .git_template configuration"
          exit 1
        end
        
        # Determine source folder for version files
        source_folder_path = options[:source_folder]
        if source_folder_path.nil?
          # Try to find corresponding source folder
          # If we're in templated/examples/rails/rails8-simple, source should be examples/rails/rails8-simple
          if folder_path.start_with?('templated/')
            source_folder_path = folder_path.sub(/^templated\//, '')
          else
            puts "❌ Error: Cannot determine source folder for version files"
            puts "   Please specify --source-folder option"
            exit 1
          end
        end
        
        source_folder = GitTemplate::Models::TemplaterFolder.new(source_folder_path)
        unless source_folder.exists?
          puts "❌ Error: Source folder '#{source_folder_path}' does not exist"
          exit 1
        end
        
        puts "📁 Target folder: #{templater_folder.expanded_path}"
        puts "📁 Source folder: #{source_folder.expanded_path}"
        puts "🔧 Template config: #{templater_folder.template_configuration_path}"
        
        # Step 2: Clean folder (ensure only .git_template exists)
        puts "\n1️⃣ Cleaning folder to template-only state..."
        
        # Find items to delete (everything except .git_template)
        items_to_delete = []
        Dir.glob(File.join(templater_folder.expanded_path, "*"), File::FNM_DOTMATCH).each do |item|
          item_name = File.basename(item)
          next if item_name == '.' || item_name == '..' || item_name == '.git_template'
          items_to_delete << item
        end
        
        if items_to_delete.any?
          puts "🗑️  Found #{items_to_delete.count} items to clean up:"
          items_to_delete.each do |item|
            item_type = File.directory?(item) ? "📁" : "📄"
            puts "  #{item_type} #{File.basename(item)}"
          end
          
          unless options[:force]
            puts "\n⚠️  This will delete #{items_to_delete.count} items to prepare for template execution"
            print "Continue? (y/N): "
            response = STDIN.gets.chomp.downcase
            unless ['y', 'yes'].include?(response)
              puts "❌ Operation cancelled"
              exit 0
            end
          end
          
          # Delete items
          deleted_count = 0
          items_to_delete.each do |item|
            begin
              if File.directory?(item)
                FileUtils.rm_rf(item)
              else
                FileUtils.rm(item)
              end
              deleted_count += 1
              puts "  🗑️  Deleted: #{File.basename(item)}" if options[:verbose]
            rescue => e
              puts "  ❌ Failed to delete #{File.basename(item)}: #{e.message}"
            end
          end
          
          puts "✅ Cleaned #{deleted_count} items"
        else
          puts "✅ Folder already clean (contains only .git_template)"
        end
        
        # Step 3: Copy version files from source
        puts "\n2️⃣ Copying version files from source..."
        
        version_files_copied = 0
        
        # Copy .ruby-version if it exists in source
        source_ruby_version = source_folder.ruby_version_file
        if File.exist?(source_ruby_version)
          target_ruby_version = File.join(templater_folder.expanded_path, '.ruby-version')
          FileUtils.cp(source_ruby_version, target_ruby_version)
          ruby_version = File.read(source_ruby_version).strip
          puts "📋 Copied .ruby-version: #{ruby_version}"
          version_files_copied += 1
        else
          puts "⚠️  No .ruby-version file found in source folder"
        end
        
        # Copy .rails-version if it exists in source
        source_rails_version = source_folder.rails_version_file
        if File.exist?(source_rails_version)
          target_rails_version = File.join(templater_folder.expanded_path, '.rails-version')
          FileUtils.cp(source_rails_version, target_rails_version)
          rails_version = File.read(source_rails_version).strip
          puts "📋 Copied .rails-version: #{rails_version}"
          version_files_copied += 1
        else
          puts "⚠️  No .rails-version file found in source folder"
        end
        
        if version_files_copied == 0
          puts "⚠️  No version files found to copy"
        else
          puts "✅ Copied #{version_files_copied} version files"
        end
        
        # Step 4: Execute template
        puts "\n3️⃣ Executing template..."
        
        template_file = File.join(templater_folder.template_configuration_path, 'template.rb')
        unless File.exist?(template_file)
          puts "❌ Error: Template file not found: #{template_file}"
          exit 1
        end
        
        puts "🔧 Template file: #{template_file}"
        
        # Change to target directory and execute template
        original_dir = Dir.pwd
        template_success = false
        
        begin
          Dir.chdir(templater_folder.expanded_path)
          
          # Check if this looks like a Rails app structure or if we need to create one
          needs_rails_new = !File.exist?('config/application.rb')
          
          if needs_rails_new
            puts "📦 Creating new Rails application structure..."
            
            # Get Rails version for rails new command
            rails_version = templater_folder.required_rails_version
            rails_cmd = rails_version ? "rails _#{rails_version}_ new" : "rails new"
            
            # Create Rails app in current directory
            system("#{rails_cmd} . --skip-git --force")
            
            if File.exist?('config/application.rb')
              puts "✅ Rails application created successfully"
            else
              puts "❌ Failed to create Rails application"
              exit 1
            end
          end
          
          # Initialize git if not present
          unless File.directory?('.git')
            puts "📝 Initializing git repository..."
            system('git init', out: File::NULL, err: File::NULL)
            system('git add .', out: File::NULL, err: File::NULL)
            system('git commit -m "Initial commit before template"', out: File::NULL, err: File::NULL)
          end
          
          # Execute the template
          puts "🎯 Applying template..."
          
          # Set environment variables for non-interactive execution
          env_vars = {
            "RAILS_TEMPLATE_NON_INTERACTIVE" => "true",
            "TEMPLATE_USE_REDIS" => "false",
            "TEMPLATE_USE_ACTIVE_DATA_FLOW" => "false",
            "TEMPLATE_USE_DOCKER" => "false",
            "TEMPLATE_GENERATE_SAMPLE_MODELS" => "false",
            "TEMPLATE_SETUP_ADMIN" => "false",
            "THOR_MERGE" => "true",
            "THOR_SHELL" => "Basic",
            "RAILS_ENV" => "development"
          }
          
          if options[:verbose]
            puts "Environment variables:"
            env_vars.each { |k, v| puts "  #{k}=#{v}" }
          end
          
          # Execute template using Rails
          if File.exist?('bin/rails')
            template_success = system(env_vars, "bin/rails app:template LOCATION=#{template_file}")
          else
            # Fallback: execute template directly with Ruby
            template_success = system(env_vars, "ruby #{template_file}")
          end
          
          if template_success
            puts "✅ Template executed successfully"
          else
            puts "❌ Template execution failed"
            exit 1
          end
          
        ensure
          Dir.chdir(original_dir)
        end
        
        # Step 5: Summary and next steps
        puts "\n4️⃣ Template execution completed!"
        puts "📁 Target folder: #{templater_folder.expanded_path}"
        puts "🔧 Template applied: #{File.basename(template_file)}"
        
        # Show what was created
        Dir.chdir(templater_folder.expanded_path) do
          created_items = Dir.glob("*", File::FNM_DOTMATCH)
                            .reject { |item| ['.', '..'].include?(item) }
                            .sort
          
          puts "\n📋 Folder contents after template execution:"
          created_items.each do |item|
            item_type = File.directory?(item) ? "📁" : "📄"
            puts "  #{item_type} #{item}"
          end
        end
        
        puts "\n💡 Next steps:"
        puts "  1. Review the generated application structure"
        puts "  2. Test the application: cd #{folder_path} && bin/dev"
        puts "  3. Make any necessary adjustments to the template"
        puts "  4. Use 'git-template iterate' to refine the template"
        
      rescue => e
        puts "❌ Error running template: #{e.message}"
        puts e.backtrace if options[:debug]
        exit 1
      end
    end

    desc "check_target", "Apply template to target app and compare with templated version"
    option :target, type: :string, required: true, desc: "Path to base Rails app (e.g., examples/rails/rails8-juris)"
    option :templated, type: :string, required: true, desc: "Path to templated version with .git_template (e.g., templated/examples/rails/rails8-juris)"
    def check_target
      require "fileutils"
      require "time"
      
      target_path = options[:target]
      templated_path = options[:templated]
      
      # Create log directory and timestamp
      timestamp = Time.now.strftime("%Y%m%d_%H%M%S")
      log_dir = File.join(Dir.pwd, "log", "check-target", timestamp)
      FileUtils.mkdir_p(log_dir)
      
      # Create log files
      main_log = File.join(log_dir, "check_execution.log")
      diff_log = File.join(log_dir, "differences.log")
      summary_log = File.join(log_dir, "summary.log")
      
      puts "🔍 Starting target comparison..."
      puts "Target template: #{target_path}"
      puts "Templated version: #{templated_path}"
      puts "📁 Logs will be saved to: #{log_dir}"
      
      # Start logging
      File.open(main_log, 'w') do |log|
        log.puts "Git Template Target Comparison Log"
        log.puts "=" * 50
        log.puts "Timestamp: #{Time.now}"
        log.puts "Target template: #{target_path}"
        log.puts "Templated version: #{templated_path}"
        log.puts "Log directory: #{log_dir}"
        log.puts "=" * 50
        log.puts ""
        
        begin
          # Step 1: Validate paths exist
          puts "\n1️⃣ Validating paths..."
          log.puts "1️⃣ Validating paths..."
          
          git_template_root = File.expand_path(Dir.pwd)
          target_full_path = File.join(git_template_root, target_path)
          templated_full_path = File.join(git_template_root, templated_path)
          
          unless File.directory?(target_full_path)
            error_msg = "❌ Target path does not exist: #{target_full_path}"
            puts error_msg
            log.puts error_msg
            exit 1
          end
          
          unless File.directory?(templated_full_path)
            error_msg = "❌ Templated path does not exist: #{templated_full_path}"
            puts error_msg
            log.puts error_msg
            exit 1
          end
          
          templated_template_file = File.join(templated_full_path, ".git_template", "template.rb")
          unless File.exist?(templated_template_file)
            error_msg = "❌ Templated version template file not found: #{templated_template_file}"
            puts error_msg
            log.puts error_msg
            exit 1
          end
          
          success_msg = "✅ All paths validated successfully"
          puts success_msg
          log.puts success_msg
          
          # Step 2: Apply template to target and compare with templated version
          puts "\n2️⃣ Creating temporary test environment..."
          log.puts "2️⃣ Creating temporary test environment..."
          
          # Create temporary directory for testing
          test_dir = File.join(Dir.pwd, "template_test_comparison")
          FileUtils.rm_rf(test_dir) if File.exist?(test_dir)
          FileUtils.mkdir_p(test_dir)
          
          # Copy target to test directory and add template from templated version
          target_test_path = File.join(test_dir, "target_applied")
          FileUtils.cp_r(target_full_path, target_test_path)
          
          # Copy the .git_template directory from templated version to target copy
          templated_git_template = File.join(templated_full_path, ".git_template")
          target_git_template = File.join(target_test_path, ".git_template")
          FileUtils.cp_r(templated_git_template, target_git_template)
          
          # Clean up problematic files for testing
          cleanup_msg = "🧹 Cleaning up files for testing..."
          puts cleanup_msg
          log.puts cleanup_msg
          
          # Clean up Gemfile
          gemfile_path = File.join(target_test_path, "Gemfile")
          if File.exist?(gemfile_path)
            gemfile_content = File.read(gemfile_path)
            
            # Remove problematic gem references (path-based gems that won't exist)
            problematic_patterns = [
              /^gem\s+["']active_data_flow["'].*$/,
              /^gem\s+["']active_data_flow-.*$/,
              /^gem\s+["']redis-emulator["'].*$/,
              /^gem\s+["']submoduler-core.*$/,
              /^#gem\s+["']submoduler-core.*$/,
              /path:\s*["'][^"']*active_data_flow[^"']*["']/,
              /path:\s*["'][^"']*redis-emulator[^"']*["']/,
              /path:\s*["'][^"']*submoduler[^"']*["']/
            ]
            
            problematic_patterns.each do |pattern|
              gemfile_content.gsub!(pattern) { |match| "# #{match} # Commented out for testing" }
            end
            
            File.write(gemfile_path, gemfile_content)
            cleanup_gemfile_msg = "✅ Cleaned up Gemfile (removed path-based gems)"
            puts cleanup_gemfile_msg
            log.puts cleanup_gemfile_msg
          end
          
          # Clean up boot.rb
          boot_path = File.join(target_test_path, "config", "boot.rb")
          if File.exist?(boot_path)
            boot_content = File.read(boot_path)
            boot_content.gsub!(/^require\s+['"]active_data_flow['"].*$/, "# require 'active_data_flow' # Commented out for testing")
            File.write(boot_path, boot_content)
            cleanup_boot_msg = "✅ Cleaned up boot.rb"
            puts cleanup_boot_msg
            log.puts cleanup_boot_msg
          end
          
          # Clean up or remove problematic initializers
          problematic_initializers = [
            "active_data_flow.rb",
            "redis_emulator.rb",
            "submoduler.rb"
          ]
          
          problematic_initializers.each do |initializer|
            initializer_path = File.join(target_test_path, "config", "initializers", initializer)
            if File.exist?(initializer_path)
              File.delete(initializer_path)
              cleanup_init_msg = "✅ Removed #{initializer} initializer"
              puts cleanup_init_msg
              log.puts cleanup_init_msg
            end
          end
          
          # Clean up application.rb if it has problematic requires
          app_rb_path = File.join(target_test_path, "config", "application.rb")
          if File.exist?(app_rb_path)
            app_content = File.read(app_rb_path)
            original_content = app_content.dup
            
            # Comment out problematic requires
            app_content.gsub!(/^require\s+['"]active_data_flow['"].*$/, "# require 'active_data_flow' # Commented out for testing")
            app_content.gsub!(/^require\s+['"]redis-emulator['"].*$/, "# require 'redis-emulator' # Commented out for testing")
            app_content.gsub!(/^require\s+['"]submoduler.*['"].*$/, "# require 'submoduler' # Commented out for testing")
            
            if app_content != original_content
              File.write(app_rb_path, app_content)
              cleanup_app_msg = "✅ Cleaned up application.rb"
              puts cleanup_app_msg
              log.puts cleanup_app_msg
            end
          end
          
          test_msg = "✅ Test environment created: #{test_dir}"
          puts test_msg
          log.puts test_msg
          
          # Step 3: Apply template to target copy
          puts "\n3️⃣ Applying template to target copy..."
          log.puts "3️⃣ Applying template to target copy..."
          
          # Initialize template_result variable
          template_result = false
          
          Dir.chdir(target_test_path) do
            # Initialize git repo if not exists
            unless File.directory?(".git")
              system("git init", out: File::NULL, err: File::NULL)
              system("git add .", out: File::NULL, err: File::NULL)
              system("git commit -m 'Initial commit'", out: File::NULL, err: File::NULL)
            end
            
            # Install npm dependencies first if package.json exists
            if File.exist?("package.json")
              npm_msg = "📦 Installing npm dependencies..."
              puts npm_msg
              log.puts npm_msg
              system("npm install")
            end
            
            # Apply the template
            template_path = File.join(Dir.pwd, ".git_template", "template.rb")
            
            if File.exist?("bin/rails")
              # Set environment variables for non-interactive mode
              env_vars = {
                "RAILS_TEMPLATE_NON_INTERACTIVE" => "true",
                "TEMPLATE_USE_REDIS" => "false",
                "TEMPLATE_USE_ACTIVE_DATA_FLOW" => "false", 
                "TEMPLATE_USE_DOCKER" => "false",
                "TEMPLATE_GENERATE_SAMPLE_MODELS" => "false",
                "TEMPLATE_SETUP_ADMIN" => "false",
                "THOR_MERGE" => "true",
                "THOR_SHELL" => "Basic",
                "RAILS_ENV" => "development"
              }
              
              # Use non-interactive template execution
              template_result = execute_template_non_interactive(template_path, env_vars, log)
              
              if template_result
                apply_msg = "✅ Template applied successfully"
                puts apply_msg
                log.puts apply_msg
              else
                error_msg = "❌ Template application failed"
                puts error_msg
                log.puts error_msg
                exit 1
              end
            else
              warning_msg = "⚠️  Not a Rails app, skipping template application"
              puts warning_msg
              log.puts warning_msg
            end
          end
          
          # Step 4: Compare the applied target with the templated version
          puts "\n4️⃣ Comparing applied target with templated version..."
          log.puts "4️⃣ Comparing applied target with templated version..."
          
          # Use git diff to compare directories
          diff_output = `diff -r --exclude='.git' --exclude='log' --exclude='tmp' --exclude='node_modules' --exclude='vendor/bundle' "#{target_test_path}" "#{templated_full_path}" 2>&1`
          diff_exit_code = $?.exitstatus
          
          # Save diff output
          File.write(diff_log, diff_output)
          
          # Analyze results
          if diff_exit_code == 0
            success_msg = "✅ SUCCESS: Target and templated versions are identical!"
            puts success_msg
            log.puts success_msg
            test_result = "PASSED"
          else
            warning_msg = "⚠️  DIFFERENCES FOUND: Target and templated versions differ"
            puts warning_msg
            log.puts warning_msg
            puts "📄 Differences saved to: #{diff_log}"
            log.puts "📄 Differences saved to: #{diff_log}"
            test_result = "FAILED"
            
            # Show summary of differences
            diff_lines = diff_output.lines
            file_diffs = diff_lines.select { |line| line.start_with?("Only in") || line.start_with?("Files") }.count
            puts "📊 Found #{file_diffs} file differences"
            log.puts "📊 Found #{file_diffs} file differences"
          end
          
          # Step 5: Create summary
          summary_content = <<~SUMMARY
            Git Template Target Comparison Summary
            =====================================
            Timestamp: #{Time.now}
            Target template: #{target_path}
            Templated version: #{templated_path}
            
            Results:
            • Test result: #{test_result}
            • Template application: #{template_result ? 'SUCCESS' : 'FAILED'}
            • Comparison: #{diff_exit_code == 0 ? 'IDENTICAL' : 'DIFFERENCES FOUND'}
            
            Log Files:
            • Main execution log: #{main_log}
            • Differences log: #{diff_log}
            • This summary: #{summary_log}
            
            Test Directory: #{test_dir}
          SUMMARY
          
          File.write(summary_log, summary_content)
          
          puts "\n📊 Summary:"
          puts "  • Test result: #{test_result}"
          puts "  • Template application: #{template_result ? 'SUCCESS' : 'FAILED'}"
          puts "  • Comparison: #{diff_exit_code == 0 ? 'IDENTICAL' : 'DIFFERENCES FOUND'}"
          puts ""
          puts "📁 Test directory: #{test_dir}"
          puts "📋 Logs saved to: #{log_dir}"
          puts "  • Main log: #{File.basename(main_log)}"
          puts "  • Differences: #{File.basename(diff_log)}"
          puts "  • Summary: #{File.basename(summary_log)}"
          puts ""
          
          if diff_exit_code == 0
            puts "🎉 Target comparison completed successfully!"
          else
            puts "⚠️  Target comparison found differences - review logs for details"
          end
          
        rescue => e
          error_msg = "❌ Error during target comparison: #{e.message}"
          puts error_msg
          log.puts error_msg
          log.puts "Backtrace:" if ENV["DEBUG"]
          log.puts e.backtrace.join("\n") if ENV["DEBUG"]
          puts e.backtrace if ENV["DEBUG"]
          exit 1
        end
      end
    rescue => e
      error_msg = "❌ Error during target comparison: #{e.message}"
      puts error_msg
      puts e.backtrace if ENV["DEBUG"]
      exit 1
    end

    def self.exit_on_failure?
      true
    end

    private

    def convert_template_to_markdown(template_content, folder_path)
      lines = template_content.lines
      markdown_lines = []
      current_section = nil
      code_block = []
      in_multiline_string = false
      multiline_delimiter = nil
      
      # Extract folder name for title
      folder_name = File.basename(folder_path)
      
      # Add header
      markdown_lines << "# #{folder_name.split('-').map(&:capitalize).join(' ')} Template Documentation"
      markdown_lines << ""
      
      # Extract initial comments as description
      description_lines = []
      lines.each do |line|
        stripped = line.strip
        if stripped.start_with?('#') && !stripped.start_with?('#~')
          description_lines << stripped[1..-1].strip
        elsif !stripped.empty? && !stripped.start_with?('#')
          break
        end
      end
      
      if description_lines.any?
        markdown_lines << description_lines.join("\n")
        markdown_lines << ""
      end
      
      lines.each do |line|
        stripped = line.strip
        
        # Check for phase markers
        if stripped.start_with?('#~')
          # Finish previous code block if exists
          if code_block.any?
            markdown_lines << "```ruby"
            markdown_lines.concat(code_block)
            markdown_lines << "```"
            markdown_lines << ""
            code_block = []
          end
          
          # Start new section
          phase_name = stripped[2..-1].strip
          current_section = phase_name
          markdown_lines << "## #{phase_name}"
          markdown_lines << ""
          markdown_lines << "*#{humanize_phase_name(phase_name)}*"
          markdown_lines << ""
          
        elsif !stripped.empty? && !stripped.start_with?('#') && current_section
          # Add code to current block
          code_block << line.rstrip
          
        elsif stripped.empty? && code_block.any?
          # Empty line in code block
          code_block << ""
          
        elsif !stripped.start_with?('#~') && !stripped.start_with?('#') && !current_section && !stripped.empty?
          # Code before any phase markers
          if code_block.empty?
            markdown_lines << "## Template Overview"
            markdown_lines << ""
          end
          code_block << line.rstrip
        end
      end
      
      # Finish final code block
      if code_block.any?
        markdown_lines << "```ruby"
        markdown_lines.concat(code_block)
        markdown_lines << "```"
        markdown_lines << ""
      end
      
      # Add footer with phase explanation
      markdown_lines << "## Template Phase Structure"
      markdown_lines << ""
      markdown_lines << "This template follows the git-template specialized phase architecture:"
      markdown_lines << ""
      markdown_lines << "- **010_PHASE**: Ruby version and basic configuration"
      markdown_lines << "- **030_PHASE**: Gem dependencies and bundler setup"
      markdown_lines << "- **040_PHASE**: UI, views, and styling configuration"
      markdown_lines << "- **050_PHASE**: Testing framework setup"
      markdown_lines << "- **100_PHASE**: Application features and functionality"
      markdown_lines << "- **900_PHASE**: Completion messages and next steps"
      markdown_lines << ""
      markdown_lines << "Each phase has a specific responsibility, making the template organized, maintainable, and easy to iterate on during development."
      
      markdown_lines.join("\n")
    end
    
    def humanize_phase_name(phase_name)
      # Convert phase names to human-readable descriptions
      case phase_name
      when /010_PHASE/
        "Ruby version and basic configuration phase"
      when /030_PHASE.*GemBundle.*Development.*Test/
        "Development and test gem configuration"
      when /030_PHASE.*GemBundle.*Development/
        "Development-only gem configuration"
      when /030_PHASE.*GemBundle/
        "Gem bundle configuration"
      when /040_PHASE.*View.*Markup/
        "Application layout and markup improvements"
      when /040_PHASE.*View.*Styling/
        "Basic styling and CSS setup"
      when /040_PHASE.*View/
        "View and UI configuration"
      when /050_PHASE.*Test/
        "Testing framework setup"
      when /100_PHASE.*Feature.*Home.*Controller/
        "Home page controller generation"
      when /100_PHASE.*Feature.*Home.*Route/
        "Root route configuration"
      when /100_PHASE.*Feature.*Home.*View/
        "Welcome page view creation"
      when /100_PHASE.*Feature.*Post.*Model.*Migrate/
        "Database migration execution"
      when /100_PHASE.*Feature.*Post.*Model.*Seed/
        "Sample data seeding"
      when /100_PHASE.*Feature.*Post.*Model/
        "Post model generation"
      when /100_PHASE.*Feature/
        "Application feature implementation"
      when /900_PHASE.*Complete/
        "Template completion and next steps"
      else
        phase_name.gsub('_', ' ').downcase + " phase"
      end
    end
    
    def count_sections(markdown_content)
      markdown_content.scan(/^## /).length
    end

    private

    def execute_template_non_interactive(template_path, env_vars, log)
      require "open3"
      require "pty"
      require "yaml"
      
      # Load template-specific responses
      auto_responses = load_template_responses(template_path, log)
      
      command = "bin/rails app:template LOCATION=#{template_path}"
      
      begin
        # Use PTY to handle interactive prompts
        success = false
        PTY.spawn(env_vars, command) do |stdout, stdin, pid|
          output_buffer = ""
          
          loop do
            begin
              # Read available output
              ready = IO.select([stdout], nil, nil, 1)
              if ready
                partial_output = stdout.read_nonblock(1024)
                output_buffer += partial_output
                print partial_output  # Show output in real-time
                
                # Check for prompts and respond automatically
                auto_responses.each do |pattern, response|
                  if output_buffer.match(pattern)
                    puts "\n🤖 Auto-responding: #{response.strip}"
                    log.puts "🤖 Auto-responding to prompt: #{pattern.source} -> #{response.strip}"
                    stdin.write(response)
                    stdin.flush
                    output_buffer = ""  # Clear buffer after responding
                    break
                  end
                end
              end
            rescue EOFError
              break
            rescue IO::WaitReadable
              # Continue if no data available
            end
          end
          
          # Wait for process to complete
          Process.wait(pid)
          success = $?.success?
          puts "\n🎯 Template execution completed with status: #{success}"
          log.puts "🎯 Template execution completed with status: #{success}"
        end
        return success
      rescue PTY::ChildExited => e
        puts "Template process exited: #{e.status}"
        log.puts "Template process exited: #{e.status}"
        e.status.success?
      rescue => e
        puts "Error executing template: #{e.message}"
        log.puts "Error executing template: #{e.message}"
        false
      end
    end

    def load_template_responses(template_path, log)
      # Default responses for common prompts
      default_responses = {
        # File overwrite prompts
        /Overwrite.*\? \(enter "h" for help\) \[Ynaqdhm\]/ => "y\n",
        /conflict.*Overwrite.*\[Ynaqdhm\]/ => "y\n",
        
        # Generic yes/no prompts (default to no for safety)
        /\? \(y\/n\)/ => "n\n",
        /\? \(yes\/no\)/ => "no\n"
      }
      
      # Try to load template-specific responses
      template_dir = File.dirname(template_path)
      config_file = File.join(template_dir, "test_responses.yml")
      
      if File.exist?(config_file)
        begin
          config = YAML.load_file(config_file)
          puts "📋 Loading template responses from: #{config_file}"
          log.puts "📋 Loading template responses from: #{config_file}"
          
          # Convert string patterns to regex and merge with defaults
          template_responses = {}
          config.each do |pattern_str, response|
            begin
              # Convert string to regex, handling both simple strings and regex patterns
              regex = if pattern_str.start_with?('/') && pattern_str.end_with?('/')
                # Handle regex format: "/pattern/flags"
                pattern_content = pattern_str[1..-2]  # Remove leading and trailing /
                Regexp.new(pattern_content, Regexp::IGNORECASE)
              else
                # Handle simple string patterns
                Regexp.new(Regexp.escape(pattern_str), Regexp::IGNORECASE)
              end
              
              # Ensure response ends with newline
              response_with_newline = response.to_s.end_with?("\n") ? response.to_s : "#{response}\n"
              template_responses[regex] = response_with_newline
              
              puts "  • #{pattern_str} → #{response.inspect}"
              log.puts "  • #{pattern_str} → #{response.inspect}"
            rescue => e
              puts "⚠️  Warning: Invalid pattern '#{pattern_str}': #{e.message}"
              log.puts "⚠️  Warning: Invalid pattern '#{pattern_str}': #{e.message}"
            end
          end
          
          # Merge template responses with defaults (template responses take precedence)
          default_responses.merge(template_responses)
        rescue => e
          puts "⚠️  Warning: Could not load #{config_file}: #{e.message}"
          log.puts "⚠️  Warning: Could not load #{config_file}: #{e.message}"
          default_responses
        end
      else
        puts "📋 Using default responses (no test_responses.yml found)"
        log.puts "📋 Using default responses (no test_responses.yml found)"
        default_responses
      end
    end

    private

    def setup_environment(options)
      ENV['VERBOSE'] = '1' if options[:verbose]
      ENV['DEBUG'] = '1' if options[:debug]
    end

    def handle_command_error(command_name, result)
      puts "❌ #{command_name.capitalize} command failed:"
      puts "   #{result[:error]}"
      
      if result[:error_type] && ENV['DEBUG']
        puts "   Error type: #{result[:error_type]}"
      end
      
      exit 1
    end

    def handle_unexpected_command_error(command_name, error, options)
      puts "❌ Unexpected error in #{command_name} command:"
      puts "   #{error.message}"
      
      if options[:debug] || ENV['DEBUG']
        puts "\nBacktrace:"
        puts error.backtrace.join("\n")
      else
        puts "\nRun with --debug for more details"
      end
      
      exit 1
    end

    def validate_command_prerequisites
      # Check if git is available
      unless system('git --version > /dev/null 2>&1')
        puts "❌ Error: git is not installed or not available in PATH"
        puts "   Please install git to use git-template commands"
        exit 1
      end
    end

    # Default action when no command is specified
    def self.start(args)
      if args.empty?
        puts "git-template - Rails application template with lifecycle management"
        puts ""
        puts "Usage:"
        puts "  git-template apply [PATH]     # Apply template to existing Rails app"
        puts "  git-template status FOLDER    # Check template development status"
        puts "  git-template clone GIT_URL    # Clone repository for template development"
        puts "  git-template iterate FOLDER   # Iterate and refine templates"
        puts "  git-template update FOLDER    # Update template configuration"
        puts "  git-template push FOLDER      # Push to remote repository"
        puts "  git-template version          # Show version"
        puts "  git-template list             # List available templates"
        puts "  git-template path             # Show template path"
        puts "  git-template help [COMMAND]   # Show help"
        puts ""
        puts "For new Rails applications:"
        puts "  rails new myapp -m git-template"
        puts ""
        return
      end
      
      super(args)
    end
  end
end