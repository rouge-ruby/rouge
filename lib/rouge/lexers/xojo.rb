# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Xojo < RegexLexer
      title "Xojo"
      desc "Xojo"
      tag 'xojo'
      aliases 'realbasic'
      filenames '*.xojo_code', '*.xojo_window'

      def self.keywords
        @keywords ||= Set.new %w(
          addhandler aggregates array asc assigns attributes begin break
          byref byval call case catch class const continue char ctype declare
          delegate dim do downto each else elseif end endif enum event exception
          exit extends false finally for function global goto if
          implements inherits interface lib loop mod module
          new next nil object of optional paramarray
          private property protected public raise raiseevent rect redim
          removehandler return select shared soft static step sub super
          then to true try until using uend uhile
        )
      end

      def self.keywords_type
        @keywords_type ||= Set.new %w(
          boolean cfstringref cgfloat cstring curency date double int8 int16
          int32 int64 integer ostype pstring ptr short single
          single string structure variant uinteger uint8 uint16 uint32 uint64
          ushort windowptr wstring
        )
      end

      def self.operator_words
        @operator_words ||= Set.new %w(
          addressof and as in is isa mod not or xor
        )
      end

      def self.builtins
        @builtins ||= Set.new %w(
          app self me
        )
      end

      id = /[a-z_]\w*/i
      upper_id = /[A-Z]\w*/

      state :whitespace do
        rule /\s+/, Text
        rule /\n/, Text, :bol
        rule /rem\b.*?$/i, Comment::Single
        rule /\/\/.*$/, Comment::Single
        rule /\#tag Note.*\#tag EndNote/m, Comment::Doc
      end

      state :bol do
        rule /\s+/, Text
        rule /<.*?>/, Name::Attribute
        rule(//) { :pop! }
      end

      state :root do
        mixin :whitespace
        rule %r(
            [#]If\b .*? \bThen
          | [#]ElseIf\b .*? \bThen
          | [#]End \s+ If
          | [#]Const
        )ix, Comment::Preproc
       rule %r(
          [#]tag.*\n
        )ix, Name::Tag
        rule /[.]/, Punctuation, :dotted
        rule /[(){}!#,:]/, Punctuation
        rule /End\b/i, Keyword, :end
        rule /(Dim|Const|Static)\b/i, Keyword, :dim
        rule /(Function|Sub|Property),?\s?\b/i, Keyword, :funcname
        rule /(Class|Structure|Enum)\b/i, Keyword, :classname

        rule upper_id do |m|
          match = m[0]
          if self.class.keywords.include? match.downcase
            token Keyword
          elsif self.class.keywords_type.include? match.downcase
            token Keyword::Type
          elsif self.class.operator_words.include? match.downcase
            token Operator::Word
          elsif self.class.builtins.include? match.downcase
            token Name::Builtin
          else
            token Name
          end
        end

        rule(
          %r(=|<=|>=|<>|[><\+\-\*\/\\]),
          Operator
        )

        rule /"/, Str, :string
        rule /#{id}([.]\w+)?/, Name::Variable
        rule /[+-]?(\d+\.\d*|\d*\.\d+)(f[+-]?\d+)?/i, Num::Float
        rule /[+-]?\d+/, Num::Integer
        rule /&[CH][0-9a-f]+/i, Num::Integer
        rule /&O[0-7]+/i, Num::Integer
      end

      state :dotted do
        mixin :whitespace
        rule id, Name, :pop!
      end

      state :string do
        rule /""/, Str::Escape
        rule /"C?/, Str, :pop!
        rule /[^"]+/, Str
      end

      state :dim do
        mixin :whitespace
        rule id, Name::Variable, :pop!
        rule(//) { pop! }
      end

      state :funcname do
        mixin :whitespace
        rule id, Name::Function, :pop!
      end

      state :classname do
        mixin :whitespace
        rule id, Name::Class, :pop!
      end

      state :end do
        mixin :whitespace
        rule /(Function|Sub|Property|Class|Structure|Enum|Module)\b/i,
          Keyword, :pop!
        rule(//) { pop! }
      end
    end
  end
end
