RSpec.describe GitTemplate::TemplateResolver do
  describe ".gem_template_path" do
    it "returns the path to the bundled template" do
      path = GitTemplate::TemplateResolver.gem_template_path
      expect(path).to be_a(String)
      expect(path).to end_with("template.rb")
    end
  end

  describe ".gem_template_directory" do
    it "returns the path to the template directory" do
      path = GitTemplate::TemplateResolver.gem_template_directory
      expect(path).to be_a(String)
      expect(path).to end_with("template")
    end
  end

  describe ".template_exists?" do
    it "returns true for existing template" do
      expect(GitTemplate::TemplateResolver.template_exists?).to be true
    end

    it "returns false for non-existing template" do
      expect(GitTemplate::TemplateResolver.template_exists?("/nonexistent/path/template.rb")).to be false
    end
  end

  describe ".available_modules" do
    it "returns an array of module information" do
      modules = GitTemplate::TemplateResolver.available_modules
      expect(modules).to be_an(Array)
      
      if modules.any?
        module_info = modules.first
        expect(module_info).to have_key(:path)
        expect(module_info).to have_key(:phase)
        expect(module_info).to have_key(:name)
      end
    end
  end
end