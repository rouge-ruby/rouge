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

      start do
        push :header
      end

      state :header do
        rule %r/^(From|To|Cc|Bcc):\s/, Keyword, :address
        rule %r/^Date:\s/, Keyword, :date
        rule %r/^Subject:\s/, Keyword, :subject
        rule %r/^[A-Z][A-Za-z0-9-]+:\s/, Keyword, :other_header
        rule %r/\n/, Text::Whitespace, :pop!
      end

      state :root do
        rule %r/\n/, Text::Whitespace
        rule %r/^>.*$/, Comment
        rule %r/^--\s\n/, Comment::Doc, :signature
        rule %r/.*$/, Text
      end

      state :header_line_and_continuation do
        rule %r/\n(?=[^ \t])/, Text::Whitespace, :pop!
        rule %r/\n/, Text::Whitespace
      end

      state :address do
        mixin :header_line_and_continuation
        rule %r/.*$/, Name
      end

      state :date do
        mixin :header_line_and_continuation
        rule %r/.*$/, Literal::Date
      end

      state :subject do
        mixin :header_line_and_continuation
        rule %r/.*$/, Name::Label
      end

      state :other_header do
        mixin :header_line_and_continuation
        rule %r/.*$/, Literal::String
      end

      state :signature do
        rule %r/.*/m, Comment::Doc
      end
    end
  end
end
