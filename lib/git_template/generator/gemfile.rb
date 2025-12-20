module GitTemplate
  module Generators
    module Gemfile
      def self.included(base)
        base.class_eval do
          @gems = []
          @sources = []
          @groups = {}
          @comments = []
        end
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        attr_reader :gems, :sources, :groups, :comments
        
        def source(url)
          @sources ||= []
          @sources << url
        end
        
        def gem(name, *args)
          @gems ||= []
          options = args.last.is_a?(Hash) ? args.pop : {}
          version = args.first
          
          # Capture any comment from the previous line
          comment = @pending_comment
          @pending_comment = nil
          
          @gems << { name: name, version: version, options: options, comment: comment }
        end
        
        def comment(text)
          @pending_comment = text
        end
        
        def group(*names, &block)
          @groups ||= {}
          # Use the array of names as the key
          @groups[names] ||= []
          # Capture gems defined in block
          GroupContext.new(self, names).instance_eval(&block)
        end
        
        def golden_text
          build_gemfile_content
        end
        
        private
        
        def build_gemfile_content
          lines = []
          
          # Add sources
          @sources&.each { |s| lines << "source \"#{s}\"" }
          lines << "" if @sources&.any?
          
          # Add top-level gems
          @gems&.each do |g|
            lines << "# #{g[:comment]}" if g[:comment]
            lines << format_gem_line(g)
          end
          
          # Add grouped gems
          @groups&.each do |group_names, gems|
            lines << ""
            lines << "group #{group_names.map { |n| ":#{n}" }.join(', ')} do"
            gems.each do |g|
              lines << "  # #{g[:comment]}" if g[:comment]
              lines << "  #{format_gem_line(g)}"
            end
            lines << "end"
          end
          
          lines.join("\n")
        end
        
        def format_gem_line(gem_hash)
          parts = ["gem \"#{gem_hash[:name]}\""]
          parts << "\"#{gem_hash[:version]}\"" if gem_hash[:version]
          gem_hash[:options].each do |k, v|
            if v.is_a?(Array)
              parts << "#{k}: %i[ #{v.join(' ')} ]"
            else
              parts << "#{k}: #{v.inspect}"
            end
          end
          parts.join(", ")
        end
      end
      
      class GroupContext
        def initialize(klass, group_names)
          @klass = klass
          @group_names = group_names
        end
        
        def comment(text)
          @pending_comment = text
        end
        
        def gem(name, *args)
          options = args.last.is_a?(Hash) ? args.pop : {}
          version = args.first
          
          comment = @pending_comment
          @pending_comment = nil
          
          gem_hash = { name: name, version: version, options: options, comment: comment }
          # Add to the group using the array of names as the key
          @klass.groups[@group_names] << gem_hash
        end
      end
    end
  end
end
