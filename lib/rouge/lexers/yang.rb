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

      #Keywords from RFC7950 ; oriented at BNF style
      top_stmts_keywords = %w(
        module submodule
      )

      module_header_stmts_keywords = %w(
        yang-version namespace prefix belongs-to
      )

      meta_stmts_keywords = %w(
        organization contact description reference revision
      )

      linkage_stmts_keywords =  %w(
        import include revision-date
      )

      body_stmts_keywords = %w(
        extension feature identity typedef grouping augment rpc
        notification deviation action argument identity if-feature
        input output
      )

      data_def_stmts_keywords = %w(
        container leaf-list leaf list choice anydata anyxml uses
        case config deviate must when presence refine
      )

      type_stmts_keywords = %w(
        type units default status bit enum error-app-tag error-message
        fraction-digits length min-elements max-elements modifier
        ordered-by path pattern position range require-instance value
        yin-element base
      )

      list_stmts_keywords = %w(
        key mandatory unique
      )

      #RFC7950 other keywords
      constants_keywords = %w(
        true false current obsolete deprecated add delete replace
        not-supported invert-match max min unbounded user
      )

      #RFC7950 Built-In Types
      types = %W(
        binary bits boolean decimal64 empty enumeration int8 int16
        int32 int64 string uint8 uint16 uint32 uint64 union leafref
        identityref instance-identifier
      )

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
        
        rule %r/(?:#{top_stmts_keywords.join('|')})(?=[^\w\-\:])\b/, Keyword::Declaration
        rule %r/(?:#{module_header_stmts_keywords.join('|')})(?=[^\w\-\:])\b/, Keyword::Declaration
        rule %r/(?:#{meta_stmts_keywords.join('|')})(?=[^\w\-\:])\b/, Keyword::Declaration
        rule %r/(?:#{linkage_stmts_keywords.join('|')})(?=[^\w\-\:])\b/, Keyword::Declaration
        rule %r/(?:#{body_stmts_keywords.join('|')})(?=[^\w\-\:])\b/, Keyword::Declaration
        rule %r/(?:#{data_def_stmts_keywords.join('|')})(?=[^\w\-\:])\b/, Keyword::Declaration
        rule %r/(?:#{type_stmts_keywords.join('|')})(?=[^\w\-\:])\b/, Keyword::Declaration
        rule %r/(?:#{list_stmts_keywords.join('|')})(?=[^\w\-\:])\b/, Keyword::Declaration
        rule %r/(?:#{types.join('|')})(?=[^\w\-\:])\b/, Keyword::Type
        rule %r/(?:#{constants_keywords.join('|')})(?=[^\w\-\:])\b/, Name::Constant

        rule %r/"[^"\\]*(?:\\.[^"\\]*)*"/, Str
        rule %r/\'[^\'\\]*(?:\\.[^\'\\]*)*\'/, Str

        rule %r/\/\*/, Comment, :comment
        rule %r/\/\/.*?$/, Comment

        #match BNF stmt for `node-identifier` with [ prefix ":"]
        rule %r/(?:^|(?<=[\s\{\}\;]))([^;{}\s\*\+\'\"\:\/]+)(:)([^;{}\s\*\+\'\"\:\/]+)(?=[\s\{\}\;])/ do
          groups Name::Namespace, Punctuation, Name
        end

        #match BNF stmt `date-arg-str`
        rule %r/([0-9]{4}+\-[0-9]{2}\-[0-9]{2})(?=[\s\{\}\;])/, Name::Label
        rule %r/([0-9]+\.[0-9]+)(?=[\s\{\}\;])/, Num::Float
        rule %r/([0-9]+)(?=[\s\{\}\;])/, Num::Integer
        rule %r/[^;\{\}\s\*\+\'"]+/, Name
      end
    end
  end
end
