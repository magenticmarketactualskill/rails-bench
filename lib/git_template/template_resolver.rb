module GitTemplate
  class TemplateResolver
    class << self
      # Resolve template path within gem or external location
      def resolve_template_path(template_name = nil)
        if template_name.nil?
          gem_template_path
        elsif File.exist?(template_name)
          File.expand_path(template_name)
        else
          # Try to find template in gem
          gem_template_path
        end
      end

      # Return path to bundled template.rb within the gem
      def gem_template_path
        File.expand_path("../../template.rb", __dir__)
      end

      # Return path to template directory within the gem
      def gem_template_directory
        File.expand_path("../../template", __dir__)
      end

      # Check if template exists
      def template_exists?(path = nil)
        if path.nil?
          File.exist?(gem_template_path)
        else
          File.exist?(path)
        end
      end

      # Get all available template modules
      def available_modules
        template_dir = gem_template_directory
        return [] unless Dir.exist?(template_dir)
        
        Dir.glob("#{template_dir}/**/*.rb").map do |file|
          relative_path = file.sub("#{template_dir}/", "")
          {
            path: relative_path,
            full_path: file,
            phase: File.dirname(relative_path),
            name: File.basename(relative_path, ".rb")
          }
        end
      end
    end
  end
end