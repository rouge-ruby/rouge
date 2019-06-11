require 'git'

module Rouge
  class Gitlog
    class Message
      def initialize(original, author)
        @subject = original.match(/.*/)[0]
        @author = author
      end

      def formatted(remote)
        "   - " + @subject.gsub(/\(#(\d+)\)/,
                                "([#\\1](https://#{remote}/pr/\\1/) by #{@author})")
      end
    end

    def initialize(dir, remote, beg_sha, end_sha = nil)
      @repo = Git.open(dir)
      @remote = remote
      @log = @repo.log(100).between(beg_sha, end_sha)
      @msgs = @log.map { |l| Message.new(l.message, l.author.name) }
    end

    def converted
      @msgs.map { |m| m.formatted(@remote) }
    end

    def prev_version
      @prev_version ||= @repo.tags.select { |t| t.name.match?(/^v\d+\.\d+\.\d$/) }.
                                   map { |t| t.name.slice(1..-1).split(".").map(&:to_i) }.
                                   sort { |a,b| sort_versions(a, b) }.
                                   map { |t| "v" + t.join(".") }.
                                   last
    end

    def sort_versions(a, b)
      if a[0] == b[0] && a[1] == b[1]
        a[2] <=> b[2]
      elsif a[0] == b[0]
        a[1] <=> b[1]
      else
        a[0] <=> b[0]
      end
    end
  end
end

def version_line(version)
  "## version #{version}: (#{Time.now.strftime("%Y/%m/%d")})\n\n"
end

def comparison_line(remote, previous, current)
  "https://#{remote}/compare/#{previous}...#{current}\n\n"
end

namespace :changelog do
  desc "Insert lines in CHANGELOG.md for commits between SHAs (inclusive)" 
  task :insert, [:beg_sha, :end_sha] do |t, args|
    args.with_defaults(:end_sha => nil)

    remote = "github.com/rouge-ruby/rouge"
    changelog = "CHANGELOG.md"
    working_dir = "."

    gitlog = Rouge::Gitlog.new(working_dir, remote, args.beg_sha, args.end_sha)
    
    text = ''
    not_inserted = true

    File.readlines(changelog).each do |l|
      if not_inserted && l.start_with?("##")
        text += version_line(Rouge.version)
        text += comparison_line(remote, gitlog.prev_version, "v" + Rouge.version)
        text += gitlog.converted.join("\n")
        text += "\n\n"
        not_inserted = false
      end
      
      text += l
    end

    File.write(changelog, text)
  end
end
