# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
	module Lexers
  	class Squirrel < RegexLexer
      tag 'squirrel'
      filenames '*.nut'
      mimetypes 'text/x-squirrel'

      title "Squirrel"
      desc 'The Squirrel programming language'

      any = /@?[_a-z]\w*/i

      state :whitespace do
        rule /\s+/, Text
        rule %r((#|//).*$), Comment::Single
        rule %r(/[*].*?[*]/)m, Comment::Multiline
      end

      state :nest do
        rule /{/, Punctuation, :nest
        rule /}/, Punctuation, :pop!
        mixin :root
      end

      state :splice_string do
        rule /\\./, Str
        rule /{/, Punctuation, :nest
        rule /"|\n/, Str, :pop!
        rule /./, Str
      end

      state :splice_literal do
        rule /""/, Str
        rule /{/, Punctuation, :nest
        rule /"/, Str, :pop!
        rule /./, Str
      end

      state :root do
        mixin :whitespace

        # strings
        rule /[$]\s*"/, Str, :splice_string
        rule /[$]@\s*"/, Str, :splice_literal
        rule /@"(""|[^"])*"/m, Str
        rule /"(\\.|.)*?["\n]/, Str
        rule /'(\\.|.)'/, Str::Char

        # naming
        rule /\b(?:class)\b/, Keyword, :class_name
        rule /\b(?:function)\b/, Keyword, :function_name
        rule /\b(?:local)\b/, Keyword, :variable_name

        # reserved words
        rule %r((base|break|case|catch|clone|const|default|delete|do|else|extends|for|foreach|if|in|instanceof|resume|return|static|switch|this|throw|try|typeof|while|yield)\b), Keyword
        rule %r((class|constructor|function|local)\b), Keyword::Declaration
        rule %r((true|false|null)\b), Keyword::Constant

        # operators and punctuation
        rule /[~!%^&*()+=|\[\]{}:;,.<>\/?-]/, Punctuation

        # numbers
        rule %r((?i)(\d*\.\d+|\d+\.\d*)(e[+-]?\d+)?'), Num::Float
        rule %r((?i)\d+e[+-]?\d+), Num::Float
        rule %r((?i)0x[0-9a-f]*), Num::Hex
        rule %r(\d+), Num::Integer

        rule any, Name
      end

      state :class_name do
        mixin :whitespace
        rule any, Name::Class, :pop!
      end

      state :function_name do
        mixin :whitespace
        rule any, Name::Function, :pop!
      end

      state :variable_name do
        mixin :whitespace
        rule any, Name::Variable, :pop!
      end

    end
  end
end
