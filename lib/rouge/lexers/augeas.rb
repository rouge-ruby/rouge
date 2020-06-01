# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Augeas < RegexLexer
      title "Augeas"
      desc "The Augeas programming language (augeas.net)"

      tag 'augeas'
      aliases 'aug'
      filenames '*.aug'
      mimetypes 'text/x-augeas'

      def self.reserved
        @reserved ||= Set.new %w(
          _ let del store value counter seq key label autoload
          incl excl transform test get put in after set
        )
      end

      def self.types
        @types ||= Set.new %w(
          unit string regexp lens tree filter
        )
      end

      state :basic do
        rule %r/\s+/m, Text
        rule %r/\(\*/, Comment::Multiline, :comment
      end

      state :comment do
        rule %r/\*\)/, Comment::Multiline, :pop!
        rule %r/\(\*/, Comment::Multiline, :comment
        rule %r/[^*)]+/, Comment::Multiline
        rule %r/[*)]/, Comment::Multiline
      end

      state :root do
        mixin :basic

        rule %r/\w[\w']*/ do |m|
          name = m[0]
          if name == "module"
            token Keyword::Reserved
            push :module
          elsif self.class.reserved.include? name
            token Keyword::Reserved
          elsif self.class.types.include? name
            token Keyword::Type
          elsif name =~ /\A[A-Z]/
            token Keyword::Namespace
          else
            token Name
          end
        end

        # operators
        rule %r([-*+.=?\|]+), Operator
        rule %r/"/, Str, :string
        rule %r/\//, Str, :regexp

        rule %r/[\[\](){}:]/, Punctuation
      end

      state :module do
        rule %r/\s+/, Text
        # module Foo (functions)
        rule %r/([A-Z][\w.]*)(\s+)(\()/ do
          groups Name::Namespace, Text, Punctuation
        end

        rule %r/[A-Z][a-zA-Z0-9_.]*/, Name::Namespace, :pop!
      end

      state :regexp do
        rule %r/\//, Str, :pop!
        rule %r/\\/, Str::Escape, :escape
        rule %r/[^\/]+/, Str::Regex
      end

      state :string do
        rule %r/"/, Str, :pop!
        rule %r/\\/, Str::Escape, :escape
        rule %r/[^\\"]+/, Str
      end

      state :escape do
        rule %r/[abfnrtv"'&\\]/, Str::Escape, :pop!
        rule %r/\^[\]\[A-Z@\^_]/, Str::Escape, :pop!
        rule %r/o[0-7]+/i, Str::Escape, :pop!
        rule %r/x[\da-f]+/i, Str::Escape, :pop!
        rule %r/\d+/, Str::Escape, :pop!
        rule %r/\s+\\/, Str::Escape, :pop!
      end
    end
  end
end
