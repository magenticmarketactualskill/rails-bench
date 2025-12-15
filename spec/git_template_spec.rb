RSpec.describe GitTemplate do
  it "has a version number" do
    expect(GitTemplate::VERSION).not_to be nil
  end

  it "has a valid semantic version format" do
    expect(GitTemplate.version_valid?).to be true
  end

  describe ".template_path" do
    it "returns a path to the bundled template" do
      path = GitTemplate.template_path
      expect(path).to be_a(String)
      expect(File.exist?(path)).to be true
    end
  end
end