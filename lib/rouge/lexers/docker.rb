# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Docker < RegexLexer
      title "Docker"
      desc "Dockerfile syntax"
      tag 'docker'
      aliases 'docker', 'dockerfile'
      filenames 'Dockerfile', '*.docker'
      mimetypes 'text/x-dockerfile-config'

      def self.analyze_text(text)
        return 0.8 if text =~ /\AFROM\s+.+/im
        return 0.6 if text =~ /^MAINTAINER\s+.+/i
      end

      KEYWORDS = %w(
        FROM MAINTAINER CMD EXPOSE ENV ADD ENTRYPOINT VOLUME WORKDIR
      ).join('|')

      state :root do
        rule /^(ONBUILD)(\s+)(#{KEYWORDS})\b/im do |m|
          groups Keyword, Text::Whitespace, Keyword
        end

        rule /^(#{KEYWORDS})\b(.*)/i do |m|
          groups Keyword, Str
        end

        rule /#.*?$/, Comment

        rule /RUN/i, Keyword

        rule /(.*\\\n)*.+/ do
          delegate Shell
        end

        rule /$\s*/m, Text
      end
    end
  end
end
