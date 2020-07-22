# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Email < RegexLexer
      tag 'email'
      aliases 'eml', 'mail'
      filenames '*.eml', '*.mail'
      mimetypes 'message/rfc822'

      title "Email"
      desc "An email message"

      def self.detect?(text)
        return true if text.start_with?('From: ')
      end

      state :root do
        rule %r/^(From|To|Cc|Bcc):\s/, Keyword, :address
        rule %r/^Date:\s/, Keyword, :date
        rule %r/^Subject:\s/, Keyword, :subject
        rule %r/\n/m, Text::Whitespace
        rule %r/^>.*/, Comment
        rule %r/^--\s\n/m, Comment::Doc, :signature
        rule %r/.*/, Text
      end

      state :address do
        rule %r/[^\n]+\n/m, Name, :pop!
      end

      state :date do
        rule %r/[^\n]+\n/m, Literal::Date, :pop!
      end

      state :subject do
        rule %r/[^\n]+\n/m, Name::Label, :pop!
      end

      state :signature do
        rule %r/.*/m, Comment::Doc
      end
    end
  end
end
