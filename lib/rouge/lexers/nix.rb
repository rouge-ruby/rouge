# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Nix < RegexLexer
      title 'Nix'
      desc 'The Nix expression language (https://nixos.org/nix/manual/#ch-expression-language)'
      tag 'nix'
      aliases 'nixos'
      filenames '*.nix'

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

      state :boolean do
        rule /(true|false)/, Keyword::Pseudo
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
      
      state :expression do
        mixin :number
        mixin :boolean
        mixin :string
        mixin :binding
      end

      state :root do
        mixin :comment
        mixin :expression
      end

      start do
      end
    end
  end
end
