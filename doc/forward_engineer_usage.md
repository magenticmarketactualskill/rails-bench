# forward-engineer Command Usage

The `forward-engineer` command combines the functionality of `run_template_part` and `rerun-template` into a single unified command. It provides two modes of operation:

## Modes

### 1. Template Part Mode (--template_part)
Execute a specific template part file from `.git_template/template_part` directories.

**Usage:**
```bash
git-template forward-engineer --template_part=PATH
```

**Options:**
- `--template_part=PATH` - Path to the specific template part file to execute (required for this mode)
- `--target_dir=DIR` - Target directory to execute the template part in (defaults to current directory)
- `--verbose` - Show verbose output during execution

**Examples:**
```bash
# Execute a specific template part
git-template forward-engineer --template_part=.git_template/template_part/01_setup.rb

# Execute template part in a different directory
git-template forward-engineer --template_part=../templates/setup.rb --target_dir=/path/to/project

# Execute with verbose output
git-template forward-engineer --template_part=.git_template/template_part/02_models.rb --verbose
```

### 2. Full Template Mode (--full)
Run the complete template processing, regenerating all files based on the current template configuration.

**Usage:**
```bash
git-template forward-engineer --full
```

**Options:**
- `--full` - Run full template processing (required for this mode)
- `--target_dir=DIR` - Target directory (defaults to current directory)
- `--update_content` - Update template content based on current state (default: true)

**Examples:**
```bash
# Rerun full template in current directory
git-template forward-engineer --full

# Rerun full template in specific directory
git-template forward-engineer --full --target_dir=/path/to/templated/project

# Rerun without updating content
git-template forward-engineer --full --update_content=false
```

## Validation Rules

1. **Must specify exactly one mode:**
   - Either `--template_part=PATH` OR `--full`
   - Cannot specify both modes simultaneously
   - Must specify at least one mode

2. **Template Part Mode Requirements:**
   - File must exist
   - File must be in a `template_part` or `template_parts` directory, OR be a `template.rb` file in `.git_template`
   - Target directory must exist

3. **Full Template Mode Requirements:**
   - Target directory must exist
   - Target directory must have a `.git_template` configuration
   - Target directory cannot be a Git submodule (protected)

## Error Messages

### No Mode Specified
```
Error: Must specify either --template_part=PATH or --full. Use --help for more information.
```

### Both Modes Specified
```
Error: Cannot specify both --template_part and --full. Choose one mode.
```

### Invalid Template Part Path
```
Error: Template part file does not exist: /path/to/file
Error: Path is not a file: /path/to/directory
Error: File must be in a 'template_part' directory or be a 'template.rb' file in '.git_template'
```

### Missing Template Configuration
```
Error: No template configuration found at /path. Use create-templated-folder first.
```

## Comparison with Original Commands

### Replacing run_template_part
**Old:**
```bash
git-template run_template_part --path=.git_template/template_part/setup.rb
```

**New:**
```bash
git-template forward-engineer --template_part=.git_template/template_part/setup.rb
```

### Replacing rerun-template
**Old:**
```bash
git-template rerun-template
git-template rerun-template --path=/some/dir
```

**New:**
```bash
git-template forward-engineer --full
git-template forward-engineer --full --target_dir=/some/dir
```

## Output Examples

### Successful Template Part Execution
```
🚀 Executing template part: setup.rb
📁 Target directory: /Users/user/project
📄 Template part path: /Users/user/project/.git_template/template_part/setup.rb
============================================================

✅ Template part executed successfully!

📋 Output:
Created file: config/initializers/app_config.rb
Modified file: config/application.rb
```

### Successful Full Template Execution
```
🚀 Running full template processing
📁 Target directory: /Users/user/project
============================================================

✅ Full template executed successfully!
```

## Common Use Cases

1. **Incremental Development**: Use `--template_part` to test individual template sections during development
2. **Full Regeneration**: Use `--full` to regenerate all files when template has been updated
3. **Testing**: Use `--template_part` to verify specific template parts work correctly before committing
4. **Deployment**: Use `--full` to ensure all application files are up-to-date with the latest template

## Tips

- Use `--verbose` flag with template part mode to see detailed execution logs
- Always test template parts individually before running full template processing
- The command preserves all features from the original commands while providing a unified interface
- Both modes support all common options like `--format`, `--debug`, and `--force`
