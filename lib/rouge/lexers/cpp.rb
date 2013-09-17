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
        @keywords ||= super + Set.new(%w(
          asm catch const_cast delete dynamic_cast explicit export
          friend mutable namespace new operator private protected public
          reinterpret_cast restrict static_cast template this throw
          throws typeid typename using virtual
        ))
      end

      def self.reserved
        @reserved ||= super + Set.new(%w(
          __virtual_inheritance __uuidof __super __single_inheritance
          __multiple_inheritance __interface __event
        ))
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
