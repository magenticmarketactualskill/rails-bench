# Add core gems and dependencies
say "Adding core gems...", :green

# Ensure Rails 8.1+ is specified (only if not already present)
gem "rails", "~> 8.1.1" unless gem_exists?("rails")

# Asset pipeline
gem "propshaft", comment: "The modern asset pipeline for Rails" unless gem_exists?("propshaft")

# Web server
gem "puma", "~> 5.0", comment: "Use the Puma web server" unless gem_exists?("puma")

# Database
gem "sqlite3", "~> 2.1", comment: "Use sqlite3 as the database for Active Record" unless gem_exists?("sqlite3")

# Frontend
gem "importmap-rails", comment: "Use JavaScript with ESM import maps" unless gem_exists?("importmap-rails")
gem "turbo-rails", comment: "Hotwire's SPA-like page accelerator" unless gem_exists?("turbo-rails")
gem "stimulus-rails", comment: "Hotwire's modest JavaScript framework" unless gem_exists?("stimulus-rails")
gem "tailwindcss-rails", comment: "Use Tailwind CSS" unless gem_exists?("tailwindcss-rails")

# Inertia.js
gem "inertia_rails", "~> 3.0", comment: "Inertia.js adapter for Rails" unless gem_exists?("inertia_rails")

# Active Storage
gem "image_processing", "~> 1.2", comment: "Use Active Storage variants" unless gem_exists?("image_processing")

# HTTP asset caching/compression
gem "thruster", require: false, comment: "Add HTTP asset caching/compression and X-Sendfile acceleration to Puma" unless gem_exists?("thruster")

# Development and test gems - only if not already present
gem "debug", platforms: %i[ mri windows ], group: [:development, :test], comment: "See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem" unless gem_exists?("debug")
gem "bundler-audit", require: false, group: [:development, :test], comment: "Audits gems for known security defects" unless gem_exists?("bundler-audit")
gem "brakeman", require: false, group: [:development, :test], comment: "Static analysis for security vulnerabilities" unless gem_exists?("brakeman")

# Development gems - only if not already present
gem "web-console", group: :development, comment: "Use console on exceptions pages" unless gem_exists?("web-console")

# Code quality
gem "rubocop-rails-omakase", require: false, group: :development, comment: "Omakase Ruby styling" unless gem_exists?("rubocop-rails-omakase")

say "✓ Core gems added", :green
