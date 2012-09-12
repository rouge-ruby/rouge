module Rouge
  module Lexers
    class TeX < RegexLexer
      tag 'tex'
      aliases 'TeX', 'LaTeX', 'latex'

      filenames '*.tex', '*.aux', '*.toc'
      mimetypes 'text/x-tex', 'text/x-latex'

      def self.analyze_text(text)
        return 1 if text =~ /\A\s*\\documentclass/
        return 1 if text =~ /\A\s*\\input/
        return 1 if text =~ /\A\s*\\documentstyle/
        return 1 if text =~ /\A\s*\\relax/
      end

      command = /\\([a-z]+|\s+|.)/i

      state :general do
        rule /%.*$/, 'Comment'
        rule /[{}&_^]/, 'Name.Builtin'
      end

      state :root do
        rule /\\\[/, 'Literal.String.Backtick', :displaymath
        rule /\\\(/, 'Literal.String', :inlinemath
        rule /\$\$/, 'Literal.String.Backtick', :displaymath
        rule /\$/, 'Literal.String', :inlinemath
        rule /\\(begin|end)\{.*?\}/, 'Name.Tag'

        rule /(\\verb)\b(.)/ do |m|
          group 'Name.Builtin'
          group 'Name.Constant'
          delim = Regexp.escape(m[2])

          push do
            rule /#{delim}/, 'Name.Constant', :pop!
            rule /[^#{delim}]+/m, 'Literal.String.Other'
          end
        end

        rule command, 'Keyword', :command
        mixin :general
        rule /[^\\$%&_^{}]+/, 'Text'
      end

      state :math do
        rule command, 'Name.Variable'
        mixin :general
        rule /[0-9]+/, 'Literal.Number'
        rule /[-=!+*\/()\[\]]/, 'Operator'
        rule /[^=!+*\/()\[\]\\$%&_^{}0-9-]+/, 'Name.Builtin'
      end

      state :inlinemath do
        rule /\\\)/, 'Literal.String', :pop!
        rule /\$/, 'Literal.String', :pop!
        mixin :math
      end

      state :displaymath do
        rule /\\\]/, 'Literal.String.Backtick', :pop!
        rule /\$\$/, 'Literal.String.Backtick', :pop!
        rule /\$/, 'Name.Builtin'
        mixin :math
      end

      state :command do
        rule /\[.*?\]/, 'Name.Attribute'
        rule /\*/, 'Keyword'
        rule(//) { pop! }
      end
    end
  end
end
