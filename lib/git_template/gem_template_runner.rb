module GitTemplate
  class GemTemplateRunner
    attr_reader :rails_app_generator

    def initialize(rails_app_generator)
      @rails_app_generator = rails_app_generator
    end

    # Execute template with proper gem context
    def run_template(template_path = nil)
      resolved_path = TemplateResolver.resolve_template_path(template_path)
      
      unless TemplateResolver.template_exists?(resolved_path)
        raise Error, "Template not found: #{resolved_path}"
      end

      # Set up gem context for template execution
      setup_gem_context
      
      # Execute the template
      if rails_app_generator
        # Running within Rails template context
        rails_app_generator.apply(resolved_path)
      else
        # Running standalone - load and execute template
        load_and_execute_template(resolved_path)
      end
    end

    private

    def setup_gem_context
      # Ensure gem paths are available to template
      $LOAD_PATH.unshift(File.expand_path("../../lib", __dir__)) unless $LOAD_PATH.include?(File.expand_path("../../lib", __dir__))
      
      # Make template directory available
      template_dir = TemplateResolver.gem_template_directory
      if defined?(Rails) && Rails.respond_to?(:application)
        # Add template directory to Rails load paths if in Rails context
        Rails.application.config.eager_load_paths << template_dir if Dir.exist?(template_dir)
      end
    end

    def load_and_execute_template(template_path)
      # For standalone execution (not within Rails template context)
      # This would be used when applying to existing Rails apps
      
      # Create a minimal context for template execution
      template_context = Object.new
      
      # Define basic template methods
      template_context.define_singleton_method(:source_paths) do
        [File.dirname(template_path)]
      end
      
      # Load and execute the template in the context
      template_context.instance_eval(File.read(template_path), template_path)
    end
  end
end