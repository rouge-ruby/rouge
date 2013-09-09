module Rouge
  module Lexers
    class Matlab < RegexLexer
      desc "Matlab"
      tag 'matlab'
      aliases 'm'
      filenames '*.m'
      mimetypes 'text/x-matlab', 'application/x-matlab'

      state :root do
        rule /\s+/m, Text # Whitespace
        rule /[a-zA-Z][_a-zA-Z0-9]*/m, Text
        rule %r{[(){};:,\/\\\]\[]}, Punctuation

        rule %r(%\{.*?%\})m, Comment::Multiline
        rule /%.*$/, Comment::Single

        rule /~=|==|<<|>>|[-~+\/*%=<>&^|.]/, Operator


        rule /(\d+\.\d*|\d*\.\d+)(e[+-]?[0-9]+)?/i, Num::Float
        rule /\d+e[+-]?[0-9]+/i, Num::Float
        rule /\d+L/, Num::Integer::Long
        rule /\d+/, Num::Integer

        mixin :strings
      end

      state :strings do
        rule /'.*?'/, Str::Single
      end
    end
  end
end
