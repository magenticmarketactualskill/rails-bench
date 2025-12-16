# Rails Version Management
# This module ensures the correct Rails version is installed and available
say "Setting up Rails version...", :green

# Define the target Rails version
RAILS_VERSION = "8.1.1"

# Check current Rails version
current_rails_version = nil
begin
  current_rails_version = `rails --version 2>/dev/null`.strip.match(/Rails (\d+\.\d+\.\d+)/)[1] rescue nil
rescue
  current_rails_version = nil
end

say "Current Rails version: #{current_rails_version || 'Not installed'}", :yellow
say "Target Rails version: #{RAILS_VERSION}", :yellow

# Install or update Rails if needed
if current_rails_version != RAILS_VERSION
  say "Installing Rails #{RAILS_VERSION}...", :green
  
  # Add Rails gem to Gemfile with specific version
  gem "rails", "~> #{RAILS_VERSION}"
  
  # Run bundle install to ensure Rails is available
  run "bundle install"
  
  # Verify installation
  new_rails_version = `bundle exec rails --version 2>/dev/null`.strip.match(/Rails (\d+\.\d+\.\d+)/)[1] rescue nil
  
  if new_rails_version == RAILS_VERSION
    say "✓ Rails #{RAILS_VERSION} installed successfully", :green
  else
    say "⚠️  Warning: Rails version mismatch. Expected #{RAILS_VERSION}, got #{new_rails_version}", :yellow
  end
else
  say "✓ Rails #{RAILS_VERSION} already available", :green
end

# Ensure we're using the correct Rails version for subsequent commands
ENV['BUNDLE_GEMFILE'] = File.expand_path('Gemfile')

say "✓ Rails version setup complete", :green