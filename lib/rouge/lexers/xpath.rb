# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class XPath < RegexLexer
      title 'XPath'
      desc 'XML Path Language (XPath) 3.1'
      tag 'xpath'
      filenames '*.xpath'

      # Terminal literals:
      # https://www.w3.org/TR/xpath-31/#terminal-symbols
      def self.digits
        @digits ||= /[0-9]+/
      end
      def self.decimalLiteral
        @decimalLiteral ||= /\.#{digits}|#{digits}\.[0-9]*/
      end
      def self.doubleLiteral
        @doubleLiteral ||= /(\.#{digits})|#{digits}(\.[0-9]*)?[eE][+-]?#{digits}/
      end
      def self.stringLiteral
        @stringLiteral ||= /("(("")|[^"])*")|('(('')|[^'])*')/
      end
      def self.ncName
        @ncName ||= /[a-z_][a-z_\-.0-9]*/i
      end
      def self.qName
        @qName ||= /(?:#{ncName})(?::#{ncName})?/
      end
      def self.uriQName
        @uriQName ||= /Q{[^{}]*}#{ncName}/
      end
      def self.eqName
        @eqName ||= /(?:#{uriQName}|#{qName})/
      end
      def self.commentStart
        @commentStart ||= /\(:/
      end
      def self.openParen
        @openParen ||= /\((?!:)/
      end

      # Terminal symbols:
      # https://www.w3.org/TR/xpath-30/#id-terminal-delimitation
      def self.kindTest
        @kindTest ||= Regexp.union %w(
          element attribute schema-element schema-attribute
          comment text node document-node namespace-node
        )
      end
      def self.kindTestForPi
        @kindTestForPi ||= Regexp.union %w(processing-instruction)
      end
      def self.axes
        @axes ||= Regexp.union %w(
          child descendant attribute self descendant-or-self
          following-sibling following namespace
          parent ancestor preceding-sibling preceding ancestor-or-self
        )
      end
      def self.operators
        @operators ||= Regexp.union %w(, => = := : >= >> > <= << < - * != + // / || |)
      end
      def self.keywords
        @keywords ||= Regexp.union %w(let for some every if then else return in satisfies)
      end
      def self.word_operators
        @word_operators ||= Regexp.union %w(
          and or eq ge gt le lt ne is
          div mod idiv
          intersect except union
          to
        )
      end
      def self.constructorTypes
        @constructorTypes ||= Regexp.union %w(function array map empty-sequence)
      end

      # Lexical states:
      # https://www.w3.org/TR/xquery-xpath-parsing/#XPath-lexical-states
      # https://lists.w3.org/Archives/Public/public-qt-comments/2004Aug/0127.html
      # https://www.w3.org/TR/xpath-30/#id-revision-log
      # https://www.w3.org/TR/xpath-31/#id-revision-log

      state :root do
        # Comments
        rule XPath.commentStart, Comment, :comment

        # Literals
        rule XPath.doubleLiteral, Num::Float
        rule XPath.decimalLiteral, Num::Float
        rule XPath.digits, Num
        rule XPath.stringLiteral, Literal::String

        # Variables
        rule /\$/, Name::Variable, :varname

        # Operators
        rule XPath.operators, Operator
        rule /\b#{XPath.word_operators}\b/, Operator::Word
        rule /\b#{XPath.keywords}\b/, Keyword
        rule /[?,{}()\[\]]/, Punctuation

        # Functions
        rule /(function)(\s*)(#{XPath.openParen})/ do # function declaration
          groups Keyword, Text, Punctuation
        end
        rule /(map|array|empty-sequence)/, Keyword # constructors
        rule /(#{XPath.kindTest})(\s*)(#{XPath.openParen})/ do  # kindtest
          push :kindtest
          groups Keyword, Text, Punctuation
        end
        rule /(#{XPath.kindTestForPi})(\s*)(#{XPath.openParen})/ do # processing instruction kindtest
          push :kindtestforpi
          groups Keyword, Text, Punctuation
        end
        rule /(#{XPath.eqName})(\s*)(#{XPath.openParen})/ do # function call
          groups Name::Function, Text, Punctuation
        end
        rule /(#{XPath.eqName})(\s*)(#)(\s*)(\d+)/ do # namedFunctionRef
          groups Name::Function, Text, Name::Function, Text, Name::Function
        end

        # Type commands
        rule /(cast|castable)(\s+)(as)/ do
          goto :singletype
          groups Keyword, Text, Keyword
        end
        rule /(treat)(\s+)(as)/ do
          goto :itemtype
          groups Keyword, Text, Keyword
        end
        rule /(instance)(\s+)(of)/ do
          goto :itemtype
          groups Keyword, Text, Keyword
        end
        rule /\b(as)\b/ do
          token Keyword
          goto :itemtype
        end

        # Paths
        rule /\.\.|\.|\*/, Operator
        rule /(#{XPath.ncName})(\s*)(:)(\s*)(\*)/ do
          groups Name::Tag, Text, Punctuation, Text, Keyword::Reserved
        end
        rule /(\*)(\s*)(:)(\s*)(#{XPath.ncName})/ do
          groups Keyword::Reserved, Text, Punctuation, Text, Name::Tag
        end
        rule /(#{XPath.axes})(\s*)(::)/ do
          groups Keyword, Text, Operator
        end
        rule /@/, Name::Attribute, :attrname
        rule XPath.eqName, Name::Tag

        # Whitespace
        rule /(\s+)/m, Text
      end

      state :singletype do
        # Whitespace and comments
        rule /\s+/m, Text
        rule XPath.commentStart, Comment, :comment

        # Type name
        rule XPath.eqName do
          token Keyword::Type
          goto :root
        end
      end

      state :itemtype do
        # Whitespace and comments
        rule /\s+/m, Text
        rule XPath.commentStart, Comment, :comment

        # Type tests
        rule /(#{XPath.kindTest})(\s*)(#{XPath.openParen})/ do
          groups Keyword::Type, Text, Punctuation
          # go to kindtest then occurrenceindicator
          goto :occurrenceindicator
          push :kindtest
        end
        rule /(#{XPath.kindTestForPi})(\s*)(#{XPath.openParen})/ do
          groups Keyword::Type, Text, Punctuation
          # go to kindtestforpi then occurrenceindicator
          goto :occurrenceindicator
          push :kindtestforpi
        end
        rule /(item)(\s*)(#{XPath.openParen})(\s*)(\))/ do
          goto :occurrenceindicator
          groups Keyword::Type, Text, Punctuation, Text, Punctuation
        end
        rule /(#{XPath.constructorTypes})(\s*)(#{XPath.openParen})/ do
          groups Keyword::Type, Text, Punctuation
        end

        # Type commands
        rule /(cast|castable)(\s+)(as)/ do
          groups Keyword, Text, Keyword
          goto :singletype
        end
        rule /(treat)(\s+)(as)/ do
          groups Keyword, Text, Keyword
          goto :itemtype
        end
        rule /(instance)(\s+)(of)/ do
          groups Keyword, Text, Keyword
          goto :itemtype
        end
        rule /\b(as)\b/, Keyword

        # Operators
        rule XPath.operators do
          token Operator
          goto :root
        end
        rule /\b#{XPath.word_operators}\b/ do
          token Operator::Word
          goto :root
        end
        rule /\b#{XPath.keywords}\b/ do
          token Keyword
          goto :root
        end
        rule /[\[),]/ do
          token Punctuation
          goto :root
        end

        # Other types (e.g. xs:double)
        rule XPath.eqName do
          token Keyword::Type
          goto :occurrenceindicator
        end
      end

      # For pseudo-parameters for the KindTest productions
      state :kindtest do
        # Whitespace and comments
        rule /\s+/m, Text
        rule XPath.commentStart, Comment, :comment

        # Pseudo-parameters:
        rule /[?*]/, Operator
        rule /,/, Punctuation
        rule /(element|schema-element)(\s*)(#{XPath.openParen})/ do
          push :kindtest
          groups Keyword::Type, Text, Punctuation
        end
        rule XPath.eqName, Name::Tag

        # End of pseudo-parameters
        rule /\)/, Punctuation, :pop!
      end

      # Similar to :kindtest, but recognizes NCNames instead of EQNames
      state :kindtestforpi do
        # Whitespace and comments
        rule /\s+/m, Text
        rule XPath.commentStart, Comment, :comment

        # Pseudo-parameters
        rule XPath.ncName, Name
        rule XPath.stringLiteral, Literal::String

        # End of pseudo-parameters
        rule /\)/, Punctuation, :pop!
      end

      state :occurrenceindicator do
        # Whitespace and comments
        rule /\s+/m, Text
        rule XPath.commentStart, Comment, :comment

        # Occurrence indicator
        rule /[?*+]/ do
          token Operator
          goto :root
        end

        # Otherwise, lex it in root state:
        rule /(?![?*+])/ do
          goto :root
        end
      end

      state :varname do
        # Whitespace and comments
        rule /\s+/m, Text
        rule XPath.commentStart, Comment, :comment

        # Function call
        rule /(#{XPath.eqName})(\s*)(#{XPath.openParen})/ do
          groups Name::Variable, Text, Punctuation
          pop!
        end

        # Variable name
        rule XPath.eqName, Name::Variable, :pop!
      end

      state :attrname do
        # Whitespace and comments
        rule /\s+/m, Text
        rule XPath.commentStart, Comment, :comment

        # Attribute name
        rule XPath.eqName, Name::Attribute, :pop!
        rule /\*/, Operator, :pop!
      end

      state :comment do
        # Comment end
        rule /:\)/, Comment, :pop!

        # Nested comment
        rule XPath.commentStart, Comment, :comment

        # Comment contents
        rule /[^:(]+/m, Comment
        rule /[:(]/, Comment
      end
    end
  end
end
