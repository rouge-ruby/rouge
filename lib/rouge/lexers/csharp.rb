# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class CSharp < RegexLexer
      tag 'csharp'
      aliases 'c#', 'cs'
      filenames '*.cs'
      mimetypes 'text/x-csharp'

      title "C#"
      desc 'a multi-paradigm language targeting .NET'

      id = /@?[_\p{Lu}\p{Ll}\p{Lt}\p{Lm}\p{Nl}][\p{Lu}\p{Ll}\p{Lt}\p{Lm}\p{Nl}\p{Nd}\p{Pc}\p{Cf}\p{Mn}\p{Mc}]*/

      # Reserved Identifiers
      # Contextual Keywords
      # LINQ Query Expressions
      def self.keywords
        @keywords ||= Set.new %w(
          abstract add alias and as ascending async await base
          break by case catch checked const continue default delegate
          descending do else enum equals event explicit extern false
          finally fixed for foreach from get global goto group
          if implicit in init interface internal into is join
          let lock nameof new notnull null on operator orderby
          out override params partial private protected public readonly
          ref remove return sealed set sizeof stackalloc static
          switch this throw true try typeof unchecked unsafe
          unmanaged value virtual void volatile when where while
          with yield
        )
      end

      def self.keywords_type
        @keywords_type ||= Set.new %w(
          bool byte char decimal double dynamic float int long nint nuint
          object sbyte short string uint ulong ushort var
        )
      end

      def self.cpp_keywords
        @cpp_keywords ||= Set.new %w(
          if endif else elif define undef line error warning region
          endregion pragma nullable
        )
      end

      state :whitespace do
        rule %r/^[ \t]*#/, Comment::Preproc, :preproc

        rule %r/\s+/m, Text
        rule %r(//.*?$), Comment::Single
        rule %r(/[*].*?[*]/)m, Comment::Multiline
      end

      state :nest do
        rule %r/{/, Punctuation, :nest
        rule %r/}/, Punctuation, :pop!
        mixin :root
      end

      state :splice_string do
        rule %r/\\./, Str
        rule %r/{/, Punctuation, :nest
        rule %r/"|\n/, Str, :pop!
        rule %r/./, Str
      end

      state :splice_literal do
        rule %r/""/, Str
        rule %r/{/, Punctuation, :nest
        rule %r/"/, Str, :pop!
        rule %r/./, Str
      end

      state :root do
        mixin :whitespace

        rule %r/[$]\s*"/, Str, :splice_string
        rule %r/[$]@\s*"/, Str, :splice_literal

        rule %r/(<\[)\s*(#{id}:)?/, Keyword
        rule %r/\]>/, Keyword

        rule %r/[~!%^&*()+=|\[\]{}:;,.<>\/?-]/, Punctuation
        rule %r/@"(""|[^"])*"/m, Str
        rule %r/"(\\.|.)*?["\n]/, Str
        rule %r/'(\\.|.)'/, Str::Char
        rule %r/0b[_01]+[lu]?/i, Num
        rule %r/0x[_0-9a-f]+[lu]?/i, Num
        rule %r(
          [0-9](?:[_0-9]*[0-9])?
          ([.][0-9](?:[_0-9]*[0-9])?)? # decimal
          (e[+-]?[0-9](?:[_0-9]*[0-9])?)? # exponent
          [fldum]? # type
        )ix, Num
        rule %r/\b(?:class|record|struct|interface)\b/, Keyword, :class
        rule %r/\b(?:namespace|using)\b/, Keyword, :namespace

        keywords %r/\w+/ do
          rule :keywords, Keyword
          rule :keywords_type, Keyword::Type
        end

        rule %r/#{id}(?=\s*[(])/, Name::Function
        rule id, Name
      end

      state :preproc do
        rule %r/[^\\\n]+/, Comment::Preproc
        rule %r/\\.?/m, Comment::Preproc
        rule %r/\n/, Comment::Preproc, :pop!
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
