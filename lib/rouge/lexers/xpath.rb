# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class XPath < RegexLexer
      title 'XPath'
      desc 'XPath 3.0'
      tag 'xpath'
      filenames '*.xpath'

      # Terminal literals:
      # https://www.w3.org/TR/xpath-31/#terminal-symbols

      digits = /[0-9]+/
      decimalLiteral = /\.#{digits}|#{digits}\.[0-9]*/
      doubleLiteral = /(\.#{digits})|#{digits}(\.[0-9]*)?[eE][+-]?#{digits}/
      stringLiteral = /("(("")|[^"])*")|('(('')|[^'])*')/

      ncName = /[a-z_][a-z_\-.0-9]*/i
      qName = /(?:#{ncName})(?::#{ncName})?/
      uriQName = /Q{[^{}]*}#{ncName}/
      eqName = /(?:#{qName}|#{uriQName})/

      commentStart = /\(:/
      openParens   = /\((?!:)/

      # Terminal symbols:
      # https://www.w3.org/TR/xpath-30/#id-terminal-delimitation
      kindTest = Regexp.union(%w(
        element attribute schema-element schema-attribute
        comment text node document-node namespace-node
      ))
      kindTestForPi = Regexp.union(%w(processing-instruction))
      axes = Regexp.union(%w(
        child descendant attribute self descendant-or-self
        following-sibling following namespace
        parent ancestor preceding-sibling preceding ancestor-or-self
      ))
      operators = Regexp.union(%w(, => = := : >= >> > <= << < - * != + // / || |))
      keyword_operators = Regexp.union(%w(then else return in satisfies))
      word_operators = Regexp.union(%w(
        and or eq ge gt le lt ne is
        div mod idiv
        intersect except union
        to
      ))
      constructorTypes = Regexp.union(%w(function array map empty-sequence))

      # Lexical states:
      # https://www.w3.org/TR/xquery-xpath-parsing/#XPath-lexical-states
      # https://lists.w3.org/Archives/Public/public-qt-comments/2004Aug/0127.html
      # https://www.w3.org/TR/xpath-30/#id-revision-log
      # https://www.w3.org/TR/xpath-31/#id-revision-log

      state :root do
        # Comments
        rule commentStart, Comment, :comment

        # Literals
        rule doubleLiteral, Num::Float, :operator
        rule decimalLiteral, Num::Float, :operator
        rule digits, Num, :operator
        rule stringLiteral, Literal::String, :operator

        # Variables
        rule /\$/, Name::Variable, :varname

        # Keywords
        rule /(for|some|every|let)/, Keyword

        # Functions
        rule /(function|empty-sequence)(\s*)(#{openParens})/ do
          groups Keyword, Text, Punctuation, :operator
        end
        rule /(map|array)(\s*)(\{)/ do
          groups Keyword, Text, Punctuation
        end
        rule /(#{kindTest})(\s*)(#{openParens})/ do
          push :operator
          groups Keyword, Text, Punctuation, :kindtest
        end
        rule /(#{kindTestForPi})(\s*)(#{openParens})/ do
          push :operator
          groups Keyword, Text, Punctuation, :kindtestforpi
        end
        rule /(if)(\s*)(#{openParens})/ do
          groups Keyword, Text, Punctuation
        end
        rule /(#{eqName})(\s*)(#{openParens})/ do
          groups Name::Function, Text, Punctuation
        end
        rule /(#{eqName})(\s*)(#)(\s*)(#{digits})(\s*)(#{openParens})/ do # namedFunctionRef
          groups Name::Function, Text, Name::Function, Text, Name::Function, Text, Punctuation
        end
        rule /\)/, Punctuation, :operator
        rule /[?,(\[]/, Punctuation

        # Paths
        rule /\.\.|\.|\*/, Operator, :operator
        rule /(#{ncName})(\s*)(:)(\s*)(\*)/ do
          groups Name::Tag, Text, Punctuation, Text, Keyword::Reserved, :operator
        end
        rule /(\*)(\s*)(:)(\s*)(#{ncName})/ do
          groups Keyword::Reserved, Text, Punctuation, Text, Name::Tag, :operator
        end
        rule /(#{axes})(\s*)(::)/ do
          groups Keyword, Text, Operator
        end
        rule /@/, Name::Attribute, :attrname
        rule eqName, Name::Tag, :operator

        # Path separators
        rule %r((-|\+|/|//)), Operator

        # Whitespace
        rule /\s+/m, Text
      end

      state :operator do
        # Comments
        rule commentStart, Comment, :comment

        # Operators
        rule operators, Operator, :root
        rule /\s+#{word_operators}(\s+|$)/, Operator::Word, :root
        rule /\s+#{keyword_operators}(\s+|$)/, Operator::Word, :root
        rule /[\[({]/, Punctuation, :root

        # Type commands
        rule /(cast|castable)(\s+)(as)/ do
          push :singletype
          groups Keyword, Text, Keyword
        end
        rule /(treat)(\s+)(as)/ do
          push :itemtype
          groups Keyword, Text, Keyword
        end
        rule /(instance)(\s+)(of)/ do
          push :itemtype
          groups Keyword, Text, Keyword
        end
        rule /as/, Keyword, :itemtype

        # Variables
        rule /\$/, Name::Variable, :varname
        rule /[)?\]}]/, Punctuation

        # Literals
        rule stringLiteral, Literal::String

        # Whitespace
        rule /(\s+)/m, Text
      end

      state :singletype do
        # Whitespace and comments
        rule /\s+/m, Text
        rule commentStart, Comment, :comment

        # Type name
        rule eqName, Keyword::Type, :operator
      end

      state :itemtype do
        # Whitespace and comments
        rule /\s+/m, Text
        rule commentStart, Comment, :comment

        # Type tests
        rule /(#{kindTest})(\s*)(#{openParens})/ do
          push :occurrenceindicator
          groups Keyword, Text, Punctuation, :kindtest
        end
        rule /(#{kindTestForPi})(\s*)(#{openParens})/ do
          push :occurrenceindicator
          groups Keyword, Text, Punctuation, :kindtestforpi
        end
        rule /(item)(\s*)(#{openParens})(\s*)(\))/ do
          groups Keyword::Type, Text, Punctuation, Text, Punctuation, :occurrenceindicator
        end
        rule /(#{constructorTypes})(\s*)(#{openParens})/ do
          groups Keyword::Type, Text, Punctuation
        end

        # Type commands
        rule /(cast|castable)(\s+)(as)/ do
          push :singletype
          groups Keyword, Text, Keyword
        end
        rule /(treat)(\s+)(as)/ do
          groups Keyword, Text, Keyword, :itemtype
        end
        rule /(instance)(\s+)(of)/ do
          groups Keyword, Text, Keyword, :itemtype
        end
        rule /as/, Keyword

        # Operators
        rule operators, Operator, :root
        rule word_operators, Operator::Word, :root
        rule keyword_operators, Keyword, :root
        rule /[\[),]/, Punctuation, :root

        # Other types (e.g. xs:double)
        rule eqName, Keyword::Type, :occurrenceindicator
      end


      # For pseudo-parameters for the KindTest productions
      state :kindtest do
        # Whitespace and comments
        rule /\s+/m, Text
        rule commentStart, Comment, :comment

        # Pseudo-parameters:
        rule /\*/, Keyword, :closekindtest
        rule eqName, Name, :closekindtest
        rule /(element|schema-element)(\s*)(#{openParens})/ do
          group Keyword, Text, Punctuation, :kindtest
        end

        # End of pseudo-parameters
        rule /\)/, Punctuation, :pop!
      end

      # Similar to :kindtest, but recognizes NCNames instead of EQNames
      state :kindtestforpi do
        # Whitespace and comments
        rule /\s+/m, Text
        rule commentStart, Comment, :comment

        # Pseudo-parameters
        rule ncName, Name
        rule stringLiteral, Literal::String

        # End of pseudo-parameters
        rule /\)/, Punctuation, :pop!
      end

      state :closekindtest do
        # Whitespace and comments
        rule /\s+/m, Text
        rule commentStart, Comment, :comment

        # Closing or continuing a kindtest
        rule /\)/, Punctuation, :pop!
        rule /,/, Punctuation, :kindtest
        rule /\?/, Punctuation
      end

      state :occurrenceindicator do
        # Whitespace and comments
        rule /\s+/m, Text
        rule commentStart, Comment, :comment

        # Occurrence indicator
        rule /[?*+]/, Operator, :operator

        # Otherwise, lex it in operator state:
        rule /(?![?*+])/ do
          push :operator
        end
      end

      state :varname do
        # Whitespace and comments
        rule /\s+/m, Text
        rule commentStart, Comment, :comment

        # Function call
        rule /(#{eqName})(\s*)(#{openParens})/ do
          push :root
          groups Name::Variable, Text, Punctuation
        end

        # Variable name
        rule eqName, Name::Variable, :operator
      end

      state :attrname do
        # Whitespace and comments
        rule /\s+/m, Text
        rule commentStart, Comment, :comment

        # Attribute name
        rule eqName, Name::Attribute, :operator
      end

      state :comment do
        # Comment end
        rule /:\)/, Comment, :pop!

        # Nested comment
        rule commentStart, Comment, :comment

        # Comment contents
        rule /[^:(]+/m, Comment
        rule /[:(]/, Comment
      end
    end
  end
end
