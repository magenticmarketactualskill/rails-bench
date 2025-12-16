# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2024-12-16

### Added
- **Template Implementation Lifecycle System** - Complete workflow for template development and refinement
- **Status Command** (`git-template status`) - Analyze template development status and folder structure
- **Clone Command** (`git-template clone`) - Clone repositories for template development with optional template configuration setup
- **Iterate Command** (`git-template iterate`) - Iterative template refinement through comparison and cleanup phase updates
- **Update Command** (`git-template update`) - Template configuration updates, validation, and issue fixing
- **Push Command** (`git-template push`) - Git repository management with automatic initialization and commit handling
- **Dual Lifecycle Architecture** - Separate Template Implementation and Template Execution lifecycles
- **Comprehensive Service Layer**:
  - `FolderAnalyzer` - Template development status analysis
  - `GitOperations` - Git repository operations with error handling
  - `TemplateProcessor` - Template application and comparison logic
  - `StatusReporter` - Structured status reporting with multiple output formats
- **Data Models**:
  - `FolderAnalysis` - Folder structure and template configuration analysis
  - `TemplateConfiguration` - Template validation and management
  - `ComparisonResult` - Folder comparison and difference detection
- **Enhanced Error Handling** - Comprehensive error handling with debug support
- **Integration Testing** - Basic integration test suite for new functionality
- **Programmatic API** - Full programmatic access to all new commands and services

### Changed
- **Architecture Evolution** - Moved from cleanup-phase approach to specialized phases for better organization
- **CLI Interface** - Enhanced with new commands and consistent error handling
- **Documentation** - Updated README with dual lifecycle documentation and comprehensive usage examples

### Features
- Multiple output formats (detailed, summary, JSON) for status reporting
- Automatic templated folder creation and management
- Template completeness validation and round-trip testing
- Git repository initialization and remote management
- Detailed comparison reporting with diff generation
- Template structure optimization and issue detection
- Debug and verbose output modes for troubleshooting
- Consistent command-line interface with Thor integration

## [0.0.1] - 2024-12-15

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

[0.1.0]: https://github.com/username/git-template/releases/tag/v0.1.0
[0.0.1]: https://github.com/username/git-template/releases/tag/v0.0.1