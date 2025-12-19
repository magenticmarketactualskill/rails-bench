# TemplateGeneratorRegistry - Discovers, validates, and manages template generators
#
# This class auto-discovers Rails generators in the git-template system,
# maps generators to template phases, validates generator structure,
# and provides generator metadata and execution capabilities.

require_relative 'git_template/generator/base'
require_relative 'git_template/generator/gem_bundle'


class TemplateGeneratorRegistry
  attr_reader :module_registry, :discovered_modules, :phase_modules

  def initialize(module_registry = "module_registry")
    @module_registry = module_registry
    @discovered_modules = {}
    @phase_modules = {}
    @registered_generators = {}
    register_default_generators
  end

  def discover_modules
    @discovered_modules.clear
    @phase_modules.clear
    
    if Dir.exist?(@module_registry)
      scan_phase_folders
    else
      # Fallback to legacy flat structure
      scan_legacy_structure
    end
    
    @discovered_modules
  end

  def register_module(path, metadata = {})
    module_info = {
      path: path,
      name: metadata[:name] || File.basename(path, '.rb'),
      description: metadata[:description] || "",
      dependencies: metadata[:dependencies] || [],
      conditions: metadata[:conditions] || {},
      phase: metadata[:phase] || extract_phase_from_path(path)
    }
    
    @discovered_modules[path] = module_info
    
    # Add to phase modules mapping
    phase = module_info[:phase]
    @phase_modules[phase] ||= []
    @phase_modules[phase] << path unless @phase_modules[phase].include?(path)
    
    module_info
  end

  def get_module(path)
    @discovered_modules[path]
  end

  def get_modules_for_phase(phase_name)
    @phase_modules[phase_name] || []
  end

  def validate_module(path)
    return false unless File.exist?(path)
    return false unless path.end_with?('.rb')
    
    # Basic syntax validation - check if file can be read
    begin
      File.read(path)
      true
    rescue => error
      false
    end
  end

  def scan_phase_folders
    phase_folders = Dir.glob(File.join(@module_registry, '*')).select { |f| File.directory?(f) }
    
    phase_folders.each do |phase_folder|
      phase_name = File.basename(phase_folder)
      
      # Discover Ruby files in this phase folder
      module_files = Dir.glob(File.join(phase_folder, '*.rb'))
      
      module_files.each do |module_file|
        if validate_module(module_file)
          register_module(module_file, phase: phase_name)
        end
      end
    end
  end

  def resolve_module_path(phase, module_name)
    # Ensure module_name has .rb extension
    module_name = "#{module_name}.rb" unless module_name.end_with?('.rb')
    
    File.join(@module_registry, phase, module_name)
  end

  # Support for extensibility - add new phases
  def add_phase_folder(phase_name)
    phase_path = File.join(@module_registry, phase_name)
    Dir.mkdir(phase_path) unless Dir.exist?(phase_path)
    phase_path
  end

  # Get all discovered phases
  def discovered_phases
    @phase_modules.keys
  end

  # Get module count for a phase
  def module_count_for_phase(phase_name)
    (@phase_modules[phase_name] || []).length
  end

  # Get total module count
  def total_module_count
    @discovered_modules.length
  end
  
  # Register a Rails generator
  def register_generator(name, generator_class, phase = nil)
    @registered_generators[name] = {
      class: generator_class,
      phase: phase || infer_phase_from_generator_name(name)
    }
  end
  
  # Get registered generator
  def get_generator(name)
    @registered_generators[name]
  end
  
  # Get all generators for a phase
  def get_generators_for_phase(phase_name)
    @registered_generators.select { |name, info| info[:phase] == phase_name }
  end
  
  # Execute a generator
  def execute_generator(name, *args)
    generator_info = @registered_generators[name]
    return false unless generator_info
    
    generator_module = generator_info[:class]
    
    # Execute the module's execute method
    generator_module.execute(*args)
    
    true
  rescue => e
    puts "Error executing generator #{name}: #{e.message}"
    false
  end
  
  # Get all registered generators
  def all_generators
    @registered_generators
  end

  private
  
  def register_default_generators
    register_generator(:gem_bundle, GitTemplate::Generators::GemBundle, '030_PHASE')
    register_generator(:view, GitTemplate::Generators::View, '040_PHASE')
    register_generator(:test, GitTemplate::Generators::Test, '050_PHASE')
    register_generator(:home_feature, GitTemplate::Generators::HomeFeature, '100_PHASE')
    register_generator(:post_feature, GitTemplate::Generators::PostFeature, '100_PHASE')
    register_generator(:completion, GitTemplate::Generators::Completion, '900_PHASE')
  end
  
  def infer_phase_from_generator_name(name)
    case name.to_s
    when /gem|bundle/
      '030_PHASE'
    when /view|styling|markup/
      '040_PHASE'
    when /test|rspec/
      '050_PHASE'
    when /feature|model|controller/
      '100_PHASE'
    when /completion|complete/
      '900_PHASE'
    else
      'unknown'
    end
  end

  def scan_legacy_structure
    # Fallback: scan current directory for .rb files (excluding template.rb)
    legacy_files = Dir.glob('*.rb').reject { |f| f == 'template.rb' }
    
    legacy_files.each do |file|
      if validate_module(file)
        # Try to infer phase from filename or content
        phase = infer_phase_from_filename(file)
        register_module(file, phase: phase)
      end
    end
  end

  def extract_phase_from_path(path)
    # Extract phase name from path like "template/platform/ruby_version.rb"
    path_parts = path.split('/')
    
    if path_parts.length >= 2 && path_parts[0] == @module_registry
      path_parts[1]
    else
      'unknown'
    end
  end

  def infer_phase_from_filename(filename)
    # Simple heuristics to infer phase from filename
    case filename
    when /ruby_version|rails_config|database/
      'platform'
    when /gems|redis|solid_stack|deployment/
      'infrastructure'
    when /vite|tailwind|inertia|juris/
      'frontend'
    when /rspec|cucumber/
      'testing'
    when /authorization|security/
      'security'
    when /active_data_flow/
      'data_flow'
    when /models|controllers|views|routes|admin/
      'application'
    else
      'unknown'
    end
  end
end