# -*- coding: utf-8 -*- #
# frozen_string_literal: true

# Based on Chroma's MiniZinc lexer:
# https://github.com/alecthomas/chroma/blob/5152194c717b394686d3d7a7e1946a360ec0728f/lexers/m/minizinc.go

module Rouge
  module Lexers
    class MiniZinc < RegexLexer
      title "MiniZinc"
      desc "MiniZinc is a free and open-source constraint modeling language (minizinc.org)"
      tag 'minizinc'
      filenames '*.mzn', '*.fzn', '*.dzn'
      mimetypes 'text/minizinc'

      BUILTINS = Set.new %w[
        abort abs acosh array_intersect array_union array1d array2d array3d
        array4d array5d array6d asin assert atan bool2int card ceil concat
        cos cosh dom dom_array dom_size fix exp floor index_set
        index_set_1of2 index_set_2of2 index_set_1of3 index_set_2of3
        index_set_3of3 int2float is_fixed join lb lb_array length ln log log2
        log10 min max pow product round set2array show show_int show_float
        sin sinh sqrt sum tan tanh trace ub ub_array
      ]

      KEYWORDS = Set.new %w[
        ann annotation any constraint else endif function for forall if
        include list of op output minimize maximize par predicate record
        satisfy solve test then type var where
      ]

      KEYWORDS_TYPE = Set.new %w(
        array set bool enum float int string tuple
      )

      OPERATORS = Set.new %w(
        in subset superset union diff symdiff intersect
      )

      id = /[$a-zA-Z_]\w*/

      state :root do
        rule %r(\s+)m, Text::Whitespace
        rule %r(\\\n)m, Text::Whitespace
        rule %r(%.*), Comment::Single
        rule %r(/(\\\n)?[*](.|\n)*?[*](\\\n)?/)m, Comment::Multiline
        rule %r/"(\\\\|\\"|[^"])*"/, Literal::String

        rule %r(not|<->|->|<-|\\/|xor|/\\), Operator
        rule %r(<|>|<=|>=|==|=|!=), Operator
        rule %r(\+|-|\*|/|div|mod), Operator
        rule %r(\\|\.\.|\+\+), Operator
        rule %r([|()\[\]{},:;]), Punctuation
        rule %r((true|false)\b), Keyword::Constant
        rule %r(([+-]?)\d+(\.(?!\.)\d*)?([eE][-+]?\d+)?), Literal::Number

        keywords id do
          rule KEYWORDS, Keyword
          rule KEYWORDS_TYPE, Keyword::Type
          rule BUILTINS, Name::Builtin
          rule OPERATORS, Operator
          default Name
        end

        rule %r(::\s*([^\W\d]\w*)(\s*\([^\)]*\))?), Name::Decorator
        rule %r(\b([^\W\d]\w*)\b(\()) do
          groups Name::Function, Punctuation
        end
        rule %r([^\W\d]\w*), Name::Other
      end
    end
  end
end
