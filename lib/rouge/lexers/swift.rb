module Rouge
  module Lexers
    class CSharp < RegexLexer
      tag 'swift'
      aliases 'apple_swift'
      filenames '*.swift'
      mimetypes 'text/x-swift' # TODO: this has to be revised

      desc 'Multi paradigm, compiled programming language developed by Apple for iOS and OS X development.' # From Wikipedia.

      # TODO: support more of unicode
      id = /\#?[_a-z]\w*/i

      keywords = %w(
        class deinit enum extension func import init let protocol static struct subscript typealias var 
        
        break case continue default do else fallthrough if in for return switch where while
        
        as dynamicType is new super self Self Type __COLUMN__ __FILE__ __FUNCTION__ __LINE__
        
        associativity didSet get infix inout left mutating none nonmutating operator override postfix precedence prefix right set unowned unowned(safe) unowned(unsafe) weak willSet
      )

      keywords_type = %w(
        Int8 Int16 Int32 Int64 UInt8 UInt16 UInt32 UInt64 Int
        Double Float
        Bool 
        String Character 
      )

      state :whitespace do
        rule /\s+/m, Text
        rule %r(\/\/.*?\n), Comment::Single
        rule %r(\/[*].*?[*]\/)m, Comment::Multiline
      end

      state :root do
        mixin :whitespace
        rule /\$(([1-9]\d*)?\d)/, Name::Variable

        rule %r{[~!%^&*()+=|\[\]{}:;,.<>\/?-]}, Punctuation
        rule /!=|==|<<|>>|[-~+\/*%=<>&^|.]/, Operator
        rule /@"(\\.|.)*?"/, Str
        rule /"(\\.|.)*?["\n]/, Str
        rule /'(\\.|.)'/, Str::Char
        rule /(\d+\*|\d*\.\d+)(e[+-]?[0-9]+)?/i, Num::Float
        rule /\d+e[+-]?[0-9]+/i, Num::Float
        rule /0_?[0-7]+(?:_[0-7]+)*/, Num::Oct
        rule /0x[0-9A-Fa-f]+(?:_[0-9A-Fa-f]+)*/, Num::Hex
        rule /0b[01]+(?:_[01]+)*/, Num::Bin
        rule %r{[\d]+(?:_\d+)*}, Num::Integer
        
        rule %r{\b(#{keywords.join('|')})\b}, Keyword
        rule %r{\b(#{keywords_type.join('|')})\b}, Keyword::Type
        rule /class|struct|enum/, Keyword, :class
        rule /(?!\b(if|while|for)\b)\b\w+(?=\s*\()/, Name::Function
        rule id, Name
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
