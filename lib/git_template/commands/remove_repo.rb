# RemoveRepoCommand Concern
#
# This command removes a submodule and its corresponding templated folder,
# with safety checks for unpushed changes and force override capability.

require_relative 'base'
require_relative '../services/git_operations'
require_relative '../models/result/iterate_command_result'
require_relative '../status_command_errors'
require 'open3'
require 'fileutils'

module GitTemplate
  module Command
    module RemoveRepo
      def self.included(base)
        base.class_eval do
          desc "remove-repo --path PATH|--url URL", "Remove submodule and templated folder by path or URL"
          add_common_options
          option :force, type: :boolean, default: false, desc: "Force removal even if there are unpushed changes"
          option :path, type: :string, desc: "Submodule path to remove"
          option :url, type: :string, desc: "Repository URL to find and remove"
          
          define_method :remove_repo do
            execute_with_error_handling("remove_repo", options) do
              log_command_execution("remove_repo", [], options)
              setup_environment(options)
              
              # Validate that either path or url is provided
              unless options[:path] || options[:url]
                result = Models::Result::IterateCommandResult.new(
                  success: false,
                  operation: "remove_repo",
                  error_message: "Either --path or --url parameter is required for remove-repo command"
                )
                puts result.format_output(options[:format], options)
                return result
              end
              
              # Validate that both path and url are not provided
              if options[:path] && options[:url]
                result = Models::Result::IterateCommandResult.new(
                  success: false,
                  operation: "remove_repo",
                  error_message: "Cannot specify both --path and --url parameters. Use one or the other."
                )
                puts result.format_output(options[:format], options)
                return result
              end
              
              # Execute repository removal
              result = perform_remove_repo(options)
              
              # Format and display output
              puts result.format_output(options[:format], options)
              
              result
            end
          end
          
          private
          
          define_method :perform_remove_repo do |options|
            begin
              # Determine submodule path and URL
              if options[:path]
                # Remove by path - validate path exists and get URL
                submodule_path = options[:path]
                remote_url = find_submodule_url(submodule_path)
                unless remote_url
                  return Models::Result::IterateCommandResult.new(
                    success: false,
                    operation: "remove_repo",
                    error_message: "No submodule found at path #{submodule_path}"
                  )
                end
              else
                # Remove by URL - find the path for this URL
                remote_url = options[:url]
                submodule_path = find_submodule_path(remote_url)
                unless submodule_path
                  return Models::Result::IterateCommandResult.new(
                    success: false,
                    operation: "remove_repo",
                    error_message: "No submodule found with URL #{remote_url}"
                  )
                end
              end
              
              # Check for unpushed changes unless force is enabled
              unless options[:force]
                unpushed_changes = check_unpushed_changes(submodule_path)
                if unpushed_changes
                  return Models::Result::IterateCommandResult.new(
                    success: false,
                    operation: "remove_repo",
                    error_message: "Submodule has unpushed changes. Use --force to override or push changes first."
                  )
                end
              end
              
              # Extract repo name from URL for templated folder (same logic as recreate-repo)
              repo_name = File.basename(remote_url, '.git')
              templated_path = "templated/#{repo_name}"
              
              # Remove submodule
              remove_submodule(submodule_path)
              
              # Remove templated folder if it exists
              removed_templated = false
              if Dir.exist?(templated_path)
                FileUtils.rm_rf(templated_path)
                removed_templated = true
              end
              
              # Return success
              Models::Result::IterateCommandResult.new(
                success: true,
                operation: "remove_repo",
                data: { 
                  message: "Repository removal completed successfully",
                  removed_submodule_path: submodule_path,
                  removed_templated_path: removed_templated ? templated_path : nil,
                  remote_url: remote_url
                }
              )
              
            rescue => e
              # Return error result object
              Models::Result::IterateCommandResult.new(
                success: false,
                operation: "remove_repo",
                error_message: e.message,
                error_type: e.class.name
              )
            end
          end
          
          define_method :find_submodule_path do |remote_url|
            # Check if .gitmodules exists
            return nil unless File.exist?('.gitmodules')
            
            gitmodules_content = File.read('.gitmodules')
            current_submodule = nil
            current_path = nil
            
            gitmodules_content.lines.each do |line|
              line = line.strip
              
              if line.match(/^\[submodule "(.+)"\]$/)
                current_submodule = $1
                current_path = nil
              elsif line.match(/^\s*path\s*=\s*(.+)$/)
                current_path = $1.strip
              elsif line.match(/^\s*url\s*=\s*(.+)$/)
                url = $1.strip
                if url == remote_url && current_path
                  return current_path
                end
              end
            end
            
            nil
          end
          
          define_method :find_submodule_url do |submodule_path|
            # Check if .gitmodules exists
            return nil unless File.exist?('.gitmodules')
            
            gitmodules_content = File.read('.gitmodules')
            current_submodule = nil
            current_path = nil
            current_url = nil
            
            gitmodules_content.lines.each do |line|
              line = line.strip
              
              if line.match(/^\[submodule "(.+)"\]$/)
                current_submodule = $1
                current_path = nil
                current_url = nil
              elsif line.match(/^\s*path\s*=\s*(.+)$/)
                current_path = $1.strip
              elsif line.match(/^\s*url\s*=\s*(.+)$/)
                current_url = $1.strip
                if current_path == submodule_path && current_url
                  return current_url
                end
              end
            end
            
            nil
          end
          
          define_method :check_unpushed_changes do |submodule_path|
            return false unless Dir.exist?(submodule_path)
            
            Dir.chdir(submodule_path) do
              # Check if there are any commits ahead of origin
              stdout, stderr, status = Open3.capture3('git rev-list --count @{u}..HEAD 2>/dev/null')
              
              # If command fails, assume no remote tracking or no unpushed changes
              return false unless status.success?
              
              # If count > 0, there are unpushed commits
              unpushed_count = stdout.strip.to_i
              return unpushed_count > 0
            end
          rescue => e
            # If we can't check, assume no unpushed changes to be safe
            false
          end
          
          define_method :remove_submodule do |submodule_path|
            # Deinitialize the submodule
            stdout, stderr, status = Open3.capture3("git submodule deinit -f #{submodule_path}")
            unless status.success?
              raise StandardError.new("Failed to deinitialize submodule: #{stderr.strip}")
            end
            
            # Remove the submodule from git
            stdout, stderr, status = Open3.capture3("git rm -f #{submodule_path}")
            unless status.success?
              raise StandardError.new("Failed to remove submodule from git: #{stderr.strip}")
            end
            
            # Remove the physical directory if it still exists
            if Dir.exist?(submodule_path)
              FileUtils.rm_rf(submodule_path)
            end
            
            # Remove from .git/modules if it exists
            modules_path = ".git/modules/#{submodule_path}"
            if Dir.exist?(modules_path)
              FileUtils.rm_rf(modules_path)
            end
          end
        end
      end
    end
  end
end