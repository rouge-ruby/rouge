# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    load_lexer 'c.rb'

    class D < C
      title "D"
      desc "The D programming language"

      tag 'd'
      aliases 'dlang'
      # the many varied filenames of c++ source files...
      filenames '*.d', '*.di'
      mimetypes 'text/x-dhdr', 'text/x-dsrc'

      def self.keywords
        @keywords ||= super + Set.new(%w(
          asm catch cast delete export import immutable
          new private protected public package template this throw
          throws typeid typename using virtual, pragma
        ))
      end

      def self.reserved
        @reserved ||= super + Set.new(%w(
          __traits
        ))
      end

      id = /[a-zA-Z_][a-zA-Z0-9]*/

      prepend :root do
        # Offload C++ extensions, http://offload.codeplay.com/
        rule /(?:__offload|__blockingoffload|__outer)\b/, Keyword::Pseudo
      end

      # digits with optional inner quotes
      # see www.open-std.org/jtc1/sc22/wg21/docs/papers/2013/n3781.pdf
      dq = /\d('?\d)*/

      prepend :statements do
        rule /class\b/, Keyword, :classname
        rule %r((#{dq}[.]#{dq}?|[.]#{dq})(e[+-]?#{dq}[lu]*)?)i, Num::Float
        rule %r(#{dq}e[+-]?#{dq}[lu]*)i, Num::Float
        rule /0x\h('?\h)*[lu]*/i, Num::Hex
        rule /0[0-7]('?[0-7])*[lu]*/i, Num::Oct
        rule /#{dq}[lu]*/i, Num::Integer
      end

      state :classname do
        rule id, Name::Class, :pop!

        # template specification
        rule /\s*(?=>)/m, Text, :pop!
        mixin :whitespace
      end
    end
  end
end
