# Rails 8 Simple Template
# This template uses template parts to generate a Rails 8 application

say "🚀 Starting Rails 8 Simple Template"

# Generate Gemfile using content from template part
say "📦 Generating Gemfile..."

# Read the golden text from the template part
template_part_path = File.join(__dir__, 'template_part', 'template_for_Gemfile')

if File.exist?(template_part_path)
  # Extract the golden text content from the template part
  template_part_content = File.read(template_part_path)
  
  # Extract the content between golden_text <<-TEXT and TEXT
  if match = template_part_content.match(/golden_text\s+<<-TEXT\n(.*?)\n\s*TEXT/m)
    gemfile_content = match[1]
    
    # Write the Gemfile
    create_file 'Gemfile', gemfile_content
    say "✅ Gemfile generated successfully"
  else
    say "❌ Could not extract Gemfile content from template part", :red
  end
else
  say "❌ Template part not found: #{template_part_path}", :red
end

say "🎉 Rails 8 Simple Template completed!"