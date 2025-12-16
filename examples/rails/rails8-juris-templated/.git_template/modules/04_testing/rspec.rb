# Setup RSpec for testing
say "Setting up RSpec...", :green

# Add RSpec gems - only if not already present
gem "rspec-rails", "~> 6.0", group: [:development, :test], comment: "RSpec testing framework for Rails" unless gem_exists?("rspec-rails")
gem "factory_bot_rails", group: [:development, :test], comment: "Fixtures replacement with a straightforward definition syntax" unless gem_exists?("factory_bot_rails")
gem "faker", group: [:development, :test], comment: "Generate fake data for testing" unless gem_exists?("faker")

gem "shoulda-matchers", group: :test, comment: "Simple one-liner tests for common Rails functionality" unless gem_exists?("shoulda-matchers")
gem "database_cleaner-active_record", group: :test, comment: "Strategies for cleaning databases in tests" unless gem_exists?("database_cleaner-active_record")
gem "webmock", group: :test, comment: "Library for stubbing HTTP requests" unless gem_exists?("webmock")
gem "vcr", group: :test, comment: "Record HTTP interactions for testing" unless gem_exists?("vcr")

# RSpec will be installed via rails generate rspec:install in after_bundle
after_bundle do
  # Generate RSpec configuration
  generate "rspec:install"
  
  # Configure RSpec
  gsub_file "spec/rails_helper.rb", "# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }", 
            "Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }"
  
  # Create spec/support directory
  run "mkdir -p spec/support"
  
  # Create FactoryBot configuration
  file "spec/support/factory_bot.rb", <<~RUBY
    # FactoryBot configuration
    RSpec.configure do |config|
      config.include FactoryBot::Syntax::Methods
    end
  RUBY
  
  # Create DatabaseCleaner configuration
  file "spec/support/database_cleaner.rb", <<~RUBY
    # DatabaseCleaner configuration
    RSpec.configure do |config|
      config.before(:suite) do
        DatabaseCleaner.strategy = :transaction
        DatabaseCleaner.clean_with(:truncation)
      end

      config.around(:each) do |example|
        DatabaseCleaner.cleaning do
          example.run
        end
      end
    end
  RUBY
  
  # Create Shoulda Matchers configuration
  file "spec/support/shoulda_matchers.rb", <<~RUBY
    # Shoulda Matchers configuration
    Shoulda::Matchers.configure do |config|
      config.integrate do |with|
        with.test_framework :rspec
        with.library :rails
      end
    end
  RUBY
  
  say "✓ RSpec configured", :green
end

say "✓ RSpec gems added (will be configured after bundle)", :green
