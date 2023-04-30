# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Ion < RegexLexer
      title 'Ion'
      desc 'Amazon Ion (https://amazon-ion.github.io/ion-docs)'
      tag 'ion'
      filenames '*.ion'
      mimetypes 'application/ion'

      escapes = %r{\\(?:[\\abtR"'/?\\]|x\h{2}|u\h{4}|U\h{8})}
      q = %r{'}
      qq = %r{"}
      qqq = %r{'''}

      state :q do
        rule q, Keyword::Declaration, :pop!
        rule %r{(?:#{escapes}|\\'|[^'\n\r])+}, Keyword::Declaration
      end

      state :qq do
        rule qq, Literal::String::Double, :pop!
        rule %r{(?:#{escapes}|\\"|[^"\n\r])+}, Literal::String
      end

      state :qqq do
        rule qqq, Literal::String::Double, :pop!
        rule %r{[^']+}m, Literal::String::Double
        rule %r{'}, Literal::String::Double
      end

      state :quotes do
        rule qqq, Literal::String::Double, :qqq
        rule qq, Literal::String::Double, :qq
        rule q, Keyword::Declaration, :q
      end

      state :comments do
        rule %r{/\*.*?\*/}m, Comment::Multiline
        rule %r{//.*?$}, Comment::Single
      end

      state :constants do
        rule %r{true|false}, Name::Builtin
        rule %r{null(?:\.(?:blob|bool|clob|decimal|float|int|list|null|sexp|string|struct|symbol|timestamp))?}, Name::Builtin
      end

      state :numbers do
        rule %r{0b[01]+(?:_[01]+)*\b}, Literal::Number::Bin
        rule %r{0x\h+(?:_\h+)*\b}, Literal::Number::Hex
        rule %r{(?:nan|[+-]inf)\b}, Literal::Number::Float

        integer = %r{-?(?:0|[1-9]\d*(?:_\d+)*)}
        rule %r{#{integer}[.dD][+-]?(?:#{integer})*(?:[dDeE][+-]?#{integer})?}, Literal::Number::Float
        rule %r{#{integer}(?:[dDeE][+-]?#{integer})?}, Literal::Number::Float
        rule integer, Literal::Number::Integer
      end

      state :timestamps do
        time = %r{\d{2}:\d{2}:\d{2}\.\d{1,}|\d{2}:\d{2}:\d{2}|\d{2}:\d{2}}
        date = %r{\d{4}-\d{2}-\d{2}T?|\d{4}-\d{2}T|\d{4}T}
        rule %r{#{date}#{time}[+-]\d{2}:\d{2}|#{date}#{time}Z|#{date}#{time}|#{date}}, Literal::Date
      end

      state :symbol do
        rule %r{[A-Za-z_\$](?:[0-9A-Za-z_\$])*\s*::}, Name::Namespace
        rule %r{[A-Za-z_\$](?:[0-9A-Za-z_\$])*\s*:}, Name::Label
        rule %r{[A-Za-z_\$](?:[0-9A-Za-z_\$])*}, Name::Property
      end

      state :whitespace do
        rule %r{\s+}, Text::Whitespace
      end

      state :blob do
        rule %r/}}/, Punctuation::Indicator, :pop!

        rule qqq, Literal::String::Double, :qqq
        rule qq, Literal::String::Double, :qq

        mixin :whitespace

        # no attempt to validate the Base64 blob
        rule %r{(?:[A-Za-z0-9/\+=]+)}, Literal
      end

      state :container do
        rule %r/{{/, Punctuation::Indicator, :blob

        rule %r{\[}, Punctuation::Indicator, :list
        rule %r{\(}, Punctuation::Indicator, :sexp
        rule %r/{/, Punctuation::Indicator, :struct

        mixin :comments

        rule %r{::}, Punctuation

        mixin :constants
        mixin :timestamps
        mixin :numbers
        mixin :quotes

        rule %r{[,=:;]}, Punctuation

        mixin :whitespace
        mixin :symbol
      end

      state :list do
        rule %r{]}, Punctuation::Indicator, :pop!
        mixin :container
      end

      state :sexp do
        rule %r{\)}, Punctuation::Indicator, :pop!
        rule %r{(?:\+\+|--|<<|>>|\&\&|\.\.|\|\||[-+\*/=<>|&$^.#!%?@`~])}, Punctuation
        mixin :container
      end

      state :struct do
        rule %r/}/, Punctuation::Indicator, :pop!
        mixin :container
      end

      state :root do
        rule %r{\s*\A\$(?:ion_1_0|ion_symbol_table)\b}, Name::Builtin::Pseudo

        mixin :comments

        rule %r{::|,}, Punctuation

        mixin :constants
        mixin :timestamps
        mixin :numbers

        rule %r/{{/, Punctuation::Indicator, :blob

        rule %r{\[}, Punctuation::Indicator, :list
        rule %r{\(}, Punctuation::Indicator, :sexp
        rule %r/{/, Punctuation::Indicator, :struct

        mixin :quotes
        mixin :whitespace
        mixin :symbol
      end
    end
  end
end
