# git-template

A Ruby gem for managing Rails application templates with structured lifecycle management. Includes a comprehensive Rails 8 + Juris.js template with organized phases, user configuration, and extensible module system.

## Features

- **Structured Template Lifecycle**: Organized phases for platform, infrastructure, frontend, testing, security, data flow, and application setup
- **User Configuration Management**: Interactive prompts for customizing template behavior
- **Extensible Module System**: Easy to add new template modules and phases
- **Command-Line Interface**: Simple CLI for applying templates to new or existing Rails applications
- **Rails 8 + Juris.js Template**: Modern Rails setup with Vite, Tailwind CSS, and Juris.js frontend framework

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'git-template'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install git-template
```

## Usage

### For New Rails Applications

Create a new Rails application using the git-template:

```bash
rails new myapp -m git-template
```

### For Existing Rails Applications

Apply the template to an existing Rails application:

```bash
cd myapp
git-template apply
```

### CLI Commands

```bash
# Apply template to current directory
git-template apply

# Apply template to specific path
git-template apply /path/to/rails/app

# Show available templates
git-template list

# Show gem version
git-template version

# Show path to bundled template
git-template path

# Show help
git-template help
```

## Template Structure

The git-template includes the following phases:

1. **Platform Setup** - Ruby version, Rails configuration, database setup
2. **Infrastructure Setup** - Gems, Redis, Solid Stack, deployment configuration
3. **Frontend Setup** - Vite, Tailwind CSS, Inertia.js, Juris.js
4. **Testing Setup** - RSpec, Cucumber, testing frameworks
5. **Security Setup** - Authorization, security gems
6. **Data Flow Setup** - ActiveDataFlow integration (optional)
7. **Application Features** - Models, controllers, views, routes, admin interface

## Configuration Options

During template execution, you'll be prompted for:

- **Redis Usage**: Use Redis or redis-emulator
- **ActiveDataFlow**: Include ActiveDataFlow integration
- **Docker/Kamal**: Setup deployment configuration
- **Sample Models**: Generate example Product models
- **Admin Interface**: Setup admin interface

## Programmatic Usage

You can also use git-template programmatically in your Ruby code:

```ruby
require 'git_template'

# Apply template to Rails application
GitTemplate.apply_template(rails_app_generator)

# Get path to bundled template
template_path = GitTemplate.template_path
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/username/git-template.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
