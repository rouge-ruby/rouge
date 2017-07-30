# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Nix < RegexLexer
      title 'Nix'
      desc 'The Nix expression language (https://nixos.org/nix/manual/#ch-expression-language)'
      tag 'nix'
      aliases 'nixos'
      filenames '*.nix'

      state :whitespaces do
        rule /^\s*\n\s*$/m, Text
        rule /\s+/, Text
      end

      state :comment do
        rule /\/\/.*$/, Comment
        rule /\/\*/, Comment, :multiline_comment
      end

      state :multiline_comment do
        rule /\*\//, Comment, :pop!
        rule /./, Comment
      end

      state :number do
        rule /[0-9]/, Num::Integer
      end

      state :null do
        rule /(null)/, Keyword::Constant
      end

      state :boolean do
        rule /(true|false)/, Keyword::Constant
      end

      state :binding do
        rule /[a-zA-Z_][a-zA-Z0-9-]*/, Name::Variable
      end

      state :string do
        rule /"/, Str::Double, :string_double_quoted
        rule /''/, Str::Double, :string_indented
      end

      state :string_content do
        rule /\${/, Str::Interpol, :string_interpolated_arg
        mixin :escaped_sequence
      end

      state :escaped_sequence do
        rule /\\./, Str::Escape
      end

      state :string_interpolated_arg do
        mixin :expression
        rule /}/, Str::Interpol, :pop!
      end

      state :string_indented do
        mixin :string_content
        rule /''/, Str::Double, :pop!
        rule /./, Str::Double
      end

      state :string_double_quoted do
        mixin :string_content
        rule /"/, Str::Double, :pop!
        rule /./, Str::Double
      end

      state :operator do
        rule /(\.|\?|\+\+|\+|!=|!|\/\/|\=\=|&&|\|\||->|\/|\*|-)/, Operator
      end

      state :assignment do
        rule /(=)/, Operator
      end

      state :delimiter do
        rule /(;|,|:)/, Punctuation
      end

      state :atom_content do
        mixin :expression
        rule /\)/, Punctuation, :pop!
      end

      state :atom do
        rule /\(/, Punctuation, :atom_content
      end

      state :set do
        rule /{/, Punctuation, :set_content
      end

      state :set_content do
        rule /}/, Punctuation, :pop!
        mixin :expression
      end
      
      state :expression do
        mixin :ignore
        mixin :comment
        mixin :operator
        mixin :assignment
        mixin :delimiter
        mixin :boolean
        mixin :null
        mixin :number
        mixin :string
        mixin :binding
        mixin :atom
        mixin :set
      end

      state :ignore do
        mixin :whitespaces
      end

      state :root do
        mixin :ignore
        mixin :expression
      end

      start do
      end
    end
  end
end
