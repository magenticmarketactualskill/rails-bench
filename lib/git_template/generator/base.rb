require_relative '../metadata/base'
require 'fileutils'

module GitTemplate
  module Generators
    class Base
      include Metadata
      
      # explicitly set
      attr_reader :golden_text
      
      #inferred from context
      attr_reader :repo, :repo_path, :metadata
      
      def self.golden_text(text = nil)
        if text
          @golden_text = text
        else
          @golden_text
        end
      end
      
      def self.repo_path(path = nil)
        if path
          @repo_path = path
        else
          @repo_path
        end
      end
      
      def self.generate(config)
        new(config).generate
      end
      
      def initialize(config)
        @config = config
        @golden_text = self.class.golden_text
        @repo_path = self.class.repo_path
        @metadata = build_metadata
      end
      
      def generate
        write_to_repo
      end
      
      def write_to_repo(include_metadata: true, base_path: Dir.pwd)
        raise "No repo_path specified" unless @repo_path
        raise "No golden_text specified" unless @golden_text
        
        full_path = File.join(base_path, @repo_path)
        dir = File.dirname(full_path)
        FileUtils.mkdir_p(dir) unless Dir.exist?(dir)
        
        content = if include_metadata
          "#{metadata_comment}\n\n#{@golden_text}"
        else
          @golden_text
        end
        
        File.write(full_path, content)
        full_path
      end
    end
  end
end