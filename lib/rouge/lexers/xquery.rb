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

      # Terminal literals:
      ncName = /[a-z_][a-z_\-.0-9]*/i
      qName = /(?:#{ncName})(?::#{ncName})?/
      uriQName = /Q{[^{}]*}#{ncName}/
      eqName = /(?:#{uriQName}|#{qName})/
      commentStart = /\(:/

      keywords = Regexp.union(%w(
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

      state :tags do
        rule /<#{qName}/, Name::Tag, :start_tag
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

        rule /(namespace)(\s+)(#{ncName})/ do
          groups Keyword, Text, Name::Namespace
        end

        rule /\b(#{keywords})\b/, Keyword
        rule /;/, Punctuation
        rule /%/, Keyword::Declaration, :annotation

        rule /(\(#)(\s*)(#{eqName})/ do
          push :pragma
          groups Comment::Preproc, Text, Name::Tag
        end

        rule /``\[/, Str, :str_constructor
      end

      state :annotation do
        rule /\s+/m, Text
        rule commentStart, :comment
        rule eqName, Keyword::Declaration, :pop!
      end

      state :pragma do
        rule /\s+/m, Text
        rule commentStart, :comment
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
        rule /\s+/m, Text
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
        rule /\s+/m, Text
        mixin :tags

        rule /({{|}})/, Text
        rule /{/, Punctuation, :root

        rule /[^{}<&]/, Text

        rule %r(</#{qName}(\s*)>) do
          token Name::Tag
          pop! # pop self
          pop! # pop tag_start
        end
      end
    end
  end
end
