# -*- coding: utf-8 -*- #
# frozen_string_literal: true

# regex based on https://github.com/SaswatPadhi/prismjs-bibtex and https://github.com/alecthomas/chroma/blob/master/lexers/b/bibtex.go

module Rouge
  module Lexers
    class BibTeX < RegexLexer
      title 'BibTeX'
      desc "BibTeX"
      tag 'bibtex'
      filenames '*.bib'

      valid_name = /[a-z\_\@\!\$\&\*\+\-\.\/\:\;\<\>\?\[\\\]\^\`\|\~][\w\@\!\$\&\*\+\-\.\/\:\;\<\>\?\[\\\]\^\`\|\~]*/i

      state :root do
        mixin :whitespace
        rule %r/@comment/i, Comment
        rule %r/@preamble/i do
          token Name::Class
          push :closing_brace
          push :value
          push :opening_brace
        end
        rule %r/@string/i do
          token Name::Class
          push :closing_brace
          push :field
          push :opening_brace
        end
        rule %r/@#{valid_name}/i do
          token Name::Class
          push :closing_brace
          push :command_body
          push :opening_brace
        end
        rule %r/.+/i, Comment
      end

      state :opening_brace do
        mixin :whitespace
        rule %r/[{(]/i, Punctuation, :pop!
      end

      state :closing_brace do
        mixin :whitespace
        rule %r/[})]/i, Punctuation, :pop!
      end

      state :command_body do
        mixin :whitespace
        rule %r/[^\s\,\}]+/i do
          token Name::Label
          pop!
          push :fields
        end
      end

      state :fields do
        mixin :whitespace
        rule %r/,/i, Punctuation, :field
        rule(//) { pop! }
      end

      state :field do
        mixin :whitespace
        rule(/#{valid_name}/i) { token Name::Attribute; push :value; push :equal_sign }
        rule(//) { pop! }
      end

      state :equal_sign do
        mixin :whitespace
        rule %r/=/i, Punctuation, :pop!
      end

      state :value do
        mixin :whitespace
        rule %r/#{valid_name}/i, Name::Variable
        rule %r/"/i, Literal::String, :quoted_string
        rule %r/\{/i, Literal::String, :braced_string
        rule %r/[\d]+/i, Literal::Number
        rule %r/#/i, Punctuation
        rule(//) { pop! }
      end

      state :quoted_string do
        rule %r/\{/i, Literal::String, :braced_string
        rule %r/"/i, Literal::String, :pop!
        rule %r/[^\{\"]+/i, Literal::String
      end

      state :braced_string do
        rule %r/\{/i, Literal::String, :braced_string
        rule %r/\}/i, Literal::String, :pop!
        rule %r/[^\{\}]+/i, Literal::String
      end

      state :whitespace do
        rule %r/\s+/i, Text
      end
    end
  end
end
