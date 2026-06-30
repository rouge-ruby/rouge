# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class P4 < RegexLexer
      tag 'p4'
      title 'P4'
      desc 'The P4 programming language'
      filenames '*.p4'
      mimetypes 'text/x-p4'

      KEYWORDS = Set.new %w(
        abstract action actions apply const default default_action else enum
        entries extern exit if in inout key list out package packet_in
        packet_out return size select switch this transition tuple type
        typedef
      )

      OPERATORS = Set.new %w(
        \|\+\| \|-\| \? \& \&\&\& < > << >> \* \| ~ \^ - \+ /
        \# \. = != <= >= \+\+
      )

      DECLS = Set.new %w(
        value_set parser Travelstate struct table
      )

      BUILTINS = Set.new %w(
        bit bool error extract int isValid setValid setInvalid match_kind
        string varbit verify void
      )

      state :whitespace do
        rule %r/\s+/m, Text
      end

      state :comment do
        rule %r((//).*$\n?), Comment::Single
        rule %r/\/\*(?:(?!\*\/).)*\*\//m, Comment::Multiline
      end

      state :number do
        rule %r/([0-9]+[sw])?0[oO][0-7_]+/, Num
        rule %r/([0-9]+[sw])?0[xX][0-9a-fA-F_]+/, Num
        rule %r/([0-9]+[sw])?0[bB][01_]+/, Num
        rule %r/([0-9]+[sw])?0[dD][0-9_]+/, Num
        rule %r/([0-9]+[sw])?[0-9_]+/, Num
      end

      id = /[\p{XID_Start}_]\p{XID_Continue}*/
      string_element  = /\\"|[^"]/x

      state :root do
        mixin :whitespace
        mixin :comment

        rule %r/#\s*#{id}/, Comment::Preproc
        rule %r/#{id}_[th]\b/x, Name::Class

        keywords id do
          rule KEYWORDS, Keyword
          rule DECLS, Keyword::Declaration
          rule BUILTINS, Name::Builtin
          rule OPERATORS, Operator
          default Name
        end
        rule %r([|][+-][|]|[?]|&|[&][&][&]|<[<=]?|>[>=]?|[-+./~^*#]|!?=|[+][+]), Operator
        rule %r/[(){}\[\]<>,:;\.]+/, Punctuation
        mixin :number
        rule %r/@#{id}/, Name::Label
        rule %r/"(?: #{string_element} )*"/x, Str::String
      end
    end
  end
end
