# -*- coding: utf-8 -*- #
# frozen_string_literal: true

# documentation: https://developer.apple.com/library/archive/documentation/AppleScript/Conceptual/AppleScriptLangGuide/conceptual/ASLR_lexical_conventions.html#//apple_ref/doc/uid/TP40000983-CH214-SW1

module Rouge
  module Lexers
    class AppleScript < RegexLexer
      title "AppleScript"
      desc "The AppleScript scripting language by Apple Inc. (https://developer.apple.com/library/archive/documentation/AppleScript/Conceptual/AppleScriptLangGuide/introduction/ASLR_intro.html)"

      tag 'applescript'
      aliases 'applescript'

      filenames '*.applescript', '*.scpt'

      mimetypes 'application/x-applescript'

      lazy { require_relative 'applescript/keywords' }

      state :root do
        rule %r/\s+/, Text::Whitespace
        rule %r/¬\n/, Literal::String::Escape
        rule %r/'s\s+/, Text
        rule %r/(--|#).*?$/, Comment::Single
        rule %r/\(\*/, Comment::Multiline, :multicomment
        rule %r/[\(\){}!,.:]/, Punctuation
        rule %r/(«)([^»]+)(»)/ do |match|
          token Text, match[1]
          token Name::Builtin, match[2]
          token Text, match[3]
        end
        rule %r/\b((?:considering|ignoring)\s*)(application responses|case|diacriticals|hyphens|numeric strings|punctuation|white space)/ do |match|
          token Keyword, match[1]
          token Name::Builtin, match[2]
        end
        rule %r/(-|\*|\+|&|≠|>=?|<=?|=|≥|≤|\/|÷|\^)/, Operator

        rule OPERATOR_RE, Operator::Word

        rule %r/^(\s*(?:on|end)\s+)'r'(%s)/ do |match|
          token Keyword, match[1]
          token Name::Function, match[2]
        end

        rule %r/^(\s*)(in|on|script|to)(\s+)/ do |match|
          token Text, match[1]
          token Keyword, match[2]
          token Text, match[3]
        end

        ident = %r/([a-zA-Z]\w*)\b|[|].*?[|]/

        rule /(as)([ \t]+)(#{ident})/ do |match|
          groups Keyword, Text, Name::Class
        end

        rule %r/"(\\\\|\\"|[^"])*"/, Str::Double

        rule MULTI_WORD_BUILTINS_RE, Name::Builtin

        rule ident do |m|
          if RESERVED.include?(m[0])
            token Keyword
          elsif BUILTINS.include?(m[0])
            token Name::Builtin
          else
            token Name
          end
        end

        rule %r/[-+]?(\d+\.\d*|\d*\.\d+)(E[-+][0-9]+)?/, Literal::Number::Float
        rule %r/[-+]?\d+/, Literal::Number::Integer
      end

      state :multicomment do
        rule %r/[^()*]+/, Comment::Multiline
        rule %r/[(][*]/, Comment::Multiline, :multicomment
        rule %r/[*][)]/, Comment::Multiline, :pop!
        rule %r/[()*]/, Comment::Multiline
      end
    end
  end
end
