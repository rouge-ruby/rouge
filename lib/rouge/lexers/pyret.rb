# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Pyret < RegexLexer
      title "Pyret"
      desc "The teaching-optimized Pyret programming language (pyret.org)"
      tag "pyret"
      aliases "arr"
      filenames "*.arr", "*.pyret"
      mimetypes "application/pyret"
      
      def self.keywords
        @keywords ||= Set.new ["as",
          "ask",
          "block",
          "cases",
          "data",
          "doc",
          "else",
          "end",
          "for",
          "from",
          "fun",
          "if",
          "import",
          " is ",
          "lam",
          "method",
          "otherwise",
          "provide",
          "provide-types",
          "rec",
          "satisfies",
          "sharing",
          "type",
          "var",
          "where",
          "with"]
      end

      name = %r{[_a-zA-Z][_a-zA-Z0-9]*(?:-+[_a-zA-Z0-9]+)*}

      state :root do
        # comments
        rule %r/#.*/, Comment::Single
        rule %r/;.*$/, Comment::Single
        rule %r/#!.*/, Comment::Single
        rule %r/#\|/, Comment::Multiline, :block_comment
        rule %r/\s+/m, Text

        rule %r{[-+]?[0-9]+(?:\\.[0-9]+)?(?:[eE][-+]?[0-9]+)?}, Num

        rule %r/"/, Str::Double, :string
        rule %r/'/, Str::Single
        rule %r/\`\`\`/, Str::Other

        rule name do |m|
          if self.class.keywords.include?(m[0])
            token Keyword
          else 
            token Name
          end
        end

        rule %r/\(|\[|\{/, Punctuation
        rule %r/\)|\]|\}/, Punctuation
        rule %r/(,|:|\||\.)/, Punctuation
        rule %r/(<<|>>|\/\/|\*\*)=?/, Operator
        rule %r/[-~+\/*%=<>&^|@]=?|!=/, Operator
      end

      state :block_comment do
        rule %r/[^|#]+/, Comment::Multiline
        rule %r/\|#/, Comment::Multiline, :pop!
        rule %r/#\|/, Comment::Multiline, :block_comment
        rule %r/[|#]/, Comment::Multiline
      end

      state :constants do
        rule %r/(?:true|false)/, Keyword::Constant
      end

      state :string do
        rule %r/[^\\"]+/, Str::Double
        rule %r/\\./, Str::Escape
        rule %r/"/, Str::Double, :pop!
      end
    end
  end
end