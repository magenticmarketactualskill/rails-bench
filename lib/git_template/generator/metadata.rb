      def generate
        output = []
        
        # Add metadata header
        output << metadata_comment
        output << ""
        
        output << 'source "https://rubygems.org"'
        output << ""
                if metadata[:git]
          git_info = metadata[:git]
          if git_info[:commit]
            lines << "#{prefix} Git commit: #{git_info[:commit]}"
          end
          if git_info[:branch]
            lines << "#{prefix} Git branch: #{git_info[:branch]}"
          end
          if git_info[:status] && !git_info[:status].empty?
            lines << "#{prefix} Git status: #{git_info[:status]}"
          end
          if git_info[:remote]
            lines << "#{prefix} Git remote: #{git_info[:remote]}"
          end
          
        begin
          # Get current commit hash
          commit = `git rev-parse HEAD 2>/dev/null`.strip
          git_info[:commit] = commit unless commit.empty?
          
          # Get current branch
          branch = `git rev-parse --abbrev-ref HEAD 2>/dev/null`.strip
          git_info[:branch] = branch unless branch.empty?
          
          # Get repository status (check if there are uncommitted changes)
          status_output = `git status --porcelain 2>/dev/null`.strip
          if !status_output.empty?
            git_info[:status] = "dirty (#{status_output.lines.count} changes)"
          else
            git_info[:status] = "clean"
          end

        puts "Generated Gemfile with metadata"
      end