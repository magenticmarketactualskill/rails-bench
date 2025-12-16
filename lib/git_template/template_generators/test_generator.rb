require_relative 'base_generator'

module GitTemplate
  module TemplateGenerators
    class TestGenerator < BaseGenerator
      def self.execute
        execute_with_messages do |data, messages|
          say_next_message(messages, "Setting up testing framework...")
          say_next_message(messages)
          
          if data.respond_to?(:generators)
            run_generators(data.generators.to_a)
          end
        end
      end
    end
  end
end