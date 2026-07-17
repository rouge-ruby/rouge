# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class YANG < RegexLexer
      title 'YANG'
      desc "Lexer for the YANG 1.1 modeling language (RFC7950)"
      tag 'yang'
      filenames '*.yang'
      mimetypes 'application/yang'

      id = /[\w-]+(?=[^\w\-\:])\b/

      #Keywords from RFC7950 ; oriented at BNF style
      top_keywords = Set.new %w(module submodule)

      module_header_keywords = Set.new %w(belongs-to namespace prefix yang-version)

      meta_keywords = Set.new %w(contact description organization reference revision)

      linkage_keywords = Set.new %w(import include revision-date)

      body_keywords = Set.new %w(
        action argument augment deviation extension feature grouping identity
        if-feature input notification output rpc typedef
      )

      data_def_keywords = Set.new %w(
        anydata anyxml case choice config container deviate leaf leaf-list
        list must presence refine uses when
      )

      type_keywords = Set.new %w(
        base bit default enum error-app-tag error-message fraction-digits
        length max-elements min-elements modifier ordered-by path pattern
        position range require-instance status type units value yin-element
      )

      list_keywords = Set.new %w(
        key mandatory unique
      )

      #RFC7950 other keywords
      CONSTANTS = Set.new %w(
        add current delete deprecated false invert-match max min
        not-supported obsolete replace true unbounded user
      )

      #RFC7950 Built-In Types
      TYPES = Set.new %w(
        binary bits boolean decimal64 empty enumeration identityref
        instance-identifier int16 int32 int64 int8 leafref string uint16
        uint32 uint64 uint8 union
      )

      DECLARATIONS =
        top_keywords +
        module_header_keywords +
        meta_keywords +
        linkage_keywords +
        body_keywords +
        data_def_keywords +
        type_keywords +
        list_keywords

      state :comment do
        rule %r/[^*\/]/, Comment
        rule %r/\/\*/, Comment, :comment
        rule %r/\*\//, Comment, :pop!
        rule %r/[*\/]/, Comment
      end

      #Keyword::Reserved
      #groups Name::Tag, Text::Whitespace
      state :root do
        rule %r/\s+/, Text::Whitespace
        rule %r/[\{\}\;]+/, Punctuation
        rule %r/(?<![\-\w])(and|or|not|\+|\.)(?![\-\w])/, Operator

        rule %r/"(?:\\"|[^"])*?"/, Str::Double #for double quotes
        rule %r/'(?:\\'|[^'])*?'/, Str::Single #for single quotes

        rule %r/\/\*/, Comment, :comment
        rule %r/\/\/.*?$/, Comment

        #match BNF stmt for `node-identifier` with [ prefix ":"]
        rule %r/(?:^|(?<=[\s{};]))([\w.-]+)(:)([\w.-]+)(?=[\s{};])/ do
          groups Name::Namespace, Punctuation, Name
        end

        #match BNF stmt `date-arg-str`
        rule %r/([0-9]{4}\-[0-9]{2}\-[0-9]{2})(?=[\s\{\}\;])/, Name::Label
        rule %r/([0-9]+\.[0-9]+)(?=[\s\{\}\;])/, Num::Float
        rule %r/([0-9]+)(?=[\s\{\}\;])/, Num::Integer

        rule id do |m|
          name = m[0].downcase

          if DECLARATIONS.include?(name)
            token Keyword::Declaration
          elsif TYPES.include? name
            token Keyword::Type
          elsif CONSTANTS.include? name
            token Name::Constant
          else
            token Name
          end
        end

        rule %r/[^;{}\s'"]+/, Name
      end
    end
  end
end
