module Rouge
  module Lexers
    class VisualBasic < RegexLexer
      desc "Visual Basic"
      tag 'vb'
      aliases 'visualbasic'
      filenames '*.vbs'
      mimetypes 'text/x-visualbasic', 'application/x-visualbasic'

      keywords = %w(
        Select Case Function Sub Property Class Structure Enum Namespace Dim Module Private As If Then Else ElseIf End Const ExternalSource Region ExternalChecksum
      )

      builtins = %w(
        Console ConsoleColor
      )

      state :root do
        rule /\s+/m, Text # Whitespace
        rule /(?:#{keywords.join('|')})\b/, Keyword
        rule /(?:#{builtins.join('|')})\b/, Name::Builtin
        rule /[a-zA-Z][_a-zA-Z0-9]*/m, Name
        rule %r{[(){};:,\/\\\]\[]}, Punctuation

        rule %r(%\{.*?%\})m, Comment::Multiline
        rule /'.*$/, Comment::Single

        rule /&=|[*]=|\/=|\\=|\^=|\+=|-=|<<=|>>=|<<|>>|:=|<=|>=|<>|[-&*\/\\^+=<>.]/, Operator

        rule /(\d+\.\d*|\d*\.\d+)(e[+-]?[0-9]+)?/i, Num::Float
        rule /\d+e[+-]?[0-9]+/i, Num::Float
        rule /\d+L/, Num::Integer::Long
        rule /\d+/, Num::Integer

        mixin :strings
      end

      state :strings do
        rule /'.*?'/, Str::Single
        rule /".*?"/, Str::Single
      end
    end
  end
end

