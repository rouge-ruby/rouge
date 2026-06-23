# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Lateralus < RegexLexer
      tag 'lateralus'
      aliases 'ltl'
      filenames '*.ltl'
      mimetypes 'text/x-lateralus'

      title 'Lateralus'
      desc 'The Lateralus programming language (lateralus.dev)'

      def self.keywords
        @keywords ||= %w(
          fn let mut match if else elif while for in return break continue
          import export module pub priv struct enum impl trait where type
          const static async await spawn guard defer use as self Self super
          yield do
        )
      end

      def self.builtin_types
        @builtin_types ||= %w(
          int i8 i16 i32 i64 i128
          uint u8 u16 u32 u64 u128
          float f32 f64
          bool str char bytes any never
          list map set tuple Option Result Some None Ok Err
        )
      end

      def self.builtins
        @builtins ||= %w(
          print println eprint eprintln format panic assert assert_eq
          todo unimplemented unreachable
          len range map filter reduce fold zip enumerate
          sort sorted reverse sum min max
        )
      end

      def self.constants
        @constants ||= %w(true false null)
      end

      id      = /[A-Za-z_][A-Za-z0-9_]*/
      type_id = /[A-Z][A-Za-z0-9_]*/
      hex     = /[0-9a-fA-F]/
      int_suf = /(?:_?[iu](?:8|16|32|64|128))?/
      flt_suf = /(?:_?f(?:32|64))?/

      state :whitespace do
        rule %r/\s+/, Text
        rule %r(///[^\n]*), Comment::Special
        rule %r(//[^\n]*), Comment::Single
        rule %r(/\*), Comment::Multiline, :block_comment
      end

      state :block_comment do
        rule %r([^*/]+), Comment::Multiline
        rule %r(/\*), Comment::Multiline, :block_comment
        rule %r(\*/), Comment::Multiline, :pop!
        rule %r([/*]), Comment::Multiline
      end

      state :strings do
        # raw strings: r"...", r#"..."#, r##"..."##, ...
        rule %r/r(#*)"(?:\\.|(?!\1").)*"\1/m, Str
        # byte strings
        rule %r/b"/, Str, :string
        # regular / interpolated strings
        rule %r/"/, Str, :string
        # char literals
        rule %r/'(?:\\(?:[nrt'"\\0]|x#{hex}{2}|u\{#{hex}{1,6}\})|[^'\\])'/, Str::Char
      end

      state :string do
        rule %r/"/, Str, :pop!
        rule %r/\\(?:[nrt'"\\0]|x#{hex}{2}|u\{#{hex}{1,6}\})/, Str::Escape
        rule %r/\{[^}]*\}/, Str::Interpol
        rule %r/[^"\\{}]+/, Str
        rule %r/[\\{}]/, Str
      end

      state :attribute do
        rule %r/[^\[\]]+/, Name::Decorator
        rule %r/\[/, Name::Decorator, :attribute
        rule %r/\]/, Name::Decorator, :pop!
      end

      state :root do
        mixin :whitespace
        mixin :strings

        # Attribute decorators: @memo, @doc("..."), @foreign("c")
        rule %r/@#{id}/, Name::Decorator
        # Capability annotations: #[caps(io, net)]
        rule %r/\#\[/, Name::Decorator, :attribute

        # Numeric literals
        rule %r/[0-9][0-9_]*\.[0-9][0-9_]*(?:[eE][-+]?[0-9][0-9_]*)?#{flt_suf}/,
          Num::Float
        rule %r/0x#{hex}[#{hex}_]*#{int_suf}/, Num::Hex
        rule %r/0o[0-7][0-7_]*#{int_suf}/, Num::Oct
        rule %r/0b[01][01_]*#{int_suf}/, Num::Bin
        rule %r/[0-9][0-9_]*#{int_suf}/, Num::Integer

        # Pipeline operator (Lateralus's signature feature)
        rule %r/\|>/, Operator

        # Function / type / struct / enum / trait / impl definitions
        rule %r/(fn)(\s+)(#{id})/ do
          groups Keyword, Text, Name::Function
        end
        rule %r/(struct|enum|trait|type|impl)(\s+)(#{type_id})/ do
          groups Keyword, Text, Name::Class
        end

        # Module path segment: `foo::`
        rule %r/(#{id})(::)/ do
          groups Name::Namespace, Punctuation
        end

        # Identifiers with semantic lookup
        rule id do |m|
          name = m[0]
          if self.class.keywords.include?(name)
            token Keyword
          elsif self.class.builtin_types.include?(name)
            token Keyword::Type
          elsif self.class.constants.include?(name)
            token Keyword::Constant
          elsif self.class.builtins.include?(name)
            token Name::Builtin
          elsif name =~ /\A[A-Z]/
            token Name::Class
          else
            token Name
          end
        end

        # Operators
        rule %r/==|!=|<=|>=|->|=>|&&|\|\||<<|>>|::|\.\.=?|\?\?|[+\-*\/%<>!=&|^~?]/,
          Operator

        # Punctuation
        rule %r/[{}()\[\];,.:]/, Punctuation
      end
    end
  end
end
