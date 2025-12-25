require_relative "lib/git_template/version"

Gem::Specification.new do |spec|
  spec.name          = "git-template"
  spec.version       = GitTemplate::VERSION
  spec.authors       = ["Eric Laquer"]
  spec.email         = ["eric@example.com"]

  spec.summary       = "Rails application template with lifecycle management"
  spec.description   = "A Ruby gem for managing Rails application templates with structured phases, user configuration, and extensible module system. Includes Rails 8 + Juris.js template."
  spec.homepage      = "https://github.com/username/git-template"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 3.0.0"
  
  # Runtime dependencies
  spec.add_dependency "rails", ">= 7.0"
  spec.add_dependency "thor", "~> 1.0"
  
  # Development dependencies
  spec.add_development_dependency "rspec", "~> 3.12"

  # Specify which files should be added to the gem when it is released
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    # Include all files that should be in the gem
    files = []
    files += Dir["lib/**/*"].select { |f| File.file?(f) }
    files += Dir["bin/*"].select { |f| File.file?(f) }
    files += Dir["template/**/*"].select { |f| File.file?(f) }
    files += ["README.md", "CHANGELOG.md", "LICENSE", "template.rb"]
    files.select { |f| File.exist?(f) }
  end
  
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Metadata
  spec.metadata["source_code_uri"] = "https://github.com/username/git-template"
  spec.metadata["changelog_uri"] = "https://github.com/username/git-template/blob/main/CHANGELOG.md"
end