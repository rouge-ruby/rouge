namespace :update do
  desc "Insert lines in CHANGELOG.md for commits between SHAs (inclusive)" 
  task :changelog, [:beg_sha, :end_sha] do |t, args|
    args.with_defaults(:end_sha => nil)

    changelog = "CHANGELOG.md"

    remote = "github.com/rouge-ruby/rouge"
    working_dir = Rake.application.original_dir
    repo = Rouge::Tasks::Git.new(working_dir, remote)
    gitlog = repo.log(args.beg_sha, args.end_sha)
    
    text = ''
    not_inserted = true

    File.readlines(changelog).each do |l|
      if not_inserted && l.start_with?("##")
        text += Rouge::Tasks.version_line(Rouge.version)
        text += Rouge::Tasks.comparison_line(remote, 
                                             repo.prev_version, 
                                             "v" + Rouge.version)
        text += gitlog.converted.join("") + "\n"
        not_inserted = false
      end
      
      text += l
    end

    File.write(changelog, text)
  end
end

require 'git'

module Rouge
  module Tasks
    class Git
      def initialize(dir, remote)
        @repo = ::Git.open(dir)
        @remote = remote
      end

      def log(beg_sha, end_sha = nil)
        commits = @repo.log(100).between(beg_sha, end_sha)
        Log.new(@remote, commits)
      end
      
      def prev_version
        @prev_version ||= @repo
          .tags
          .select { |t| t.name.match?(/^v\d+\.\d+\.\d$/) }
          .map { |t| t.name.slice(1..-1).split(".").map(&:to_i) }
          .sort { |a,b| sort_versions(a, b) }
          .last
          .join(".")
          .prepend("v")
      end

      def sort_versions(a, b)
        return a[2] <=> b[2] if a[0] == b[0] && a[1] == b[1]
        return a[1] <=> b[1] if a[0] == b[0]
        return a[0] <=> b[0]
      end
      
      class Log 
        def initialize(remote, commits)
          @remote = remote
          @msgs = commits.map { |c| Message.new(c.message, c.author.name) }
        end

        def converted
          @msgs.map { |m| m.formatted(@remote) }
        end

        class Message
          def initialize(original, author)
            @subject = original.match(/.*/)[0]
            @author = author
          end

          def formatted(remote)
            msg = @subject.gsub(/\(#(\d+)\)/, Tasks.link_line(remote, @author))
            Tasks.message_line(msg)
          end
        end
      end
    end
    
    def self.comparison_line(remote, previous, current)
      "[Comparison with the previous version](https://#{remote}/compare/#{previous}...#{current})\n\n"
    end

    def self.link_line(remote, author)
      "([#\\1](https://#{remote}/pull/\\1/) by #{author})"
    end

    def self.message_line(message)
      "  - #{message}\n"
    end
    
    def self.version_line(version)
      "## version #{version}: #{Time.now.strftime("%Y-%m-%d")}\n\n"
    end
  end
end
