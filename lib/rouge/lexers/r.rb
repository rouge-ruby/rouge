# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class R < RegexLexer
      title "R"
      desc 'The R statistics language (r-project.org)'
      tag 'r'
      aliases 'r', 'R', 's', 'S'
      filenames '*.R', '*.r', '.Rhistory', '.Rprofile'
      mimetypes 'text/x-r-source', 'text/x-r', 'text/x-R'

      mimetypes 'text/x-r', 'application/x-r'

      KEYWORDS = %w(if else for while repeat in next break switch function)

      BUILTIN_CONSTANTS = %w(LETTERS letters month.abb month.name pi T F)

      def self.analyze_text(text)
        return 1 if text.shebang? 'Rscript'
      end

      state :root do
        rule /#'.*?\n/, Comment::Doc
        rule /#.*?\n/, Comment::Single
        rule /\s+/m, Text::Whitespace

        rule /`[^`]+?`/, Name
        rule /'(\\.|.)*?'/m, Str::Single
        rule /"(\\.|.)*?"/m, Str::Double

        rule /\b(NULL|Inf|TRUE|FALSE|NaN)(?!\.)\b/, Keyword::Constant
        rule /\bNA(_(integer|real|complex|character)_)?\b/,
          Keyword::Constant

        rule /%[^%]*?%/, Operator

        rule /[a-zA-Z.]([a-zA-Z_][\w.]*)?/ do |m|
          if KEYWORDS.include? m[0]
            token Keyword
          elsif BUILTIN_CONSTANTS.include? m[0]
            token Name::Constant
          else
            token Name
          end
        end

        rule /0[xX][a-fA-F0-9]+([pP][0-9]+)?[Li]?/, Num::Hex
        rule /[+-]?(\d+([.]\d+)?|[.]\d+)([eE][+-]?\d+)?[Li]?/,
          Num

        rule /[\[\]{}();,]/, Punctuation

        rule %r([-<>?*+^/!=~$@:%&|]), Operator
      end
    end
  end
end
