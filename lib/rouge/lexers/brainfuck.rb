# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Brainfuck < RegexLexer
      tag 'brainfuck'
      filenames '*.b', '*.bf'
      mimetypes 'text/x-brainfuck'

      title "Brainfuck"
      desc "The Brainfuck programming language"

      start { push :bol }

      state :bol do
        rule /\s+/m, Text
        rule /\[/, Comment::Multiline, :comment_multi
        rule(//) { pop! }
      end

      state :root do
        rule /\]/, Error
        rule /\[/, Punctuation, :loop

        mixin :comment_single
        mixin :commands
      end

      state :comment_multi do
        rule /\[/, Comment::Multiline, :comment_multi
        rule /\]/, Comment::Multiline, :pop!
        rule /[^\[\]]+?/m, Comment::Multiline
      end

      state :comment_single do
        rule /[^><+\-.,\[\]]+/, Comment::Single
      end

      state :loop do
        rule /\[/, Punctuation, :loop
        rule /\]/, Punctuation, :pop!
        mixin :comment_single
        mixin :commands
      end

      state :commands do
        rule /[><]+/, Name::Builtin
        rule /[+\-.,]+/, Name::Function
      end
    end
  end
end
