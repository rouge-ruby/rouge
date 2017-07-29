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

      state :string do
        rule /"/, Str::Double, :double_quoted_string
      end

      state :interpolated_string_arg do
        mixin :expression
        rule /}/, Str::Interpol, :pop!
      end

      state :double_quoted_string do
        #rule "\\.", Str::Escape
        rule /"/, Str::Double, :pop!
        rule /\${/, Str::Interpol, :interpolated_string_arg
        rule /./, Str::Double
      end
      
      state :expression do
        mixin :number
        mixin :boolean
        mixin :string
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
