# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class SuperCollider < RegexLexer
      tag 'supercollider'
      filenames '*.sc', '*.scd'

      title "SuperCollider"
      desc 'A cross-platform interpreted programming language for sound synthesis, algorithmic composition, and realtime performance'

      keywords = Set.new %w(
        var arg classvar const super this
      )

      # these aren't technically keywords, but we treat
      # them as such because it makes things clearer 99%
      # of the time
      reserved = Set.new %w(
        case do for forBy loop if while new newCopyArgs
      )

      constants = Set.new %w(
        true false nil inf thisThread
        thisMethod thisFunction thisProcess
        thisFunctionDef currentEnvironment
        topEnvironment
      )

      start { push :bol }

      # beginning of line
      state :bol do
        mixin :inline_whitespace

        rule(//) { pop! }
      end

      state :inline_whitespace do
        rule /\s+/m, Text
        mixin :has_comments
      end

      state :whitespace do
        rule /\n+/m, Text, :bol
        rule %r(\/\/\.*?$), Comment::Single, :bol
        mixin :inline_whitespace
      end

      state :has_comments do
        rule %r(/[*]), Comment::Multiline, :nested_comment
      end

      state :nested_comment do
        mixin :has_comments
        rule %r([*]/), Comment::Multiline, :pop!
        rule %r([^*/]+)m, Comment::Multiline
        rule /./, Comment::Multiline
      end

      state :root do
        mixin :whitespace

        rule /[\-+]?0[xX]\h+/, Num::Hex

        # radix float
        rule /[\-+]?\d+r[0-9a-zA-Z]*(\.[0-9A-Z]*)?/, Num::Float

        # normal float
        rule /[\-+]?((\d+(\.\d+)?([eE][\-+]?\d+)?(pi)?)|pi)/, Num::Float

        rule /[\-+]?\d+/, Num::Integer

        rule /\$(\\.|.)/, Str::Char

        rule /"([^\\"]|\\.)*"/, Str

        # symbols (single-quote notation)
        rule /'([^\\']|\\.)*'/, Str::Other

        # symbols (backslash notation)
        rule /\\\w+/, Str::Other

        rule /\/\/.*$/, Comment::Single

        # symbol arg
        rule /[A-Za-z_]\w*:/, Name::Label

        rule /[A-Z]\w*/, Name::Class

        # primitive
        rule /_\w+/, Name::Function

        # main identifiers section
        rule /[a-z]\w*/ do |m|
          if keywords.include? m[0]
            token Keyword
          elsif constants.include? m[0]
            token Keyword::Constant
          elsif reserved.include? m[0]
            token Keyword::Reserved
          else
            token Name
          end
        end

        # environment variables
        rule /~\w+/, Name::Variable::Global

        rule /[\{\}()\[\];,\.]/, Punctuation

        # operators. treat # (array unpack) as an operator
        rule /[\+\-\*\/&\|%<>=]+/, Operator
        rule /[\^:#]/, Operator

        # treat curry argument as a special operator
        rule /_/, Name::Builtin

      end
    end
  end
end

