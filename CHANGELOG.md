# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-12-15

### Added
- Initial release of git-template gem
- Structured TemplateLifecycle system for Rails application templates
- Command-line interface for applying templates
- Rails 8 + Juris.js application template with organized phases:
  - Platform Setup (Ruby, Rails, database configuration)
  - Infrastructure Setup (gems, Redis, Solid Stack, deployment)
  - Frontend Setup (Vite, Tailwind CSS, Inertia.js, Juris.js)
  - Testing Setup (RSpec, Cucumber)
  - Security Setup (authorization, security gems)
  - Data Flow Setup (ActiveDataFlow integration)
  - Application Features (models, controllers, views, routes, admin)
- User configuration management with interactive prompts
- Extensible module system for adding new template components
- Comprehensive documentation and usage examples
- Semantic versioning validation
- Error handling and graceful degradation

### Features
- `git-template apply` - Apply template to existing Rails applications
- `git-template version` - Show gem version
- `git-template list` - List available templates
- `git-template path` - Show path to bundled template
- `rails new myapp -m git-template` - Create new Rails app with template
- Programmatic API for template application
- Template module discovery and phase organization
- Dependency management and conditional execution
- Progress feedback and execution summaries

[1.0.0]: https://github.com/username/git-template/releases/tag/v1.0.0