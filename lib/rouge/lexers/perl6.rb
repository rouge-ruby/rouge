# -*- coding: utf-8 -*-

module Rouge
  module Lexers
    load_lexer 'perl.rb'

    class Perl6 < Perl
      title "Perl 6"
      desc "The Perl 6 programming language (perl6.org)"

      tag "perl6"
      aliases 'pl6'

      filenames '*.pl6', '*.pm6'
      mimetypes 'text/x-perl6', 'application/x-perl6'

      def self.detect?(text)
        return 1 if text.shebang? 'perl6'
        return 0.4 if text.include? 'use v6'
      end

      hyper_operators = %w(« » << >>)

      operator_words = %w(
        div xx x mod also leg cmp before after eq ne le lt not gt eqv
        ff fff min max not so and andthen or xor orelse extra lcm gcd o
      )

      pre_declares = %w(multi proto only)

      declares = %w(
        macro sub submethod method category module class role package
        enum grammar slang subset
      )

      rules = %w(regex rule token)

      includes = %w(use require\ unit)

      conditionals = %w(if else eslif unless with orwith without)

      scopes = %w(let my our state temp has constant)

      loops = %w(for loop repeat while until gather given)

      flow_controls = %w(
        take do when net last redo return contend maybe defer start
        default exit make continue break goto leave async lift
      )

      phasers = %w(
        BEGIN CHECK INIT START FIRST ENTER LEAVE KEEP UNDO NEXT LAST
         PRE POST END CATCH CONTROL TEMP
      )

      exceptions = %w(die fail try warn)

      pragmas = %w(oo fatal)

      type_constraints = %w(
        does as but trusts of returns handles where augment supersede
      )

      type_properties = %w(
        signature context also shape prec irs ofs ors export deep binary
        unary reparsed rw parsed cached readonly defequiv will ref copy
        inline tighter looser equiv assoc required
      )

      low_types = %w(
        int int1 int2 int4 int8 int16 int32 int64
        rat rat1 rat2 rat4 rat8 rat16 rat32 rat64
        buf buf1 buf2 buf4 buf8 buf16 buf32 buf64
        uint uint1 uint2 uint4 uint8 uint16 uint32 uint64
        utf8 utf16 utf32 bit bool bag set mix num complex
      )

      high_types = %w(
        Object Any Junctiopn Whatever Capture Match Signature Proxy
        Matcher Package Module Class Grammar Scalar Array Hasy KeyHash
        KeySet KeyBag Pair List Seq Range Set Bag Baghash Mapping Void
        Undef Failure Exception Code Block Routine Sub Macro Method
        Submethod Regex Str Blob Char Map Byte Parcel CodePoint
        Grapheme StrPos StrLen Version Num Complex Bit True False Order
        Same Less More Increasing Decreasing Ordered Callable AnyChar
        Positional Associateive Ordering KeyExtractor Comparator
        OrderingPair IO KitchenSink Role Int Bool Rat Buf UInt
        Abstraction Numeric Real Nil Mu
      )

      prepend :root do
        rule /#.*?$/, Comment::Single
        rule /^=[a-zA-Z0-9]+\s+.*?\n=cut/m, Comment::Multiline

        rule /(?:#{pre_declares.join('|')})\b/, Keyword::Declaration
        rule /(?:#{declares.join('|')})\b/, Keyword::Declaration
        rule /(?:#{rules.join('|')})\b/, Keyword::Type
        rule /(?:#{includes.join('|')})\b/, Keyword::Namespace
        rule /(?:#{conditionals.join('|')})\b/, Keyword
        rule /(?:#{scopes.join('|')})\b/, Keyword::Namespace
        rule /(?:#{loops.join('|')})\b/, Keyword
        rule /(?:#{flow_controls.join('|')})\b/, Keyword
        rule /(?:#{phasers.join('|')})\b/, Keyword::Constant
        rule /(?:#{exceptions.join('|')})\b/, Keyword
        rule /(?:#{pragmas.join('|')})\b/, Keyword
        rule /(?:#{type_constraints.join('|')})\b/, Keyword::Declaration
        rule /(?:#{type_properties.join('|')})\b/, Keyword::Declaration
        rule /(?:#{low_types.join('|')})\b/, Keyword::Type
        rule /(?:#{high_types.join('|')})\b/, Keyword::Type

        rule /(?:#{hyper_operators.join('|')})\b/, Operator
        rule /(?:#{operator_words.join('|')})\b/, Operator::Word

        rule /∞/, Keyword::Constant
        rule /\$\<|»\.|∈/, Operator
      end
    end
  end
end
