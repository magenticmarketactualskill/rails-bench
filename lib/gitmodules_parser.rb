# frozen_string_literal: true

# GitmodulesParser - Parses .gitmodules files and provides lookup methods
#
# This gem provides a DRY interface for working with .gitmodules files,
# extracting common parsing logic used across multiple commands.

module GitmodulesParser
  class Parser
    attr_reader :entries

    Entry = Struct.new(:name, :path, :url, :branch, keyword_init: true)

    def initialize(gitmodules_path = '.gitmodules')
      @gitmodules_path = gitmodules_path
      @entries = parse
    end

    def exists?
      File.exist?(@gitmodules_path)
    end

    def find_by_url(url)
      @entries.find { |entry| entry.url == url }
    end

    def find_by_path(path)
      @entries.find { |entry| entry.path == path }
    end

    def find_by_name(name)
      @entries.find { |entry| entry.name == name }
    end

    def path_for_url(url)
      entry = find_by_url(url)
      entry&.path
    end

    def url_for_path(path)
      entry = find_by_path(path)
      entry&.url
    end

    def url_exists?(url)
      @entries.any? { |entry| entry.url == url }
    end

    def path_exists?(path)
      @entries.any? { |entry| entry.path == path }
    end

    def all_paths
      @entries.map(&:path)
    end

    def all_urls
      @entries.map(&:url)
    end

    private

    def parse
      return [] unless exists?

      content = File.read(@gitmodules_path)
      entries = []
      current_entry = {}

      content.lines.each do |line|
        line = line.strip

        if (match = line.match(/^\[submodule "(.+)"\]$/))
          # Save previous entry if complete
          entries << build_entry(current_entry) if current_entry[:name]
          current_entry = { name: match[1] }
        elsif (match = line.match(/^\s*path\s*=\s*(.+)$/))
          current_entry[:path] = match[1].strip
        elsif (match = line.match(/^\s*url\s*=\s*(.+)$/))
          current_entry[:url] = match[1].strip
        elsif (match = line.match(/^\s*branch\s*=\s*(.+)$/))
          current_entry[:branch] = match[1].strip
        end
      end

      # Don't forget the last entry
      entries << build_entry(current_entry) if current_entry[:name]

      entries
    end

    def build_entry(hash)
      Entry.new(**hash)
    end
  end
end
