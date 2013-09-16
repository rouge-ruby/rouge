module Rouge
  module Lexers
    class Cpp < C
      desc "The C++ programming language"

      tag 'cpp'
      aliases 'c++'
      # the many varied filenames of c++ source files...
      filenames '*.cpp', '*.hpp',
                '*.c++', '*.h++',
                '*.cc',  '*.hh',
                '*.cxx', '*.hxx'
      mimetypes 'text/x-c++hdr', 'text/x-c++src'

      def self.keywords
        @keywords ||= Set.new %w(
          asm auto break case catch const const_cast continue
          default delete do dynamic_cast else enum explicit export
          extern for friend goto if mutable namespace new operator
          private protected public register reinterpret_cast return
          restrict sizeof static static_cast struct switch template
          this throw throws try typedef typeid typename union using
          volatile virtual while
        )
      end

      def self.keywords_type
        @keywords_type ||= Set.new %w(
          bool int long float short double char unsigned signed void wchar_t
        )
      end

      def self.reserved
        @reserved ||= Set.new %w(
          __asm __int8 __based __except __int16 __stdcall __cdecl
          __fastcall __int32 __declspec __finally __int64 __try
          __leave __wchar_t __w64 __virtual_inheritance __uuidof
          __unaligned __super __single_inheritance __raise __noop
          __multiple_inheritance __m128i __m128d __m128 __m64 __interface
          __identifier __forceinline __event __assume
          inline _inline __inline
          naked _naked __naked
          thread _thread __thread
        )
      end

      id = /[a-zA-Z_][a-zA-Z0-9]*/

      prepend :statements do
        rule /class\b/, Keyword, :classname
        # Offload C++ extensions, http://offload.codeplay.com/
        rule /(?:__offload|__blockingoffload|__outer)\b/, Keyword::Pseudo
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
