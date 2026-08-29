# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class GCode < RegexLexer
      tag 'gcode'
      aliases 'g-code', 'ngc'

      title "G-Code"
      desc 'A generic lexer for reprap/cnc g-code files'
      filenames '*.gco', '*.ngc', '*.gcode', '*.g'

      # short and sweet
      state :root do
	rule /^N[0-9][0-9]*\s*/, Comment::Special
        rule /\;.*?\n/, Comment
	rule /\*[0-9][0-9]*\s*\;?/, Comment::Doc
        rule /^M117.*\n/, Keyword::Declaration
        rule /\s\s*/, Text::Whitespace
        rule /^G[0-9.][0-9.]*/, Keyword::Namespace
        rule /^M[0-9.][0-9.]*/, Keyword::Constant
        rule /[PSRTXYZJDHQW][+-]?[0-9.]*/, Keyword::Type
        rule /E[+-]?[0-9.]*/, Name::Variable
        rule /F[+-]?[0-9.]*/, Literal::String::Char
      end
    end
  end
end
