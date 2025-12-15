require "thor"

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

    def self.exit_on_failure?
      true
    end

    # Default action when no command is specified
    def self.start(args)
      if args.empty?
        puts "git-template - Rails application template with lifecycle management"
        puts ""
        puts "Usage:"
        puts "  git-template apply [PATH]     # Apply template to existing Rails app"
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