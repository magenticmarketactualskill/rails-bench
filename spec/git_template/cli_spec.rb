RSpec.describe GitTemplate::CLI do
  describe ".start" do
    it "displays help when no arguments provided" do
      expect { GitTemplate::CLI.start([]) }.to output(/git-template - Rails application template/).to_stdout
    end
  end

  describe "#version" do
    it "displays the version" do
      cli = GitTemplate::CLI.new
      expect { cli.version }.to output(/git-template version #{GitTemplate::VERSION}/).to_stdout
    end
  end

  describe "#list" do
    it "lists available templates" do
      cli = GitTemplate::CLI.new
      expect { cli.list }.to output(/Available templates:/).to_stdout
    end
  end

  describe "#path" do
    it "shows the template path" do
      cli = GitTemplate::CLI.new
      expect { cli.path }.to output(/template\.rb/).to_stdout
    end
  end
end