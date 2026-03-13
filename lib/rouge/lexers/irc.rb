# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class IRC < RegexLexer
      title "IRC"
      desc "RFC1459 and IRCv3 protocol framing"
      tag "irc"

      state :root do
        rule %r/@/, Punctuation, :tags
        rule %r/:/, Punctuation, :source
        # numeric command
        rule %r/(\d+)/, Num, :args
        # verb command
        rule %r/\S+/, Name::Function, :args
        # no args
        rule %r/\n/, Text::Whitespace
      end

      state :tags do
        # we've read all the tags!
        rule %r/ +/, Text::Whitespace, :pop!
        rule %r/=/, Operator, :tag_value
        rule %r/;/, Punctuation

        # draft or vendor prefixed tag
        rule %r,([^;= /]+)(/), do
          groups Name::Namespace, Punctuation
        end

        rule %r/[^;= ]/, Name::Variable
      end

      state :tag_value do
        # next char is a space;
        # yield up to the parent state
        rule %r/(?= )/, Text::Whitespace, :pop!
        rule %r/;/, Punctuation, :pop!
        rule %r/\\./, Str::Escape
        rule %r/[^\\; ]+/, Str
      end

      state :source do
        rule %r/ +/, Text::Whitespace, :pop!

        # !~user
        rule %r/(!)([^ @]+)/ do
          groups Punctuation, Str
        end

        # @host
        rule %r/(@)([^ ]+)/ do
          groups Punctuation, Str
        end

        # nick
        rule %r/[^ !]+/, Name
      end

      state :args do
        rule %r/ +/, Text::Whitespace

        # :trailing arg
        rule %r/(:)(.*)/ do
          groups Punctuation, Str
        end

        # normal space-delimited arg
        rule %r/\S+/, Str
        # we've read all the args!
        rule %r/\n/, Text::Whitespace, :pop!
      end
    end
  end
end
