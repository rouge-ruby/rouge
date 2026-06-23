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
      q = %r{'(?:#{escapes}|\\'|[^"\n\r])+'}
      qq = %r{"(?:#{escapes}|\\"|[^"\n\r])+"}
      qqq = %r{'''}
      symbol = %r{[A-Za-z_\$](?:[0-9A-Za-z_\$])*}

      state :qq do
        rule qq, Literal::String::Double
      end

      state :qqq do
        rule %r{'''}, Literal::String::Double, :pop!
        rule %r{[^']+}m, Literal::String::Double
        rule %r{'}, Literal::String::Double
      end

      state :quotes do
        rule qqq, Literal::String::Double, :qqq
        mixin :qq
        rule symbol, Literal::String::Symbol
        rule q, Literal::String::Symbol
      end

      state :annotation do
        annotation = %r{(?:[\u{0020}-\u{0026}]|[\u{0028}-\u{005B}]|[\u{005D}-\u{FFFF}]|[\t\b\f ])+}
        rule %r{('#{annotation}'|#{symbol})(\s*)(::)} do
          groups Name::Decorator, Text::Whitespace, Operator
        end
      end

      state :comments do
        rule %r{/\*.*?\*/}m, Comment::Multiline
        rule %r{//.*?$}, Comment::Single
      end

      state :constants do
        rule %r{(?:true|false)\b}, Name::Builtin
        rule %r{null(?:\.(?:blob|bool|clob|decimal|float|int|list|null|sexp|string|struct|symbol|timestamp))?\b}, Name::Builtin
      end

      state :numbers do
        rule %r{0b[01]+(?:_[01]+)*\b}, Literal::Number::Bin
        rule %r{0x\h+(?:_\h+)*\b}, Literal::Number::Hex
        rule %r{(?:nan|[+-]inf)\b}, Literal::Number::Float

        integer = %r{-?(?:0|[1-9]\d*(?:_\d+)*)}
        rule %r{#{integer}[.dD][+-]?(?:#{integer})*(?:[dDeE][+-]?#{integer})?}, Literal::Number::Float
        rule %r{#{integer}[dDeE][+-]?#{integer}}, Literal::Number::Float
        rule integer, Literal::Number::Integer
      end

      state :timestamps do
        year = %r{000[1-9]|00[1-9]\d|0[1-9]\d{2}|[1-9]\d{3}}
        month = %r{0[1-9]|1[0-2]}
        day = %r{0[1-9]|[12]\d|3[01]}
        date = %r{#{year}-#{month}-#{day}}

        hour = %r{[01]\d|2[0-3]}
        minute = %r{[0-5]\d}
        second = %r{[0-5]\d(?:\.\d+)?}
        offset = %r{Z|[+-]#{hour}:#{minute}}
        time = %r{#{hour}:#{minute}(?::#{second})?#{offset}}

        rule %r{#{date}(T#{time}?)?|#{year}(?:-#{month})?T}, Literal::Date
      end

      state :whitespace do
        rule %r{\s+}, Text::Whitespace
      end

      state :blob do
        rule %r/}}/, Punctuation::Indicator, :pop!

        rule qqq, Literal::String::Double, :qqq
        mixin :qq
        mixin :whitespace

        # no attempt to validate the Base64 blob
        rule %r{(?:[A-Za-z0-9/\+=]+)}, Literal
      end

      state :containers do
        rule %r/{{/, Punctuation::Indicator, :blob
        rule %r{\[}, Punctuation::Indicator, :list
        rule %r{\(}, Punctuation::Indicator, :sexp
        rule %r/{/, Punctuation::Indicator, :struct
      end

      state :list do
        rule %r{]}, Punctuation::Indicator, :pop!

        mixin :containers
        mixin :comments
        mixin :annotation
        mixin :whitespace
        mixin :constants
        mixin :timestamps
        mixin :numbers
        mixin :quotes

        rule %r{[,=;]}, Punctuation
      end

      state :sexp do
        rule %r{\)}, Punctuation::Indicator, :pop!
        rule %r{(?:\+\+|--|<<|>>|\&\&|\.\.|\|\||[-+\*/=<>|&$^.#!%?@`~])}, Operator

        mixin :containers
        mixin :comments
        mixin :annotation
        mixin :whitespace
        mixin :constants
        mixin :timestamps
        mixin :numbers
        mixin :quotes
      end

      state :struct do
        rule %r/}/, Punctuation::Indicator, :pop!

        rule %r{(#{q}|#{qq}|#{symbol})(\s*)(:)} do
          groups Name::Label, Text::Whitespace, Punctuation
          push :value
        end

        mixin :containers
        mixin :comments
        mixin :whitespace
      end

      state :value do
        mixin :containers
        mixin :comments
        mixin :whitespace
        mixin :annotation
        mixin :constants
        mixin :timestamps
        mixin :numbers
        mixin :quotes

        rule %r{,}, Punctuation, :pop!

        rule %r/(})/ do
          groups Punctuation::Indicator
          pop!(2)
        end
      end

      state :root do
        rule %r{\s*\A\$(?:ion_1_0|ion_symbol_table)\b}, Name::Builtin::Pseudo

        mixin :comments
        mixin :annotation
        mixin :constants
        mixin :timestamps
        mixin :numbers
        mixin :containers
        mixin :quotes
        mixin :whitespace
      end
    end
  end
end
