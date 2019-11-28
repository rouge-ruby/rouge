# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Cypher < RegexLexer
      tag 'cypher'
      aliases 'cypher'
      filenames '*.cypher'
      mimetypes 'application/x-cypher-query'

      title "Cypher"
      desc 'The Cypher query language (https://neo4j.com/docs/cypher-manual)'

      functions = %w(
        ABS ACOS ALLSHORTESTPATHS ASIN ATAN ATAN2 AVG CEIL COALESCE COLLECT COS COT COUNT DATE DEGREES E ENDNODE
        EXP EXTRACT FILTER FLOOR HAVERSIN HEAD ID KEYS LABELS LAST LEFT LENGTH LOG LOG10 LOWER LTRIM MAX MIN NODE NODES
        PERCENTILECONT PERCENTILEDISC PI RADIANS RAND RANGE REDUCE REL RELATIONSHIP RELATIONSHIPS REPLACE REVERSE RIGHT
        ROUND RTRIM SHORTESTPATH SIGN SIN SIZE SPLIT SQRT STARTNODE STDEV STDEVP STR SUBSTRING SUM TAIL TAN TIMESTAMP
        TOFLOAT TOINT TOINTEGER TOSTRING TRIM TYPE UPPER
      )

      pedicates = %w(
        ALL AND ANY CONTAINS EXISTS HAS IN NONE NOT OR SINGLE XOR
      )

      keywords = %w(
        AS ASC ASCENDING ASSERT BY CASE COMMIT CONSTRAINT CREATE CSV CYPHER DELETE DESC DESCENDING DETACH
        DISTINCT DROP ELSE END ENDS EXPLAIN FALSE FIELDTERMINATOR FOREACH FROM HEADERS IN INDEX IS JOIN LIMIT LOAD MATCH
        MERGE NULL ON OPTIONAL ORDER PERIODIC PROFILE REMOVE RETURN SCAN SET SKIP START STARTS THEN TRUE UNION UNIQUE
        UNWIND USING WHEN WHERE WITH CALL YIELD
      )

      state :root do
        rule %r/[^\S\n]+/, Text
        rule %r(//.*?$), Comment::Single

        rule %r([*+\-<>=&|~%^]), Operator
        rule %r/[{}),;\[\]]/, Literal::String::Symbol

        # literal number
        rule %r/([_\w\d]+)(:)(\s*)([._\d]+)/ do
          groups Name::Label, Literal::String::Delimiter, Text::Whitespace, Literal::Number
        end

        # function-like
        # - "name("
        # - "name  ("
        # - "name ("
        rule %r/([\w]+)(\s*)(\()/ do |m|
          name = m[1].upcase
          if functions.include? name
            groups Name::Function, Text::Whitespace, Literal::String::Symbol
          elsif keywords.include? name
            groups Keyword, Text::Whitespace, Literal::String::Symbol
          else
            groups Name, Text::Whitespace, Literal::String::Symbol
          end
        end

        rule %r/:[_\w\d]+/, Name::Class

        # number range
        rule %r/(-?)(\d+)(\.\.)(-?)(\d+)/ do
          groups Literal::String::Symbol, Literal::Number, Literal::String::Symbol, Literal::String::Symbol, Literal::Number
        end

        rule %r/(\d+)+/, Literal::Number

        rule %r([._\w\d]+:), Name::Property

        # remaining "("
        rule %r/\(/, Literal::String::Symbol

        rule %r/[._\w\d$]+/ do |m|
          match = m[0].upcase
          if pedicates.include? match
            token Operator::Word
          elsif keywords.include? match
            token Keyword
          else
            token Name
          end
        end

        rule %r/"(\\\\|\\"|[^"])*"/, Str
        rule %r/'(\\\\|\\'|[^'])*'/, Str
        rule %r/`(\\\\|\\`|[^`])*`/, Str

        rule %r/\n/, Text
      end
    end
  end
end