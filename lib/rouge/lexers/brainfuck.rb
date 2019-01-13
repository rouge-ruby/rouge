# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Brainfuck < RegexLexer
      tag 'brainfuck'
      filenames '*.b', '*.bf'
      mimetypes 'text/x-brainfuck'

      title "Brainfuck"
      desc "The Brainfuck programming language"

      state :root do
        # Single line comments (everything that's not a keyword)
        rule /([^\[\]><\+\-\.,])+?/, Comment::Single
        
        # The starting loop-comment (it can be positioned anywhere)
        rule /\[[^\[\]><\+\-\.,]*?\]/, Comment::Multiline
      
        # All keywords
        rule /(>|<|\.|,|\[|\])/, Keyword
        
        # Plus (+) and minus (-) operators
        rule /(\+|\-)/, Operator
      end
    end
  end
end
