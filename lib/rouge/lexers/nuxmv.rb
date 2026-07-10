# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class NuXmv < RegexLexer
      title "nuXmv"
      desc "A superset of NuSMV, a symbolic model checker (https://nuxmv.fbk.eu/), and the old CMU SMV."
      tag 'nuxmv'
      aliases 'nuxmv', 'nusmv', 'smv'
      filenames '*.smv'
      mimetypes 'text/x-nuxmv', 'text/x-nusmv'

      def self.keywords
        @keywords ||= %w(
          @F~ @O~ A ABF ABG AF AG ASSIGN at next last
          AX BU case Clock COMPASSION COMPID COMPUTE COMPWFF
          CONSTANTS CONSTARRAYCONSTRAINT CTLSPEC CTLWFF DEFINE E EBF
          EBG EF EG esac EX F FAIRNESS FALSE FROZENVAR FUN G H
          IN in INIT init Integer integer INVAR INVARSPEC ISA ITYPE IVAR JUSTICE
          LTLSPEC LTLWFF MAX MDEFINE MIN MIRROR MODULE NAME next
          NEXTWFF noncontinuous O of PRED PREDICATES pi PSLSPEC PARSYNTH READ Real
          S SAT self SIMPWFF sizeof SPEC T
          time since until TRANS TRUE typeof U union URGENT
          V VALID VAR Word word1 WRITE X X~ Y Y~ Z
        )
      end

      def self.keywords_type
        @keywords_type ||= Set.new %w(
          integer signed unsigned word real clock array boolean set
        )
      end

      def self.keywords_builtin_fns
        @keywords_builtin_fns ||= Set.new %w(
          abs max min sin cos exp tan ln pow asin acos atan sqrt word1
          bool toint count swconst uwconst extend resize READ WRITE CONSTARRAY
          ceil floor
        )
      end

      acceptable_word = /[a-zA-Z_][a-zA-Z0-9_]*/

      state :inline_whitespace do
        rule %r/[ \t\r]+/, Text
      end

      state :beginline do
        mixin :inline_whitespace

        rule(//) { pop! }
      end

      state :whitespace do
        rule %r/\n+/m, Text, :beginline
        rule %r(--.*?$), Comment::Single, :beginline
        mixin :inline_whitespace
      end

      state :expr_whitespace do
        rule %r/\n+/m, Text, :beginline
        mixin :whitespace
      end

      state :statement do
        mixin :whitespace

        # Reals, supporting also exponential notation
        # Omitting the leading 0 is not allowed (.3 is not valid syntax)
        # Positive exponent has implicit sign, explicit is not allowed
        # In addition, the fractional syntax is allowed: F'123/456 or f'123/456
        rule %r/([0-9_]+\.[0-9_]+)(e-?[0-9_]+)?/i, Num::Float
        rule %r/[0-9_]+e[+-]?[0-9_]+/i, Num::Float
        rule %r/[Ff]'([0-9_]+)(\/[0-9_]+)?/i, Num::Float

        rule %r/[0-9]+/, Num::Integer
        rule %r/[0-9_]+[lu]*/i, Num::Integer
        rule %r((!|&|\||->|<->|=|<|>|<=|>=|\+|-|\*|/|mod|:=|:|xor|xnor)), Operator
        rule %r/[{}()\[\],.$\#;]/, Punctuation

        rule acceptable_word do |m|
          name = m[0]

          if self.class.keywords.include? name
            token Keyword
          elsif self.class.keywords_type.include? name
            token Keyword::Type
          elsif self.class.keywords_builtin_fns.include? name
            token Name::Builtin
          else
            token Name
          end
        end
      end

      state :root do
        mixin :expr_whitespace
        rule(//) { push :statement }
      end

    end
  end
end
