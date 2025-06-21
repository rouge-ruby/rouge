# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Docker < RegexLexer
      title "Docker"
      desc "Dockerfile syntax"
      tag 'docker'
      aliases 'dockerfile', 'Dockerfile', 'containerfile', 'Containerfile'
      filenames 'Dockerfile', 'Dockerfile.*', '*.Dockerfile', '*.docker', 'Containerfile', 'Containerfile.*', '*.Containerfile'
      mimetypes 'text/x-dockerfile-config'

      KEYWORDS = %w(
        FROM MAINTAINER CMD EXPOSE ADD COPY ENTRYPOINT VOLUME USER WORKDIR ARG STOPSIGNAL HEALTHCHECK SHELL
      ).join('|')

      start { @shell = Shell.new(@options) }

      state :root do
        rule %r/\s+/, Text

        rule %r/^(FROM)(\s+)(.*)(\s+)(AS)(\s+)(.*)/io do
          groups Keyword, Text::Whitespace, Str, Text::Whitespace, Keyword, Text::Whitespace, Str
        end

        rule %r/^(ONBUILD)(\s+)(#{KEYWORDS})(.*)/io do
          groups Keyword, Text::Whitespace, Keyword, Str
        end

        rule %r/^(#{KEYWORDS})\b(.*)/io do
          groups Keyword, Str
        end

        rule %r/#.*?$/, Comment

        rule %r/^(ONBUILD\s+)?RUN(\s+)/i do
          token Keyword
          push :run
          @shell.reset!
        end

        rule %r/^(LABEL|ENV)(\s+)/i do
          token Keyword
          push :identifier
        end

        rule %r/\w+/, Text
        rule %r/[^\w]+/, Text
        rule %r/./, Text
      end

      state :run do
        rule %r/\n/, Text, :pop!
        rule %r/^\s*#.*\n/, Comment
        rule %r/\\./m, Str::Escape
        rule(/(\\.|[^\n\\])+/) { delegate @shell }
      end

      state :identifier do
        rule %r/\n/, Text, :pop!
        rule %r/^\s*#.*\n/, Comment
        rule %r/\s*\\./m, Str::Escape
        rule %r/(\s*(?:[^\s=]+|"[^"]+"|'[^']+'))(=)/ do
          groups Name::Property, Punctuation
          push :value
        end
      end

      state :value do
        rule %r/\n/, Text, :pop!
        rule %r/(".*?")|('.*?')|((?:[^\\\s]|\\\s)+)/m, Str, :pop!
      end
    end
  end
end
