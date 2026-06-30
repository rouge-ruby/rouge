# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Vala < RegexLexer
      tag 'vala'
      filenames '*.vala', '*.vapi'
      mimetypes 'text/x-vala'

      title "Vala"
      desc 'A programming language similar to csharp.'

      id = /@?[_a-z]\w*/i

      KEYWORDS = Set.new %w(
        abstract as async base break case catch const construct continue
        default delegate delete do dynamic else ensures enum errordomain
        extern false finally for foreach get global if in inline interface
        internal is lock new null out override owned private protected
        public ref requires return set signal sizeof static switch this
        throw throws true try typeof unowned var value virtual void weak
        while yield
      )

      KEYWORDS_TYPE = Set.new %w(
        bool char double float int int8 int16 int32 int64 long short size_t
        ssize_t string unichar uint uint8 uint16 uint32 uint64 ulong ushort
      )

      state :whitespace do
        rule %r/\s+/m, Text
        rule %r(//.*?$), Comment::Single
        rule %r(/[*].*?[*]/)m, Comment::Multiline
      end

      state :root do
        mixin :whitespace

        rule %r/^\s*\[.*?\]/, Name::Attribute

        rule %r/(<\[)\s*(#{id}:)?/, Keyword
        rule %r/\]>/, Keyword

        rule %r/[~!%^&*()+=|\[\]{}:;,.<>\/?-]/, Punctuation
        rule %r/@"(\\.|.)*?"/, Str
        rule %r/"(\\.|.)*?["\n]/, Str
        rule %r/'(\\.|.)'/, Str::Char
        rule %r/0x[0-9a-f]+[lu]?/i, Num
        rule %r(
          [0-9]
          ([.][0-9]*)? # decimal
          (e[+-][0-9]+)? # exponent
          [fldu]? # type
        )ix, Num

        keywords id do
          rule Set['class', 'struct'], Keyword, :class
          rule Set['namespace', 'using'], Keyword::Namespace, :namespace
          rule KEYWORDS, Keyword
          rule KEYWORDS_TYPE, Keyword::Type
        end

        rule %r/#{id}(?=\s*[(])/, Name::Function
        rule id, Name

        rule %r/#.*/, Comment::Preproc
      end

      state :class do
        mixin :whitespace
        rule id, Name::Class, :pop!
      end

      state :namespace do
        mixin :whitespace
        rule %r/(?=[(])/, Text, :pop!
        rule %r/(#{id}|[.])+/, Name::Namespace, :pop!
      end
    end
  end
end
