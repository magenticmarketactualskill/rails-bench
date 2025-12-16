# Set Ruby version to 3.3.6
say "Setting Ruby version to 3.3.6...", :green

create_file ".ruby-version", "3.3.6\n", force: ENV["RAILS_TEMPLATE_NON_INTERACTIVE"] == "true"

say "✓ Ruby version set to 3.3.6", :green
