# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    load_lexer 'xpath.rb'
    class XQuery < XPath
      title 'XQuery'
      desc 'XQuery 3.1: An XML Query Language'
      tag 'xquery'
      filenames '*.xquery', '*.xq'
      mimetypes 'application/xquery'

      def self.keywords
        @keywords ||= Regexp.union super, Regexp.union(%w(
          xquery encoding version declare module
          namespace copy-namespaces boundary-space construction
          default collation base-uri preserve strip
          ordering ordered unordered order empty greatest least
          preserve no-preserve inherit no-inherit
          decimal-format decimal-separator grouping-separator
          infinity minus-sign NaN percent per-mille
          zero-digit digit pattern-separator exponent-separator
          import schema at element option
          function external context item
          typeswitch switch case
          try catch
          validate lax strict type
          document element attribute text comment processing-instruction
          for let where order group by return
          allowing tumbling stable sliding window
          start end only when previous next count collation
          ascending descending
        ))
      end

      state :tags do
        rule /<#{XPath.qName}/, Name::Tag, :start_tag
        rule /<!--/, Comment, :xml_comment
        rule /<\?.*?\?>/, Comment::Preproc
        rule /<!\[CDATA\[.*?\]\]>/, Comment::Preproc
        rule /&\S*?;/, Name::Entity
      end

      prepend :root do
        mixin :tags

        rule /{/, Punctuation, :root
        rule /}(`)?/ do
          token Punctuation
          if stack.length > 1
            pop!
          end
        end

        rule /(namespace)(\s+)(#{XPath.ncName})/ do
          groups Keyword, Text::Whitespace, Name::Namespace
        end

        rule /\b(#{XQuery.keywords})\b/, Keyword
        rule /;/, Punctuation
        rule /%/, Keyword::Declaration, :annotation

        rule /(\(#)(\s*)(#{XPath.eqName})/ do
          push :pragma
          groups Comment::Preproc, Text::Whitespace, Name::Tag
        end

        rule /``\[/, Str, :str_constructor
      end

      state :annotation do
        rule /\s+/m, Text::Whitespace
        rule XPath.commentStart, :comment
        rule XPath.eqName, Keyword::Declaration, :pop!
      end

      state :pragma do
        rule /\s+/m, Text::Whitespace
        rule XPath.commentStart, :comment
        rule /#\)/, Comment::Preproc, :pop!
        rule /./, Comment::Preproc
      end

      # https://www.w3.org/TR/xquery-31/#id-string-constructors
      state :str_constructor do
        rule /`{/, Punctuation, :root
        rule /\]``/, Str, :pop!
        rule /[^`\]]+/m, Str
        rule /[`\]]/, Str
      end

      state :xml_comment do
        rule /[^-]+/m, Comment
        rule /-->/, Comment, :pop!
        rule /-/, Comment
      end

      state :start_tag do
        rule /\s+/m, Text::Whitespace
        rule /([\w.:-]+\s*=)(")/m do
          push :quot_attr
          groups Name::Attribute, Str
        end
        rule /([\w.:-]+\s*=)(')/m do
          push :apos_attr
          groups Name::Attribute, Str
        end
        rule />/, Name::Tag, :tag_content
        rule %r(/>), Name::Tag, :pop!
      end

      state :quot_attr do
        rule /"/, Str, :pop!
        rule /{{/, Str
        rule /{/, Punctuation, :root
        rule /[^"{>]+/m, Str
      end

      state :apos_attr do
        rule /'/, Str, :pop!
        rule /{{/, Str
        rule /{/, Punctuation, :root
        rule /[^'{>]+/m, Str
      end

      state :tag_content do
        rule /\s+/m, Text::Whitespace
        mixin :tags

        rule /({{|}})/, Text
        rule /{/, Punctuation, :root

        rule /[^{}<&]/, Text

        rule %r(</#{XPath.qName}(\s*)>) do
          token Name::Tag
          pop! 2 # pop self and tag_start
        end
      end
    end
  end
end
