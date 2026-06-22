# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Racket < RegexLexer
      title "Racket"
      desc "Racket is a Lisp descended from Scheme (racket-lang.org)"

      tag 'racket'
      filenames '*.rkt', '*.rktd', '*.rktl'
      mimetypes 'text/x-racket', 'application/x-racket'

      lazy { require_relative 'racket/builtins' }

      def self.detect?(text)
        text =~ /\A#lang\s*(.*?)$/
        lang_attr = $1
        return false unless lang_attr
        return true if lang_attr =~ /racket|scribble/
      end

      # Since Racket allows identifiers to consist of nearly anything,
      # it's simpler to describe what an ID is _not_.
      id = /[^\s\(\)\[\]\{\}'`,.]+/i

      state :root do
        # comments
        rule %r/;.*$/, Comment::Single
        rule %r/#!.*/, Comment::Single
        rule %r/#\|/, Comment::Multiline, :block_comment
        rule %r/#;/, Comment::Multiline, :sexp_comment
        rule %r/\s+/m, Text

        rule %r/[+-]inf[.][f0]/, Num::Float
        rule %r/[+-]nan[.]0/, Num::Float
        rule %r/[-]min[.]0/, Num::Float
        rule %r/[+]max[.]0/, Num::Float

        rule %r/-?\d+\.\d+/, Num::Float
        rule %r/-?\d+/, Num::Integer

        rule %r/#:#{id}+/, Name::Tag  # keyword

        rule %r/#b[01]+/, Num::Bin
        rule %r/#o[0-7]+/, Num::Oct
        rule %r/#d[0-9]+/, Num::Integer
        rule %r/#x[0-9a-f]+/i, Num::Hex
        rule %r/#[ei][\d.]+/, Num::Other

        rule %r/"(\\\\|\\"|[^"])*"/, Str
        rule %r/['`]#{id}/i, Str::Symbol
        rule %r/#\\([()\/'"._!\$%& ?=+-]{1}|[a-z0-9]+)/i,
          Str::Char
        rule %r/#t(rue)?|#f(alse)?/i, Name::Constant
        rule %r/(?:'|#|`|,@|,|\.)/, Operator

        rule %r/(['#])(\s*)(\()/m do
          groups Str::Symbol, Text, Punctuation
        end

        # () [] {} are all permitted as like pairs
        rule %r/\(|\[|\{/, Punctuation, :command
        rule %r/\)|\]|\}/, Punctuation

        rule id, Name::Variable
      end

      state :block_comment do
        rule %r/[^|#]+/, Comment::Multiline
        rule %r/\|#/, Comment::Multiline, :pop!
        rule %r/#\|/, Comment::Multiline, :block_comment
        rule %r/[|#]/, Comment::Multiline
      end

      state :sexp_comment do
        rule %r/[({\[]/, Comment::Multiline, :sexp_comment_inner
        rule %r/"(?:\\"|[^"])*?"/, Comment::Multiline, :pop!
        rule %r/[^\s]+/, Comment::Multiline, :pop!
        rule(//) { pop! }
      end

      state :sexp_comment_inner do
        rule %r/[^(){}\[\]]+/, Comment::Multiline
        rule %r/[)}\]]/, Comment::Multiline, :pop!
        rule %r/[({\[]/, Comment::Multiline, :sexp_comment_inner
      end

      state :command do
        keywords id do
          rule KEYWORDS, Keyword, :pop!
          rule BUILTINS, Name::Builtin, :pop!
          default Name::Function, :pop!
        end

        rule(//) { pop! }
      end
    end
  end
end
