# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class SPARQL < RegexLexer
      title "SPARQL"
      desc "Semantic Query Language, for RDF data"
      tag 'sparql'
      filenames '*.rq'
      mimetypes 'application/sparql-query'

      BUILTINS = Set.new %w[
        ABS AVG BNODE BOUND CEIL COALESCE CONCAT CONTAINS COUNT DATATYPE DAY
        ENCODE_FOR_URI FLOOR GROUP_CONCAT HOURS IF IRI isBLANK isIRI isLITERAL
        isNUMERIC isURI LANG LANGMATCHES LCASE MAX MD5 MIN MINUTES MONTH NOW
        RAND REGEXP REPLACE ROUND sameTerm SAMPLE SECONDS SEPARATOR SHA1
        SHA256 SHA384 SHA512 STR STRAFTER STRBEFORE STRDT STRENDS STRLANG
        STRLEN STRSTARTS STRUUID SUBSTR SUM TIMEZONE TZ UCASE URI UUID YEAR
      ]

      KEYWORDS = Set.new %w[
        ADD ALL AS ASC BIND CLEAR COPY CREATE DATA DEFAULT DELETE DESC
        DISTINCT DROP EXISTS FILTER GRAPH GROUP\ BY HAVING IN INSERT LIMIT
        LOAD MINUS MOVE NAMED NOT\ EXISTS NOT\ IN OFFSET OPTIONAL ORDER\ BY
        SELECT SERVICE SILENT UNDEF UNION USING VALUES WHERE WITH
      ]

      state :root do
        rule %r("), Str, :string_double
        rule %r('), Str, :string_single
        rule %r(#.*), Comment::Single
        rule %r([$?]\w+), Name::Variable
        rule %r((\w*:)(\w+)) do |m|
          token Name::Namespace, m[1]
          token Str::Symbol, m[2]
        end
        rule %r(<[^>]*>), Name::Namespace
        rule Regexp.union(KEYWORDS.map{ |str| /\b#{str}\b/i }), Keyword
        rule Regexp.union(BUILTINS.map{ |str| /\b#{str}\b/i }), Name::Builtin
        rule %r(-?([0-9]+\.[0-9]+|\.[0-9]+|[0-9]+)([eE][+-]?[0-9]+)?), Num
        rule %r([\]\[(){}.,;=]), Punctuation
        rule %r([/?*+=!<>]|&&|\|\|), Operator
        rule %r(\s+), Text::Whitespace
      end

      state :string_double do
        rule %r(\\[tbnrf"'\\]), Str::Escape
        rule %r("), Str, :pop!
        rule %r(.), Str
      end

      state :string_single do
        rule %r(\\[tbnrf"'\\]), Str::Escape
        rule %r('), Str, :pop!
        rule %r(.), Str
      end
    end
  end
end
