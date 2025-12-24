# git-template

A Ruby gem for managing Rails application templates with structured phases, template development workflows, and bidirectional engineering (reverse and forward).

## Version

0.1.1

## Features

- **Template Development Lifecycle**: Clone, analyze, iterate, and push template development work
- **Bidirectional Engineering**: Reverse engineer Rails apps into templates, forward engineer templates into apps
- **File Comparison**: Detailed diff between source and templated folders
- **Submodule Management**: Safe handling of git submodules with protection against accidental modifications
- **Configuration Management**: Global config via `~/.git-template`

## Installation

Add to your application's Gemfile:

```ruby
gem 'git-template'
```

Then execute:

```bash
bundle install
```

Or install directly:

```bash
gem install git-template
```

## Dependencies

### Runtime Dependencies (gemspec)

- `rails` (~> 7.0)
- `thor` (~> 1.0)

### Additional Gems (Gemfile)

This project uses the following helper gems:

```ruby
gem "tree-meta", git: "https://github.com/magenticmarketactualskill/tree-meta.git"
gem "file-set", git: "https://github.com/magenticmarketactualskill/file-set.git"
gem "thor-concerns", git: "https://github.com/magenticmarketactualskill/thor-concerns.git"
```

### Development Dependencies

- `rspec` (~> 3.12)

## CLI Commands

### status

Check template development status for application folders.

```bash
git-template status --path .
git-template status --path /path/to/app --format json
git-template status --format summary --verbose
```

**Options:**
- `--path` - Path to analyze (defaults to current directory)
- `--format` - Output format: detailed, summary, or json
- `--verbose` - Show detailed output
- `--debug` - Show debug information

### clone

Clone a git repository for template development.

```bash
git-template clone --url https://github.com/user/repo.git
git-template clone --url https://github.com/user/repo.git --target my-app
git-template clone --url git@github.com:user/repo.git --branch main --depth 1
```

**Options:**
- `--url` - Git repository URL to clone (required)
- `--target` - Target folder for clone (defaults to repository name)
- `--branch` - Clone specific branch
- `--depth` - Create a shallow clone with specified depth
- `--quiet` - Suppress output during clone
- `--allow_existing` - Allow cloning into existing directory
- `--create_template_config` - Create basic template configuration
- `--create_readme` - Create template development README

### iterate

Handle template iteration with configuration preservation.

```bash
git-template iterate --path .
git-template iterate --path /path/to/app --detailed_comparison
git-template iterate --force
```

**Options:**
- `--path` - Folder path to iterate (defaults to current directory)
- `--detailed_comparison` - Generate detailed comparison report (default: true)
- `--force` - Force iteration even if checks fail

### compare

Generate detailed file-by-file diff between source and templated folders.

```bash
git-template compare --path .
git-template compare --source_folder /path/to/source --templated_folder /path/to/templated
git-template compare --path . --output_file diff_results.txt
```

**Options:**
- `--path` - Base folder path (defaults to current directory)
- `--source_folder` - Explicit source folder path
- `--templated_folder` - Explicit templated folder path
- `--output_file` - Custom output file path for diff results
- `--format` - Output format: detailed, summary, or json

### push

Push git repository with initialization and verification.

```bash
git-template push --path .
git-template push --path . --commit_changes --commit_message "Template updates"
git-template push --initialize_if_needed --set_upstream
```

**Options:**
- `--path` - Repository path (defaults to current directory)
- `--initialize_if_needed` - Initialize repository if not already a git repo
- `--commit_changes` - Commit changes before pushing
- `--commit_message` - Custom commit message
- `--remote_name` - Remote name (default: origin)
- `--branch` - Branch to push
- `--set_upstream` - Set upstream tracking

### config

Manage the `~/.git-template` configuration file.

```bash
git-template config
git-template config --create
```

**Options:**
- `--create` - Create default config file if it doesn't exist

### create-templated-folder

Create templated folder structure with template configuration.

```bash
git-template create-templated-folder --path .
git-template create-templated-folder --path /path/to/source --template_content "custom content"
```

**Options:**
- `--path` - Source folder path (defaults to current directory)
- `--template_content` - Custom template content

### remove-repo

Remove submodule and templated folder by path or URL.

```bash
git-template remove-repo --path examples/my-app
git-template remove-repo --url https://github.com/user/repo.git
git-template remove-repo --path examples/my-app --force
```

**Options:**
- `--path` - Submodule path to remove
- `--url` - Repository URL to find and remove
- `--force` - Force removal even if there are unpushed changes

### reverse_engineer

Analyze Rails repository and map files to generators.

```bash
git-template reverse_engineer --path /path/to/rails/app
git-template reverse_engineer --path . --list
git-template reverse_engineer --path . --generator model
git-template reverse_engineer --path . --execute
git-template reverse_engineer --path . --execute --output /custom/output
```

**Options:**
- `--path` - Path to Rails repository (required)
- `--list` - Display tree with generator mappings
- `--generator` - Filter by specific generator type (e.g., model, controller, migration)
- `--execute` - Generate and execute template to recreate files
- `--output` - Output directory for templated files (defaults to templated/<repo_name>)

### forward-engineer

Run template processing (full template or specific part).

```bash
git-template forward-engineer --template_part /path/to/template_part.rb
git-template forward-engineer --full --target_dir /path/to/app
git-template forward-engineer --template_part /path/to/part.rb --target_dir /path/to/app
```

**Options:**
- `--template_part` - Path to specific template part file to execute
- `--full` - Run full template processing (rerun entire template)
- `--target_dir` - Target directory (defaults to current directory)
- `--update_content` - Update template content based on current state (for full mode)

## Global Options

All commands support these common options:

- `--debug` - Show debug information and stack traces
- `--verbose` - Show detailed output during execution
- `--format` - Output format (detailed, summary, json)

## Directory Structure

The git-template system uses a `templated/` directory to organize template development:

```
project-root/
├── examples/rails/myapp/           # Original application (submodule)
├── templated/
│   └── myapp/                      # Templated version for development
│       └── .git_template/          # Template configuration
│           └── template_part/      # Individual template parts
└── .git-template                   # Global configuration
```

## Programmatic Usage

```ruby
require 'git_template'

# Apply template to Rails application
GitTemplate.apply_template(rails_app_generator)

# Get path to bundled template
template_path = GitTemplate.template_path
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then run `rake spec` to run the tests.

```bash
# Run integration tests
bin/test-integration

# Run with debug output
bin/test-integration --debug --verbose
```

To install this gem locally:

```bash
bundle exec rake install
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
