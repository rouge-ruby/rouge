# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class NSS < RegexLexer
      tag 'nss'
      filenames '*.nss'

      title "NSS"
      desc "NWScript scripting language"

      # optional comment or whitespace
      ws = %r((?:\s|//.*?\n|/[*].*?[*]/)+)
      id = /[a-zA-Z_][a-zA-Z0-9_]*/

      def self.keywords
        @keywords ||= Set.new %w(
          break case const continue default do else for if return struct
          switch while

        )
      end

      def self.keywords_type
        @keywords_type ||= Set.new %w(
          action effect event float int itemproperty location
          object string talent vector void json

        )
      end

      def self.builtins
        @builtins ||= Set.new %w(
          OBJECT_INVALID TRUE FALSE
        )
      end

      def self.reserved
        @reserved ||= []
      end

      start { push :bol }

      state :expr_bol do
        mixin :inline_whitespace

        rule %r/#/, Comment::Preproc, :macro

        rule(//) { pop! }
      end

      # :expr_bol is the same as :bol but without labels, since
      # labels can only appear at the beginning of a statement.
      state :bol do
        rule %r/#{id}:(?!:)/, Name::Label
        mixin :expr_bol
      end

      state :inline_whitespace do
        rule %r/[ \t\r]+/, Text
        rule %r/\\\n/, Text # line continuation
        rule %r(/(\\\n)?[*].*?[*](\\\n)?/)m, Comment::Multiline
      end

      state :whitespace do
        rule %r/\n+/m, Text, :bol
        rule %r(//(\\.|.)*?$), Comment::Single, :bol
        mixin :inline_whitespace
      end

      state :expr_whitespace do
        rule %r/\n+/m, Text, :expr_bol
        mixin :whitespace
      end

      state :statements do
        mixin :whitespace
        rule %r/"/, Str::Double, :string
        rule %r(\d+\.\d+)i, Num::Float
        rule %r/\d+/i, Num::Integer
        rule %r(\*/), Error
        rule %r([~!%^&*+=\|?:<>/-]), Operator
        rule %r/[()\[\],.;]/, Punctuation
        rule %r/\bcase\b/, Keyword, :case
        rule %r/(?:TRUE|FALSE|NULL)\b/, Name::Builtin
        rule %r/([A-Z_a-z]\w*)(\()/ do
          groups Name::Function, Punctuation
        end
        rule id do |m|
          name = m[0]

          if self.class.keywords.include? name
            token Keyword
          elsif self.class.keywords_type.include? name
            token Keyword::Type
          elsif self.class.reserved.include? name
            token Keyword::Reserved
          elsif self.class.builtins.include? name
            token Name::Builtin
          else
            token Name
          end
        end
      end

      state :case do
        rule %r/:/, Punctuation, :pop!
        mixin :statements
      end

      state :root do
        mixin :expr_whitespace
        rule %r(
          ([\w*\s]+?[\s*]) # return arguments
          (#{id})          # function name
          (\s*\([^;]*?\))  # signature
          (#{ws}?)({|;)    # open brace or semicolon
        )mx do |m|
          # TODO: do this better.
          recurse m[1]
          token Name::Function, m[2]
          recurse m[3]
          recurse m[4]
          token Punctuation, m[5]
          if m[5] == ?{
            push :function
          end
        end
        rule %r/\{/, Punctuation, :function
        mixin :statements
      end

      state :function do
        mixin :whitespace
        mixin :statements
        rule %r/;/, Punctuation
        rule %r/{/, Punctuation, :function
        rule %r/}/, Punctuation, :pop!
      end

      state :string do
        rule %r/"/, Str, :pop!
        rule %r/[^\\"\n]+/, Str
        rule %r/\\\n/, Str
        rule %r/\\/, Str # stray backslash
      end

      state :macro do
        mixin :include
        rule %r([^/\n\\]+), Comment::Preproc
        rule %r/\\./m, Comment::Preproc
        mixin :inline_whitespace
        rule %r(/), Comment::Preproc
        # NB: pop! goes back to :bol
        rule %r/\n/, Comment::Preproc, :pop!
      end

      state :include do
        rule %r/(include)(\s*)("[^"]+")([^\n]*)/ do
          groups Comment::Preproc, Text, Comment::PreprocFile, Comment::Single
        end
      end

    end
  end
end
