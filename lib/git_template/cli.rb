require "thor"
require "fileutils"
require_relative "commands/diff_result"
require_relative "commands/clone"
require_relative "commands/status"
require_relative "commands/iterate"
require_relative "commands/update"
require_relative "commands/push"
require_relative "commands/status_command"

module GitTemplate
  class CLI < Thor
    include GitTemplate::Command::DiffResult
    include GitTemplate::Command::Clone
    include GitTemplate::Command::Status
    include GitTemplate::Command::Iterate
    include GitTemplate::Command::Update
    include GitTemplate::Command::Push
    include GitTemplate::Command::StatusCommand
  end
end