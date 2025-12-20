lib_path = File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'lib')
puts "Adding to load path: #{lib_path}"
puts "Resolved path: #{File.expand_path(lib_path)}"
$LOAD_PATH.unshift(lib_path)


class GemFileGenerator0001 < GitTemplate::Generators::Base
  include GitTemplate::Generators::Gemfile 
  
  
  repo_path 'Gemfile'
  
  source "https://rubygems.org"
  
  comment "Bundle edge Rails instead: gem \"rails\", github: \"rails/rails\", branch: \"main\""
  gem "rails", "~> 8.1.1"
  
  comment "The modern asset pipeline for Rails [https://github.com/rails/propshaft]"
  gem "propshaft"
  
  comment "Use sqlite3 as the database for Active Record"
  gem "sqlite3", ">= 2.1"
  
  comment "Use the Puma web server [https://github.com/puma/puma]"
  gem "puma", ">= 5.0"
  
  comment "Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]"
  gem "importmap-rails"
  
  comment "Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]"
  gem "turbo-rails"
  
  comment "Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]"
  gem "stimulus-rails"
  
  comment "Build JSON APIs with ease [https://github.com/rails/jbuilder]"
  gem "jbuilder"
  
  comment "Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]"
  comment "gem \"bcrypt\", \"~> 3.1.7\""
  
  comment "Windows does not include zoneinfo files, so bundle the tzinfo-data gem"
  gem "tzinfo-data", platforms: %i[ windows jruby ]
  
  comment "Use the database-backed adapters for Rails.cache, Active Job, and Action Cable"
  gem "solid_cache"
  gem "solid_queue"
  gem "solid_cable"
  
  comment "Reduces boot times through caching; required in config/boot.rb"
  gem "bootsnap", require: false
  
  comment "Deploy this application anywhere as a Docker container [https://kamal-deploy.org]"
  gem "kamal", require: false
  
  comment "Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]"
  gem "thruster", require: false
  
  comment "Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]"
  gem "image_processing", "~> 1.2"
  
  group :development, :test do
    comment "See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem"
    gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
    
    comment "Audits gems for known security defects (use config/bundler-audit.yml to ignore issues)"
    gem "bundler-audit", require: false
    
    comment "Static analysis for security vulnerabilities [https://brakemanscanner.org/]"
    gem "brakeman", require: false
    
    comment "Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]"
    gem "rubocop-rails-omakase", require: false
  end
  
  group :development do
    comment "Use console on exceptions pages [https://github.com/rails/web-console]"
    gem "web-console"
  end
  
  group :test do
    comment "Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]"
    gem "capybara"
    gem "selenium-webdriver"
  end
end
