# -*- coding: utf-8 -*- #
# frozen_string_literal: true
# https://www.gnu.org/software/gettext/manual/html_node/PO-Files.html

module Rouge
  module Lexers
    class Gettext < RegexLexer
      tag 'gettext'
      aliases 'po'

      title "Gettext File"
      desc 'Gettext portable object'
      filenames '*.po', '*.pot'
      mimetypes 'text/x-gettext-translation'

      def self.keywords
        @keywords ||= super + Set.new(%w(
          msgctxt msgid msgid_plural msgstr
        ))
      end

      state :root do
        rule %r/^#[,:].*?\n/, Comment::Special
        rule %r/^#[^,:].*?\n/, Comment
        rule %r/".*?"/, Str::Double
        rule %r/\\n/, Str::Escape
        rule %r/\s+/, Text::Whitespace
        rule %r/\[/, Punctuation
        rule %r/\]/, Punctuation
        rule %r/[0-9]+/, Literal::Number::Integer

        rule %r/^msg(ctxt|id(_plural)?|str)/, Keyword::Declaration
        rule %r/^["#m].*?\n/, Error
      end
    end
  end
end
