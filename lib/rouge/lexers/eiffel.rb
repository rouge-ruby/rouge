# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Eiffel < RegexLexer
      title "Eiffel"
      desc "Eiffel programming language"

      tag 'eiffel'
      filenames '*.e'
      mimetypes 'text/x-eiffel'

      KEYWORDS = Set.new %w(
        across agent alias all and attached as assign attribute check
        class convert create debug deferred detachable do else elseif end
        ensure expanded export external feature from frozen if implies  inherit
        inspect invariant like local loop not note obsolete old once or
        Precursor redefine rename require rescue retry select separate
        some then undefine until variant Void when xor
      )

      STRING_RE = /(?:[^"%\b\f\v]|%[A-DFHLNQR-V%'"()<>]|%\/(?:0[xX][\da-fA-F](?:_*[\da-fA-F])*|0[cC][0-7](?:_*[0-7])*|0[bB][01](?:_*[01])*|\d(?:_*\d)*)\/)+?/

      state :root do
        rule %r/\s+/, Text

        rule %r/"\[/, Str::Other, :aligned_verbatim_string
        rule %r/"\{/, Str::Other, :non_aligned_verbatim_string
        rule %r/"(?:[^%\b\f\n\r\v]|%[A-DFHLNQR-V%'"()<>]|%\/(?:0[xX][\da-fA-F](?:_*[\da-fA-F])*|0[cC][0-7](?:_*[0-7])*|0[bB][01](?:_*[01])*|\d(?:_*\d)*)\/)*?"/, Str::Double
        rule %r/--.*/, Comment::Single
        rule %r/'(?:[^%\b\f\n\r\t\v]|%[A-DFHLNQR-V%'"()<>]|%\/(?:0[xX][\da-fA-F](?:_*[\da-fA-F])*|0[cC][0-7](?:_*[0-7])*|0[bB][01](?:_*[01])*|\d(?:_*\d)*)\/)'/, Str::Char

        keywords %r/[a-z]\w*/i do
          rule KEYWORDS, Keyword
          rule Set['Current', 'Result'], Keyword::Variable
          rule Set['True', 'False'], Keyword::Constant

          default do |m|
            if ('A'..'Z').cover?(m[0][0])
              token Name::Class
            else
              token Name
            end
          end
        end

        rule %r/\b0[xX][\da-fA-F](?:_*[\da-fA-F])*b/, Num::Hex
        rule %r/\b0[cC][0-7](?:_*[0-7])*\b/, Num::Oct
        rule %r/\b0[bB][01](?:_*[01])*\b/, Num::Bin
        rule %r/\d(?:_*\d)*/, Num::Integer
        rule %r/(?:\d(?:_*\d)*)?\.(?:(?:\d(?:_*\d)*)?[eE][+-]?)?\d(?:_*\d)*|\d(?:_*\d)*\.?/, Num::Float

        rule %r/:=|<<|>>|\(\||\|\)|->|\.|[{}\[\];(),:?]/, Punctuation::Indicator
        rule %r/\\\\|\|\.\.\||\.\.|\/[~\/]?|[><\/]=?|[-+*^=~≤≥−∀∃¦⟳⟲]/, Operator
      end

      state :aligned_verbatim_string do
        rule %r/]"/, Str::Other, :pop!
        rule STRING_RE, Str::Other
      end

      state :non_aligned_verbatim_string do
        rule %r/}"/, Str::Other, :pop!
        rule STRING_RE, Str::Other
      end
    end
  end
end
