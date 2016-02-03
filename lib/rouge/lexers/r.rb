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

      KEYWORD_CONSTANTS = %w(
        NULL Inf TRUE FALSE NaN NA
        NA_integer_ NA_real_ NA_complex_ NA_character_
      )

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

        rule /%[^%]*?%/, Operator

        rule /0[xX][a-fA-F0-9]+([pP][0-9]+)?[Li]?/, Num::Hex
        rule /[+-]?(\d+([.]\d+)?|[.]\d+)([eE][+-]?\d+)?[Li]?/,
          Num

        rule /[a-zA-Z.]([a-zA-Z_][\w.]*)?/ do |m|
          if KEYWORDS.include? m[0]
            token Keyword
          elsif KEYWORD_CONSTANTS.include? m[0]
            token Keyword::Constant
          elsif BUILTIN_CONSTANTS.include? m[0]
            token Name::Builtin
          else
            token Name
          end
        end

        rule /[\[\]{}();,]/, Punctuation

        rule %r([-<>?*+^/!=~$@:%&|]), Operator
      end
    end
  end
end
