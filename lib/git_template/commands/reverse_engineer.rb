require_relative '../services/rails_file_type_mapper'

module GitTemplate
  module Command
    module ReverseEngineer
      def self.included(base)
        base.class_eval do
          desc "reverse_engineer", "Analyze Rails repository and map files to generators"
          option :path, type: :string, required: true, desc: "Path to Rails repository"
          option :list, type: :boolean, default: false, desc: "Display tree with generator mappings"
          
          def reverse_engineer
            repo_path = options[:path]
            
            unless File.directory?(repo_path)
              @logger.error "Path does not exist: #{repo_path}"
              return
            end
            
            @logger.info "Analyzing Rails repository at: #{repo_path}"
            
            if options[:list]
              display_tree(repo_path)
            else
              analyze_repository(repo_path)
            end
          end
          
          private
          
          def display_tree(repo_path)
            tree = GitTemplate::Services::RailsFileTypeMapper.build_tree(repo_path)
            formatted = GitTemplate::Services::RailsFileTypeMapper.format_tree(tree)
            
            puts "\n" + "=" * 80
            puts "Repository File Tree with Generator Mappings"
            puts "=" * 80
            puts formatted
            puts "=" * 80 + "\n"
          end
          
          def analyze_repository(repo_path)
            files = GitTemplate::Services::RailsFileTypeMapper.scan_repository(repo_path)
            
            # Group by generator type
            by_generator = files.group_by { |f| f[:generator] || 'Unmapped' }
            
            puts "\n" + "=" * 80
            puts "Repository Analysis"
            puts "=" * 80
            puts "Total files: #{files.count}"
            puts "\nFiles by generator type:"
            
            by_generator.sort_by { |gen, _| gen }.each do |generator, file_list|
              generator_name = generator.split('::').last rescue generator
              puts "\n#{generator_name} (#{file_list.count} files):"
              file_list.first(5).each do |file|
                puts "  - #{file[:path]}"
              end
              puts "  ... and #{file_list.count - 5} more" if file_list.count > 5
            end
            
            puts "=" * 80 + "\n"
          end
        end
      end
    end
  end
end
