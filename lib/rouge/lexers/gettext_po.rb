# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class GettextPO < RegexLexer
      tag 'gettext_po'
      aliases 'gettext', 'po'

      title "Gettext Portable Object"
      desc 'Gettext portable object files (gnu.org/software/gettext/'
      filenames '*.po', '*.pot'
      mimetypes 'text/x-gettext-translation'

      def self.keywords
        @keywords ||= Set.new %w(
          msgctxt msgid msgid_plural msgstr
        )
      end

      state :root do
        rule %r/\s+/, Text::Whitespace

        rule %r/^#[,:].*?\n/, Comment::Special
        rule %r/^#[^,:].*?\n/, Comment

        rule %r/".*?"/, Str::Double
        rule %r/\\n/, Str::Escape

        rule %r/\[/, Punctuation
        rule %r/\]/, Punctuation

        rule %r/\d+/, Literal::Number::Integer

        rule %r/^msg(ctxt|id(_plural)?|str)/, Keyword::Declaration
        rule %r/^["#m].*?\n/, Error
      end
    end
  end
end
