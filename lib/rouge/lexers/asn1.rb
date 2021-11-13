# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Asn1 < RegexLexer
      title 'Asn.1'
      desc "Abstract Syntax Notation One"
      tag 'asn1'
      filenames '*.asn', '*.asn1'
      mimetypes 'text/x-ttcn-asn'

      def self.keywords_type
        @keywords_type ||= Set.new [
          'BOOLEAN', 'INTEGER', 'ENUMERATED', 'REAL',
          'BIT STRING', 'OCTET STRING', 'NULL',
          'SEQUENCE OF', 'SEQUENCE', 'SET OF', 'SET',
          'CHOICE', 'OBJECT IDENTIFIER',
          'RELATIVE-OID', 'OID-IRI', 'RELATIVE-OID-IRI', 'EMBEDDED PDV',
          'EXTERNAL',

          # Restricted character string types (X.680 02/2021 chapter 41)
          'BMPString', 'GeneralString', 'GraphicString', 'IA5String', 'ISO646String',
          'NumericString', 'PrintableString', 'TeletexString', 'T61String', 'UniversalString',
          'UTF8String', 'VideotexString', 'VisibleString',

          # (deprecated) any type (X.208 chapter 27; deprecated in X.680)
          'ANY DEFINED BY', 'ANY',
        ]
      end

      def self.multiple_word_keywords_type
        @multiple_word_type ||= self.keywords_type.select { |v| v.include? ' ' }
      end

      def self.reserved
        # Reserved words (X.680 02/2021 clause 12.38)
        @reserved ||= Set.new %w(
          ABSENT ENCODED INTERSECTION SEQUENCE
          ABSTRACT-SYNTAX ENCODING-CONTROL ISO646String SET
          ALL END MAX SETTINGS
          APPLICATION ENUMERATED MIN SIZE
          AUTOMATIC EXCEPT MINUS-INFINITY STRING
          BEGIN EXPLICIT NOT-A-NUMBER SYNTAX
          BIT EXPORTS NULL T61String
          BMPString EXTENSIBILITY NumericString TAGS
          BOOLEAN EXTERNAL OBJECT TeletexString
          BY FALSE ObjectDescriptor TIME
          CHARACTER FROM OCTET TIME-OF-DAY
          CHOICE GeneralizedTime OF TRUE
          CLASS GeneralString OID-IRI TYPE-IDENTIFIER
          COMPONENT GraphicString OPTIONAL UNION
          COMPONENTS IA5String PATTERN UNIQUE
          CONSTRAINED IDENTIFIER PDV UNIVERSAL
          CONTAINING IMPLICIT PLUS-INFINITY UniversalString
          DATE IMPLIED PRESENT UTCTime
          DATE-TIME IMPORTS PrintableString UTF8String
          DEFAULT INCLUDES PRIVATE VideotexString
          DEFINITIONS INSTANCE REAL VisibleString
          DURATION INSTRUCTIONS RELATIVE-OID WITH
          EMBEDDED INTEGER RELATIVE-OID-IRI
        )
      end

      state :root do
        rule %r/(&?[a-zA-Z][-a-zA-Z0-9]*)/ do |m|
          if self.class.keywords_type.include? m[0]
            token Keyword::Type
          elsif self.class.reserved.include? m[0]
            token Keyword
          else
            token Name
          end
        end

        mixin :whitespace
        mixin :values
        mixin :statements
      end

      state :block do
        rule %r/(&?[a-zA-Z][-a-zA-Z0-9]*)/ do |m|
          if self.class.keywords_type.include? m[0]
            token Keyword::Type
          elsif self.class.reserved.include? m[0]
            token Keyword
          else
            token Name::Property
            goto :block2
          end
        end

        mixin :whitespace
        mixin :values
        mixin :statements
      end

      state :block2 do
        rule %r/(&?[a-zA-Z][-a-zA-Z0-9]*)/ do |m|
          if self.class.keywords_type.include? m[0]
            token Keyword::Type
          elsif self.class.reserved.include? m[0]
            token Keyword
          else
            token Name
          end
        end

        rule %r/,/ do
          token Punctuation
          goto :block
        end

        mixin :whitespace
        mixin :values
        mixin :statements
      end

      state :statements do
        rule %r/\b#{Rouge::Lexers::Asn1.multiple_word_keywords_type.join('|')}\b/, Keyword::Type

        rule %r/\[\[|\{/, Punctuation, :block
        rule %r/\]\]|\}/, Punctuation, :pop!
        rule %r/::=|\.\.\.|\.\./, Operator

        rule %r/./ do |m|
          # Single character lexical items (X.680 02/2021 clause 12.37)
          if "{}<>,./()[]-:=\"\';@|!^".include? m[0]
            token Punctuation
          else
            token Error
          end
        end
      end

      state :values do
        rule %r/-?([1-9][0-9]*|0)(\.[0-9]+([eE]-?[0-9]+)?|[eE]-?[0-9]+)/, Literal::Number::Float
        rule %r/-?[1-9][0-9]*|0/, Literal::Number::Integer

        # Binary string (X.680 02/2021 clause 12.10)
        rule %r/\'[01 ]+\'B/, Literal::Number::Bin
        # Hexadecimal string (X.680 02/2021 clause 12.12)
        rule %r/\'[0-9A-Z ]+\'H/i, Literal::Number::Hex

        rule %r/\"/, Literal::String, :string
      end

      state :string do
        rule %r/""/, Literal::String::Escape
        rule %r/"/, Literal::String, :pop!
        rule %r/[^"]+/, Literal::String
      end

      state :whitespace do
        rule %r/\s/, Text::Whitespace
        rule %r/--.*$/, Comment::Single
        rule %r(/\*), Comment::Multiline, :nested_comments
      end

      state :nested_comments do
        rule %r(\*/), Comment::Multiline, :pop!
        rule %r(/\*), Comment::Multiline, :nested_comments
        rule %r([^*/]+|[*/]), Comment::Multiline
      end
    end
  end
end

