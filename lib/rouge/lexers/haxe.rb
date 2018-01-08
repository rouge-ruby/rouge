
# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Haxe < RegexLexer
      tag 'haxe'
      aliases 'hx'
      filenames '*.hx'
      mimetypes 'text/haxe'

      title "Haxe"
      desc 'A multi-paradigm, multi-target language'

      id = /\$?[a-zA-Z_][a-zA-Z0-9_]*/
      type = /[A-Z][a-zA-Z0-9_]*/

      keywords = %w(
        break case cast catch class continue default do else enum false for
        function if import interface macro new null override package private
        public return switch this throw true try untyped while
      )
      imports = %w{
        import using
      }

      declarations = %w(
        abstract dynamic extern extends implements inline
        static typedef var
      )

      cond_keywords = %w(
        if else elseif end
      )

      state :whitespace do
        rule /\s+/m, Text
        rule %r(//.*?$), Comment::Single
        rule %r(/[*].*?[*]/)m, Comment::Multiline
      end

      state :nest do
        rule /{/, Punctuation, :nest
        rule /}/, Punctuation, :pop!
        mixin :root
      end

      state :root do
        mixin :whitespace

        rule /@:?#{id}/, Name::Decorator

        rule /^\s*\[.*?\]/, Name::Attribute
        # rule /[$]\s*"/, Str, :splice_string
        # rule /[$]\s*'/, Str, :splice_string

        rule /(<\[)\s*(#{id}:)?/, Keyword
        rule /\]>/, Keyword

        rule /[~!%^&*()+=|\[\]{}:;,.<>\/?-]/, Punctuation
        # rule /"(\\.|.)*?["\n]/, Str
        # rule /'(\\.|.)*?['\n]/, Str
        rule /0x[0-9a-f]+[lu]?/i, Num
        rule %r(
          [0-9]
          ([.][0-9]*)? # decimal
          (e[+-][0-9]+)? # exponent
          [fldu]? # type
        )ix, Num
        rule /\b(?:class|interface|enum|abstract)\b/, Keyword::Declaration, :class
        rule /(?:#{declarations.join('|')})\b/, Keyword::Declaration
        rule /\b(?:import|using)\b/, Keyword, :namespace
        rule /^#[ \t]*(#{cond_keywords.join('|')})\b.*?\n/,
          Comment::Preproc
        rule /\b(#{keywords.join('|')})\b/, Keyword
        rule /\b(#{type})\b/, Keyword::Type
        rule /\b(?:true|false|null)\b/, Keyword::Constant
        rule /(?:#{imports.join('|')})\b/, Keyword::Namespace, :import
        rule /#{id}(?=\s*[(])/, Name::Function
        rule /"/, Str::Double, :dqs
        rule /'/, Str::Double, :sqs
        rule id, Name
      end

      state :sqs do
        rule /'/, Str, :pop!
        rule /[^\\\$']+/, Str
        rule /\\[nrt\'\\]/, Str::Escape
        mixin :interpolation
      end

      state :dqs do
        rule /"/, Str, :pop!
        rule /[^\\\$"]+/, Str
        rule /\\[nrt\"\\]/, Str::Escape
      end

      state :import do
        rule /;/, Operator, :pop!
        rule /(?:show|hide)\b/, Keyword::Declaration
        mixin :root
      end

      state :interpolation do
        rule /\$#{id}/, Str::Interpol
        rule /\$\{[^\}]+\}/, Str::Interpol
      end

      state :class do
        mixin :whitespace
        rule id, Name::Class, :pop!
      end

      state :namespace do
        mixin :whitespace
        rule /(?=[(])/, Text, :pop!
        rule /(#{id}|[.])+/, Name::Namespace, :pop!
      end

    end
  end
end
