#!/usr/bin/env ruby

# Test script to generate the actual Gemfile in the templated example
lib_path = File.join(File.dirname(__FILE__), 'lib')
$LOAD_PATH.unshift(lib_path)

require 'git_template/generator/base'

# Load the example generator
load 'templated/examples/rails8-simple/.git_template/template_part/gem_file_generator_0001.rb'

# Test config
class TestConfig
  attr_reader :id
  def initialize(id = 'rails8-simple-config')
    @id = id
  end
end

puts "=== Generating Gemfile for rails8-simple ==="
puts

config = TestConfig.new
generator = GemFileGenerator0001.new(config)

# Write to the templated directory
base_path = File.join(Dir.pwd, 'templated/examples/rails8-simple')
result = generator.write_to_repo(base_path: base_path)

puts "✓ Generated: #{result}"
puts
puts "First 15 lines:"
puts "-" * 60
content = File.read(result)
puts content.lines.first(15).join
puts "-" * 60
