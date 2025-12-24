require_relative '../../class_content_builder'

module GitTemplate
  module Generators
    module Gemfile
      include ClassContentBuilder::Generator

      attribute :gems, default: []
      attribute :sources, default: []
      attribute :groups, default: {}
      attribute :comments, default: []

      def self.source(url)
        @_attributes[:sources] ||= []
        @_attributes[:sources] << url
      end

      def self.gem(name, *args)
        @_attributes[:gems] ||= []
        options = args.last.is_a?(Hash) ? args.pop : {}
        version = args.first

        comment = @pending_comment
        @pending_comment = nil

        @_attributes[:gems] << { name: name, version: version, options: options, comment: comment }
      end

      def self.comment(text)
        @pending_comment = text
      end

      def self.group(*names, &block)
        @_attributes[:groups] ||= {}
        @_attributes[:groups][names] ||= []
        GroupContext.new(self, names).instance_eval(&block)
      end

      def self.golden_text
        build_gemfile_content
      end

      def self.build_gemfile_content
        lines = []

        @_attributes[:sources]&.each { |s| lines << "source \"#{s}\"" }
        lines << "" if @_attributes[:sources]&.any?

        @_attributes[:gems]&.each do |g|
          lines << "# #{g[:comment]}" if g[:comment]
          lines << format_gem_line(g)
        end

        @_attributes[:groups]&.each do |group_names, gems|
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

      def self.format_gem_line(gem_hash)
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
          @klass.instance_variable_get(:@_attributes)[:groups][@group_names] << gem_hash
        end
      end
    end
  end
end
