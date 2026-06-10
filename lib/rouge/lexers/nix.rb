# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Nix < RegexLexer
      title 'Nix'
      desc 'The Nix expression language (https://nixos.org/nix/manual/#ch-expression-language)'
      tag 'nix'
      aliases 'nixos'
      filenames '*.nix'

      ident = %r/[a-zA-Z_][a-zA-Z0-9_'-]*/

      state :whitespaces do
        rule %r/^\s*\n\s*$/m, Text
        rule %r/\s+/, Text
      end

      state :comment do
        rule %r/#.*$/, Comment
        rule %r(/\*), Comment, :multiline_comment
      end

      state :multiline_comment do
        rule %r(\*/), Comment, :pop!
        rule %r/./, Comment
      end

      state :number do
        rule %r/[0-9]+/, Num::Integer
      end

      state :path do
        word = /[a-zA-Z0-9._-]+/
        section = %r(/#{word})
        prefix = %r([a-z+]+://)
        root = /#{section}+/
        tilde = /~#{section}+/
        basic = %r(#{word}(/#{word})+)
        url = %r(#{prefix}(/?#{basic}))
        rule %r/(#{root}|#{tilde}|#{basic}|#{url})/, Str::Other
      end

      state :string do
        rule %r/"/, Str::Double, :double_quoted_string
        rule %r/''/, Str::Double, :indented_string
      end

      state :string_content do
        rule %r/\\./, Str::Escape
        rule %r/\$\$/, Str::Escape
        rule %r/\${/, Str::Interpol, :string_interpolated_arg
      end

      state :indented_string_content do
        rule %r/'''/, Str::Escape
        rule %r/''\$/, Str::Escape
        rule %r/\$\$/, Str::Escape
        rule %r/''\\./, Str::Escape
        rule %r/\${/, Str::Interpol, :string_interpolated_arg
      end

      state :string_interpolated_arg do
        mixin :expression
        rule %r/}/, Str::Interpol, :pop!
      end

      state :indented_string do
        mixin :indented_string_content
        rule %r/''/, Str::Double, :pop!
        rule %r/./, Str::Double
      end

      state :double_quoted_string do
        mixin :string_content
        rule %r/"/, Str::Double, :pop!
        rule %r/./, Str::Double
      end

      state :operator do
        rule %r/(\.|\?|\+\+|\+|!=|!|\/\/|\=\=|&&|\|\||->|\/|\*|-|<|>|<=|=>)/, Operator
      end

      state :assignment do
        rule %r/(=)/, Operator
        rule %r/(@)/, Operator
      end

      state :accessor do
        rule %r/(\$)/, Punctuation
      end

      state :delimiter do
        rule %r/(;|,|:)/, Punctuation
      end

      state :atom_content do
        mixin :expression
        rule %r/\)/, Punctuation, :pop!
      end

      state :atom do
        rule %r/\(/, Punctuation, :atom_content
      end

      state :list do
        rule %r/\[/, Punctuation, :list_content
      end

      state :list_content do
        rule %r/\]/, Punctuation, :pop!
        mixin :expression
      end

      state :set do
        rule %r/{/, Punctuation, :set_content
      end

      state :set_content do
        rule %r/}/, Punctuation, :pop!
        mixin :expression
      end

      state :expression do
        mixin :ignore
        mixin :comment
        mixin :number
        mixin :path
        mixin :string
        mixin :keywords
        mixin :operator
        mixin :accessor
        mixin :assignment
        mixin :delimiter
        mixin :atom
        mixin :set
        mixin :list
      end

      state :keywords do
        builtins = Set.new %w(
          abort
          baseNameOf
          builtins
          derivation
          fetchTarball
          import
          isNull
          removeAttrs
          throw
          toString
        )

        keywords ident do
          rule Set['with', 'in', 'inherit'], Keyword::Namespace
          rule Set['let'], Keyword::Declaration
          rule Set['null', 'true', 'false'], Keyword::Constant
          rule Set['if', 'then', 'else'], Keyword
          rule Set['rec', 'assert', 'map'], Keyword::Reserved
          rule builtins, Name::Builtin
          default Name
        end
      end

      state :ignore do
        mixin :whitespaces
      end

      state :root do
        mixin :ignore
        mixin :expression
      end
    end
  end
end
