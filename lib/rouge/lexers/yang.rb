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

      id = /[\w_-]+(?=[^\w\-\:])\b/

      #Keywords from RFC7950 ; oriented at BNF style
      def self.top_stmts_keywords
        @top_stms_keywords ||= Set.new %w(
          module submodule
        )
      end

      def self.module_header_stmts_keywords
        @module_header_stmts_keywords ||= Set.new %w(
          yang-version namespace prefix belongs-to
        )
      end

      def self.meta_stmts_keywords
        @meta_stmts_keywords ||= Set.new %w(
          organization contact description reference revision
        )
      end

      def self.linkage_stmts_keywords
        @linkage_stmts_keywords ||= Set.new %w(
          import include revision-date
        )
      end

      def self.body_stmts_keywords
        @body_stms_keywords ||= Set.new %w(
          extension feature identity typedef grouping augment rpc notification
          deviation action argument identity if-feature input output
        )
      end

      def self.data_def_stmts_keywords
        @data_def_stms_keywords ||= Set.new %w(
          container leaf-list leaf list choice anydata anyxml uses case config
          deviate must when presence refine
        )
      end

      def self.type_stmts_keywords
        @type_stmts_keywords ||= Set.new %w(
          type units default status bit enum error-app-tag error-message
          fraction-digits length min-elements max-elements modifier ordered-by
          path pattern position range require-instance value yin-element base
        )
      end

      def self.list_stmts_keywords
        @list_stmts_keywords ||= Set.new %w(
          key mandatory unique
        )
      end

      #RFC7950 other keywords
      def self.constants_keywords
        @constants_keywords ||= Set.new %w(
          true false current obsolete deprecated add delete replace
          not-supported invert-match max min unbounded user
        )
      end

      #RFC7950 Built-In Types
      def self.types
        @types ||= Set.new %w(
          binary bits boolean decimal64 empty enumeration int8 int16 int32
          int64 string uint8 uint16 uint32 uint64 union leafref identityref
          instance-identifier
        )
      end

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

          if self.class.top_stmts_keywords.include? name
            token Keyword::Declaration
          elsif self.class.module_header_stmts_keywords.include? name
            token Keyword::Declaration
          elsif self.class.meta_stmts_keywords.include? name
            token Keyword::Declaration
          elsif self.class.linkage_stmts_keywords.include? name
            token Keyword::Declaration
          elsif self.class.body_stmts_keywords.include? name
            token Keyword::Declaration
          elsif self.class.data_def_stmts_keywords.include? name
            token Keyword::Declaration
          elsif self.class.type_stmts_keywords.include? name
            token Keyword::Declaration
          elsif self.class.list_stmts_keywords.include? name
            token Keyword::Declaration
          elsif self.class.types.include? name
            token Keyword::Type
          elsif self.class.constants_keywords.include? name
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
