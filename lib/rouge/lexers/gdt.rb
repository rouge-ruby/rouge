# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class GDT < RegexLexer
      title 'GDT'
      desc "Geräte-Daten-Träger (Device Data Carrier)"
      tag 'gdt'
      filenames '*.gdt'
      mimetypes 'text/x-gdt'

      state :root do
        rule %r/[0-9]{3}/, Text, :length
      end

      state :length do
        rule %r/(6227|6228)/, Keyword, :comment
        rule %r/8000/, Keyword, :type
        rule %r/[0-9]{4}/, Keyword, :content
        rule %r/\s+/, Text::Whitespace
      end

      state :content do
        rule %r/.*$\r?\n?/, Literal, :root
      end

      state :comment do
        rule %r/.*$\r?\n?/, Comment, :root
      end

      state :type do
        rule %r/.*$\r?\n?/, Name::Class, :root
      end

      state :whitespace do
        rule %r/\s+/, Text::Whitespace
      end
    end
  end
end
