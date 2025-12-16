# Simple Rails Template

A minimal Rails application template based on the [Rails Application Templates Guide](https://edgeguides.rubyonrails.org/rails_application_templates.html).

## What it does

This template creates a simple Rails application with optional enhancements:

- **Essential gems** for development and testing
- **Authentication** with Devise (optional)
- **Bootstrap styling** (optional)
- **RSpec testing** (optional)
- **Simple home page** with welcome message
- **Basic project structure**

## Usage

### For new Rails applications:
```bash
rails new myapp -m path/to/simple/.git_template/template.rb
```

### For existing Rails applications:
```bash
bin/rails app:template LOCATION=path/to/simple/.git_template/template.rb
```

### Using git-template command:
```bash
git-template test --templated_app_path examples/rails/simple
```

## Features

### Core Features
- ✅ Clean Rails 8 application structure
- ✅ Essential development gems (debug, web-console)
- ✅ Simple home controller and view
- ✅ Root route configuration

### Optional Features (user prompted)
- 🔐 **Authentication**: Devise gem with User model
- 🎨 **Styling**: Bootstrap 5 with custom SCSS
- 🧪 **Testing**: RSpec with factory_bot and faker
- 📝 **Documentation**: Generated README with setup instructions

## Template Structure

```
simple/
├── .git_template/
│   ├── template.rb          # Main template file
│   └── README.md           # This file
├── app/                    # Standard Rails app structure
├── config/                 # Rails configuration
├── Gemfile                 # Basic gems
└── ...                     # Other Rails files
```

## What the template adds

1. **Gems**: Adds essential development and testing gems
2. **Authentication**: Optionally sets up Devise with User model
3. **Styling**: Optionally adds Bootstrap with custom SCSS
4. **Testing**: Optionally configures RSpec with basic specs
5. **Home Page**: Creates a welcome page with feature overview
6. **Database**: Sets up and migrates the database
7. **Git**: Optionally initializes git repository

## Example Output

When you run the template, you'll see:

```
Simple Rails Application Template
================================

This template will enhance your Rails application with:
  • Essential gems for development and testing
  • Basic authentication setup
  • Simple home page
  • Code quality tools

Add authentication with Devise? (y/n) y
Add Bootstrap for styling? (y/n) y
Setup RSpec for testing? (y/n) y

Starting template application...
Adding essential gems...
Setting up Devise authentication...
Setting up RSpec...
Creating home page...
Setting up Bootstrap...
```

## Customization

The template is designed to be simple and extensible. You can:

- Modify the gem selections in `template.rb`
- Customize the home page layout
- Add additional controllers or models
- Extend the Bootstrap styling
- Add more test configurations

## Comparison with rails8-juris

| Feature | Simple | Rails8-Juris |
|---------|--------|--------------|
| Complexity | Minimal | Full-featured |
| Frontend | Basic HTML + Bootstrap | Vite + Inertia + Juris.js |
| Authentication | Devise (optional) | Pundit + custom |
| Testing | RSpec (optional) | RSpec + Cucumber |
| Database | SQLite | SQLite + ActiveDataFlow |
| Deployment | None | Docker + Kamal |

Choose **Simple** for:
- Learning Rails
- Quick prototypes
- Minimal applications
- Traditional Rails apps

Choose **Rails8-Juris** for:
- Production applications
- Modern frontend needs
- Complex data flows
- Full-stack development