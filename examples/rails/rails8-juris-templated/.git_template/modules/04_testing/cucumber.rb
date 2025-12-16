# Setup Cucumber for BDD testing
say "Setting up Cucumber...", :green

# Add Cucumber gems - only if not already present
gem "cucumber-rails", require: false, group: :test, comment: "Cucumber for Rails" unless gem_exists?("cucumber-rails")
gem "capybara", group: :test, comment: "Integration testing tool" unless gem_exists?("capybara")
gem "selenium-webdriver", group: :test, comment: "WebDriver for browser automation" unless gem_exists?("selenium-webdriver")

# Cucumber will be installed via rails generate cucumber:install in after_bundle
after_bundle do
  # Generate Cucumber configuration
  generate "cucumber:install"
  
  say "✓ Cucumber configured", :green
end

say "✓ Cucumber gems added (will be configured after bundle)", :green
