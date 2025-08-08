# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Kos < RegexLexer
      tag 'kos'
      filenames '*.kos'
      mimetypes 'application/kos', 'text/kos'

      def self.detect?(text)
        return 1 if text.shebang?('kos')
      end

      title "Kos"
      desc 'General-purpose scripting language. (kos-lang.github.io)'

      id_head = /_|(?!\p{Mc})\p{Alpha}|[^\u0000-\uFFFF]/
      id_rest = /[\p{Alnum}_]|[^\u0000-\uFFFF]/
      id = /#{id_head}#{id_rest}*/

      keywords = Set.new %w(
        _ __line__ assert async break case catch continue default
        defer delete do else fallthrough for get if in instanceof loop
        match propertyof repeat return set super switch this throw try typeof
        while with yield
      )

      declarations = Set.new %w(
        class const constructor extends fun import public static var
      )

      constants = Set.new %w(
        true false void
      )

      state :inline_whitespace do
        rule %r/\s+/m, Text
        mixin :has_comments
      end

      state :whitespace do
        rule %r/\n+/m, Text
        rule %r(\/\/.*?$), Comment::Single
        rule %r(#.*?$), Comment::Single
        mixin :inline_whitespace
      end

      state :has_comments do
        rule %r(/[*]), Comment::Multiline, :nested_comment
      end

      state :nested_comment do
        mixin :has_comments
        rule %r([*]/), Comment::Multiline, :pop!
        rule %r([^*/]+)m, Comment::Multiline
        rule %r/./, Comment::Multiline
      end

      state :root do
        mixin :whitespace
        
        rule %r/\$(([1-9]\d*)?\d)/, Name::Variable

        rule %r{[()\[\]{}:;,?]}, Punctuation
        rule %r([-/=+*%<>!&|^.~]+), Operator
        rule %r/r?"/, Str, :dq
        rule %r/(\d+(?:_\d+)*\*|(?:\d+(?:_\d+)*)*\.\d+(?:_\d)*)([eEpP][+-]?\d+(?:_\d)*)?/i, Num::Float
        rule %r/\d+[eEpP][+-]?[0-9]+/i, Num::Float
        rule %r/0[xX][0-9A-Fa-f]+(?:_[0-9A-Fa-f]+)*((\.[0-9A-F]+(?:_[0-9A-F]+)*)?p[+-]?\d+)?/, Num::Hex
        rule %r/0[bB][01]+(?:_[01]+)*/, Num::Bin
        rule %r{[\d]+(?:_\d+)*}, Num::Integer

        rule %r/(const|var)\b(\s*)(#{id})/ do
          groups Keyword, Text, Name::Variable
        end

        rule id do |m|
          if keywords.include? m[0]
            token Keyword
          elsif declarations.include? m[0]
            token Keyword::Declaration
          elsif constants.include? m[0]
            token Keyword::Constant
          else
            token Name
          end
        end
      end

      state :dq do
        rule %r/\\[\\0fnrtv"]/, Str::Escape
        rule %r/\\[(]/, Str::Escape, :interp
        rule %r/\\x\h\h/, Str::Escape
        rule %r/\\u\{\h{1,8}\}/, Str::Escape
        rule %r/[^\\"]+/, Str
        rule %r/"""/, Str, :pop!
        rule %r/"/, Str, :pop!
      end

      state :interp do
        rule %r/[(]/, Punctuation, :interp_inner
        rule %r/[)]/, Str::Escape, :pop!
        mixin :root
      end

      state :interp_inner do
        rule %r/[(]/, Punctuation, :push
        rule %r/[)]/, Punctuation, :pop!
        mixin :root
      end
    end
  end
end
