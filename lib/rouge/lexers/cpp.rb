# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    load_lexer 'c.rb'

    class Cpp < C
      title "C++"
      desc "The C++ programming language"

      tag 'cpp'
      aliases 'c++'
      # the many varied filenames of c++ source files...
      filenames '*.cpp', '*.hpp',
                '*.c++', '*.h++',
                '*.cc',  '*.hh',
                '*.cxx', '*.hxx',
                '*.pde', '*.ino',
                '*.tpp'
      mimetypes 'text/x-c++hdr', 'text/x-c++src'

      def self.keywords
        @keywords ||= super + Set.new(%w(
          asm auto catch const_cast delete dynamic_cast explicit export
          friend mutable namespace new operator private protected public
          reinterpret_cast restrict size_of static_cast template this throw
          throws typeid typename using virtual final override

          alignas alignof constexpr decltype noexcept static_assert
          thread_local try
        ))
      end

      def self.keywords_type
        @keywords_type ||= super + Set.new(%w(
          bool
        ))
      end

      def self.reserved
        @reserved ||= super + Set.new(%w(
          __virtual_inheritance __uuidof __super __single_inheritance
          __multiple_inheritance __interface __event
        ))
      end

      id = /[a-zA-Z_][a-zA-Z0-9_]*/

      prepend :root do
        # Offload C++ extensions, http://offload.codeplay.com/
        rule /(?:__offload|__blockingoffload|__outer)\b/, Keyword::Pseudo
      end

      # digits with optional inner quotes (since C++14)
      # see www.open-std.org/jtc1/sc22/wg21/docs/papers/2013/n3781.pdf
      dq = /\d('?\d)*/
      hq = /\h('?\h)*/
      oq = /[0-7]('?[0-7])*/
      bq = /[0-1]('?[0-1])*/

      fsuffix = /(l|f)?/
      isuffix = /(ul?l?|ll?u)?/i

      prepend :statements do
        rule /class\b/, Keyword, :classname

        ## Float literals
        rule %r((#{dq}[.]#{dq}?|[.]#{dq})(e[+-]?#{dq})?#{fsuffix})i, Num::Float
        rule %r(#{dq}e[+-]?#{dq}#{fsuffix})i, Num::Float
        # Hexadecimal floating-point literal (since C++17)
        rule %r(0x#{hq}p[+-]?#{dq}#{fsuffix})i, Num::Float
        rule %r(0x(#{hq}[.]#{hq}?|[.]#{hq})(p[+-]?#{dq})#{fsuffix})i, Num::Float

        ## Integer literals
        rule /0x#{hq}#{isuffix}/i, Num::Hex
        # Binary literals (since C++14)
        # see http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2012/n3472.pdf
        rule /0b#{bq}#{isuffix}/i, Num::Bin
        rule /0#{oq}#{isuffix}/i, Num::Oct
        rule /#{dq}#{isuffix}/i, Num::Integer

        rule /\bnullptr\b/, Name::Builtin
        rule /(?:u8|u|U|L)?R"([a-zA-Z0-9_{}\[\]#<>%:;.?*\+\-\/\^&|~!=,"']{,16})\(.*?\)\1"/m, Str
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
