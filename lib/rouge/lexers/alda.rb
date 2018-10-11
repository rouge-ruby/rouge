# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Alda < RegexLexer
      title "Alda"
      desc "The Alda programming language for music composition"
      tag 'alda'
      filenames "*.alda"
      mimetypes 'text/alda'

      def self.detect?(text)
        return true if text.shebang? 'alda'
      end

      state :root do
        rule /#[ \S]+/, Comment
        rule /o\d/, Keyword::Constant
        rule /(\w+)( "[[:alpha:]]{2}[\w\-\+'()]*"+)?(:)/ do |m|
          token Keyword::Type, m[1]
          token Name::Label, m[2]
          token Punctuation, m[3]
        end

        rule /(\()([\w\-]+!?)( )([^\)]+)(\))/ do |m|
          token Punctuation, m[1]
          token Keyword::Reserved, m[2]
          token Text, m[3]
          token Name::Variable, m[4]
          token Punctuation, m[5]
        end

        rule /[@%]\w+/, Name::Variable
        rule /[\[\]|!:\{\}]/, Punctuation
        rule /[\S]+\/\S*/, Generic::Strong
        rule /[<>]/, Operator
        rule /./m, Text
      end

    end
  end
end
