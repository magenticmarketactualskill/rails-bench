# frozen_string_literal: true

# ClassContentBuilder - DSL for building Ruby class/module content
#
# This gem provides a DRY pattern for generating Ruby class and module
# content, extracting common logic from generator modules.

module ClassContentBuilder
  # Mixin that provides the standard generator pattern
  module Generator
    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        class << self
          attr_accessor :_name, :_parent_class, :_type, :_attributes
        end
        @_attributes = {}
      end
    end

    module ClassMethods
      def generator_type(type)
        @_type = type
      end

      def default_parent(parent_class)
        @_parent_class = parent_class
      end

      def attribute(name, default: nil)
        @_attributes ||= {}
        @_attributes[name] = default

        define_singleton_method(name) { @_attributes[name] }
        define_singleton_method("#{name}=") { |val| @_attributes[name] = val }
      end

      def golden_text
        builder = ContentBuilder.new(
          name: @_name,
          parent_class: @_parent_class,
          type: @_type
        )
        build_content(builder)
        builder.to_s
      end

      # Override in subclass to customize content building
      def build_content(builder)
        # Default implementation - subclasses override this
      end
    end
  end

  # Builder class for constructing class/module content
  class ContentBuilder
    def initialize(name:, parent_class: nil, type: :class)
      @name = name
      @parent_class = parent_class
      @type = type
      @lines = []
      @indent = 0
    end

    def open_definition
      case @type
      when :class
        if @parent_class
          line "class #{@name} < #{@parent_class}"
        else
          line "class #{@name}"
        end
      when :module
        line "module #{@name}"
      end
      @indent += 1
    end

    def close_definition
      @indent -= 1
      line "end"
    end

    def line(text = "")
      @lines << ("  " * @indent + text).rstrip
    end

    def blank_line
      @lines << ""
    end

    def association(assoc)
      line assoc
    end

    def validation(valid)
      line valid
    end

    def callback(callback)
      line callback
    end

    def before_action(action)
      line action
    end

    def method_def(name, body: nil, args: nil)
      args_str = args ? "(#{args})" : ""
      line "def #{name}#{args_str}"
      @indent += 1
      if body
        body.each_line { |l| line l.chomp }
      else
        line "# TODO: implement"
      end
      @indent -= 1
      line "end"
    end

    def queue_as(queue_name)
      line "queue_as :#{queue_name}"
    end

    def to_s
      @lines.join("\n")
    end
  end
end
