# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class CMHG < RegexLexer
      title "CMHG"
      desc "RISC OS C module header generator source file"
      tag 'cmhg'
      filenames '*.cmhg'

      state :root do
        rule %r/;[^\n]*/, Comment
        rule %r/^([ \t]*)(#[ \t]*)(\w*)/ do
          groups Text, Comment::Preproc, Comment::Preproc
          push :preproc
        end
        rule %r/[-a-z]+:/, Keyword::Declaration
        rule %r/[a-z_]\w+/i, Name::Entity
        rule %r/"[^"]*"/, Literal::String
        rule %r/(?:&|0x)\h+/, Literal::Number::Hex
        rule %r/\d+/, Literal::Number
        rule %r/[,\/()]/, Punctuation
        rule %r/[ \t]+/, Text
        rule %r/\n+/, Text
      end

      state :preproc do
        rule %r/[^\n\\]+/, Comment::Preproc
        rule %r/\\\n/, Comment::Preproc
        rule %r/\n/, Comment::Preproc, :pop!
        rule %r/\\/, Comment::Preproc
      end
    end
  end
end
