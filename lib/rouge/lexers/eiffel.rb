# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Eiffel < RegexLexer
      title "Eiffel"
      desc "Eiffel programming language"

      tag 'eiffel'
      filenames '*.e'
      mimetypes 'text/x-eiffel'

      Language_keywords = %w(
        across agent alias all and attached as assign attribute check 
        class convert create debug deferred detachable do else elseif end
        ensure expanded export external feature from frozen if implies  inherit
        inspect invariant like local loop not note obsolete old once or
        Precursor redefine rename require rescue retry select separate
        some then undefine until variant Void when xor
      )

      Boolean_constants = %w(True False)

      Language_variables = %w(Current Result)

      Simple_string = /(?:[^"%\b\f\v]|%[A-DFHLNQR-V%'"()<>]|%\/(?:0[xX][\da-fA-F](?:_*[\da-fA-F])*|0[cC][0-7](?:_*[0-7])*|0[bB][01](?:_*[01])*|\d(?:_*\d)*)\/)+?/

      state :root do
        rule /"\[/, Str::Other, :aligned_verbatim_string 
        rule /"\{/, Str::Other, :non_aligned_verbatim_string
        rule /"(?:[^%\b\f\n\r\v]|%[A-DFHLNQR-V%'"()<>]|%\/(?:0[xX][\da-fA-F](?:_*[\da-fA-F])*|0[cC][0-7](?:_*[0-7])*|0[bB][01](?:_*[01])*|\d(?:_*\d)*)\/)*?"/, Str::Double
        rule /--.*/, Comment::Single
        rule /'(?:[^%\b\f\n\r\t\v]|%[A-DFHLNQR-V%'"()<>]|%\/(?:0[xX][\da-fA-F](?:_*[\da-fA-F])*|0[cC][0-7](?:_*[0-7])*|0[bB][01](?:_*[01])*|\d(?:_*\d)*)\/)'/, Str::Char
        
        rule /(?:#{Language_keywords.join('|')})\b/, Keyword
        rule /(?:#{Language_variables.join('|')})\b/, Keyword::Variable
        rule /(?:#{Boolean_constants.join('|')})\b/, Keyword::Constant

        rule  /\b0[xX][\da-fA-F](?:_*[\da-fA-F])*b/, Num::Hex
        rule /\b0[cC][0-7](?:_*[0-7])*\b/, Num::Oct
        rule /\b0[bB][01](?:_*[01])*\b/, Num::Bin
        rule /\d(?:_*\d)*/, Num::Integer
        rule /(?:\d(?:_*\d)*)?\.(?:(?:\d(?:_*\d)*)?[eE][+-]?)?\d(?:_*\d)*|\d(?:_*\d)*\.?/, Num::Float
        
        rule /:=|<<|>>|\(\||\|\)|->|\.|[{}\[\];(),:?]/, Punctuation::Indicator
        rule /\\\\|\|\.\.\||\.\.|\/[~\/]?|[><\/]=?|[-+*^=~]/, Operator

        rule /[A-Z][\dA-Z_]*/, Name::Class
        rule /[A-Za-z][\dA-Za-z_]*/, Name
        rule /\s+/, Text        
      end

      state :aligned_verbatim_string do
        rule /]"/, Str::Other, :pop!
        rule Simple_string, Str::Other
      end

      state :non_aligned_verbatim_string do
        rule /}"/, Str::Other, :pop!
        rule Simple_string, Str::Other
      end
    end
  end
end

