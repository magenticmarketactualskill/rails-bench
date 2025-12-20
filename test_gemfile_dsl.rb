#!/usr/bin/env ruby

# Test script to verify Gemfile DSL functionality
lib_path = File.join(File.dirname(__FILE__), 'lib')
$LOAD_PATH.unshift(lib_path)

require 'git_template/generator/base'
require 'git_template/generator/gemfile'

# Load the refactored generator
load 'templated/examples/rails8-simple/.git_template/template_part/gem_file_generator_0001.rb'

# Test config
class TestConfig
  attr_reader :id
  def initialize(id = 'rails8-simple-dsl-test')
    @id = id
  end
end

puts "=== Gemfile DSL Test ==="
puts

config = TestConfig.new
generator = GemFileGenerator0001.new(config)

# Check that golden_text is built from DSL
golden_text = generator.golden_text

puts "Golden text generated from DSL:"
puts "-" * 60
puts golden_text.lines.first(20).join
puts "..."
puts "-" * 60
puts

# Generate the actual file
base_path = File.join(Dir.pwd, 'templated/examples/rails8-simple')
result = generator.write_to_repo(base_path: base_path)

puts "✓ Generated: #{result}"
puts
puts "First 15 lines of generated file:"
puts "-" * 60
content = File.read(result)
puts content.lines.first(15).join
puts "-" * 60
