# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Ada < RegexLexer
      tag 'ada'
      filenames '*.ada', '*.ads', '*.adb', '*.adc', '*.gpr'
      mimetypes 'text/x-ada'

      title 'Ada'
      desc 'The Ada 2012 programming language'

      # Ada identifiers are Unicode with underscores only allowed as separators.
      ID = /[[:alpha:]](?:\p{Pc}?[[:alnum:]])*\b/

      # Numerals can also contain underscores.
      NUM = /\d(_?\d)*/
      XNUM = /\h(_?\h)*/
      EXP = /(E[-+]?#{NUM})?/i

      KEYWORDS = Set.new %w(
        abort abstract accept access aliased all array at begin body
        case constant declare delay delta digits do else elsif end
        exception exit for generic goto if in interface is limited
        loop new null of others out overriding parallel pragma private
        protected raise range record renames requeue return reverse
        select separate some synchronized tagged task terminate then
        until use when while with
      )

      OPERATORS = Set.new %w(abs and mod not or rem xor)

      DECLARATIONS = Set.new %w(entry function package procedure subtype type)

      BUILTINS = Set.new %w(
        boolean character constraint_error duration float integer
        natural positive long_float long_integer long_long_float
        long_long_integer program_error short_float short_integer
        short_short_integer storage_error string tasking_error
        wide_character wide_string wide_wide_character
        wide_wide_string
      )

      state :whitespace do
        rule %r{\s+}m, Text
        rule %r{--.*$}, Comment::Single
      end

      state :dquote_string do
        rule %r{[^"\n]+}, Literal::String::Double
        rule %r{""}, Literal::String::Escape
        rule %r{"}, Literal::String::Double, :pop!
        rule %r{\n}, Error, :pop!
      end

      state :attr do
        mixin :whitespace
        rule ID, Name::Attribute, :pop!
        rule %r{}, Text, :pop!
      end

      # Handle a dotted name immediately following a declaration keyword.
      state :decl_name do
        mixin :whitespace
        rule %r{body\b}i, Keyword::Declaration  # package body Foo.Bar is...
        rule %r{(#{ID})(\.)} do
          groups Name::Namespace, Punctuation
        end
        # function "<=" (Left, Right: Type) is ...
        rule %r{#{ID}|"(and|or|xor|/?=|<=?|>=?|\+|–|&\|/|mod|rem|\*?\*|abs|not)"},
             Name::Function, :pop!
        rule %r{}, Text, :pop!
      end

      # Handle a sequence of library unit names: with Ada.Foo, Ada.Bar;
      #
      # There's a chance we entered this state mistakenly since 'with'
      # has multiple other uses in Ada (none of which are likely to
      # appear at the beginning of a line). Try to bail as soon as
      # possible if we see something suspicious like keywords.
      #
      # See ada_spec.rb for some examples.
      state :libunit_name do
        mixin :whitespace

        keywords ID do
          transform(&:downcase)

          rule OPERATORS, Operator::Word, :pop!
          rule KEYWORDS, Keyword, :pop!
          rule DECLARATIONS do
            token Keyword::Declaration
            # Yikes, we're not supposed to get a keyword in a library unit name!
            # We probably entered this state by mistake, so try to fix it.
            goto :decl_name
          end

          default Name::Namespace
        end

        rule %r{[.,]}, Punctuation
        rule %r{}, Text, :pop!
      end

      state :root do
        mixin :whitespace

        # String literals.
        rule %r{'.'}, Literal::String::Char
        rule %r{"[^"\n]*}, Literal::String::Double, :dquote_string

        # Real literals.
        rule %r{#{NUM}\.#{NUM}#{EXP}}, Literal::Number::Float
        rule %r{#{NUM}##{XNUM}\.#{XNUM}##{EXP}}, Literal::Number::Float

        # Integer literals.
        rule %r{2#[01](_?[01])*##{EXP}}, Literal::Number::Bin
        rule %r{8#[0-7](_?[0-7])*##{EXP}}, Literal::Number::Oct
        rule %r{16##{XNUM}*##{EXP}}, Literal::Number::Hex
        rule %r{#{NUM}##{XNUM}##{EXP}}, Literal::Number::Integer
        rule %r{#{NUM}#\w+#}, Error
        rule %r{#{NUM}#{EXP}}, Literal::Number::Integer

        # Special constructs.
        rule %r{'}, Punctuation, :attr
        rule %r{<<#{ID}>>}, Name::Label

        # Context clauses are tricky because the 'with' keyword is used
        # for many purposes. Detect at beginning of the line only.
        rule %r{^(?:(limited)(\s+))?(?:(private)(\s+))?(with)\b}i do
          groups Keyword::Namespace, Text, Keyword::Namespace, Text, Keyword::Namespace
          push :libunit_name
        end

        # Operators and punctuation characters.
        rule %r{[+*/&<=>|]|-|=>|\.\.|\*\*|[:></]=|<<|>>|<>|@}, Operator
        rule %r{[.,:;()\[\]]}, Punctuation

        keywords ID do |m|
          transform(&:downcase)
          rule KEYWORDS, Keyword
          rule OPERATORS, Operator::Word
          rule DECLARATIONS, Keyword::Declaration, :decl_name
          rule BUILTINS, Name::Builtin
          default Name
        end

        # Flag word-like things that don't match the ID pattern.
        rule %r{\b(\p{Pc}|[[:alpha:]])\p{Word}*}, Error
      end
    end
  end
end
