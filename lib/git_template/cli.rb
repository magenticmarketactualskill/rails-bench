require "thor"
require "fileutils"
#require_relative "commands/status_command"
#require_relative "commands/clone_command"
#require_relative "commands/iterate_command"
#require_relative "commands/update_command"
#require_relative "commands/push_command"
#require_relative "commands/push_command"
require_relative "commands/diff_result_command_concern"

module GitTemplate
  class CLI < Thor
    include DiffResultCommand
  end
end