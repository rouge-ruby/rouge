# encoding: utf-8

module Rouge
  module Lexers
    class Swift < RegexLexer
      tag 'swift'
      filenames '*.swift'
     
      desc 'Multi paradigm, compiled programming language developed by Apple for iOS and OS X development. (developer.apple.com/swift)'

      id = /([0-9]|[_#A-Z]|\u00A8\u00AA\u00AD\u00AF\u2054|[\u00B2-\u00B5]|[\u00B7-\u00BA]|[\u00BC–\u00BE]|[\u00C0–\u00D6]|[\u00D8–\u00F6]|[\u00F8–\u00FF]|[\u0100–\u02FF]|[\u0370–\u167F]|[\u1681–\u180D]|[\u180F–\u1DBF]|[\u1E00–\u1FFF]|[\u200B–\u200D]|[\u202A–\u202E]|[\u203F–\u2040]|[\u2060-\u206F]|[\u2070–\u20CF]|[\u2100–\u218F]|[\u2460–\u24FF]|[\u2776–\u2793]|[\u2C00–\u2DFF]|[\u2E80–\u2FFF]|[\u3004–\u3007]|[\u3021–\u302F]|[\u3031–\u303F]|[\u3040–\uD7FF]|[\uF900–\uFD3D]|[\uFD40–\uFDCF]|[\uFDF0–\uFE1F]|[\uFE30–\uFE44]|[\uFE47–\uFFFD]|[\u{10000}–\u{1FFFD}]|[\u{20000}–\u{2FFFD}]|[\u{30000}–\u{3FFFD}]|[\u{40000}–\u{4FFFD}]|[\u{50000}–\u{5FFFD}]|[\u{60000}–\u{6FFFD}]|[\u{70000}–\u{7FFFD}]|[\u{80000}–\u{8FFFD}]|[\u{90000}–\u{9FFFD}]|[\u{A0000}–\u{AFFFD}]|[\u{B0000}–\u{BFFFD}]|[\u{C0000}–\u{CFFFD}]|[\u{D0000}–\u{DFFFD}]|[\u{E0000}–\u{EFFFD}]|[\u0300–\u036F]|[\u1DC0–\u1DFF]|[\u20D0–\u20FF]|[\uFE20–\uFE2F]|[\u{10000}-\u{1FFFD}]|[\u{20000}-\u{2FFFD}]|[\u{30000}-\u{3FFFD}]|[\u{40000}-\u{4FFFD}]|[\u{50000}-\u{5FFFD}]|[\u{60000}-\u{6FFFD}]|[\u{70000}-\u{7FFFD}]|[\u{80000}-\u{8FFFD}]|[\u{90000}-\u{9FFFD}]|[\u{A0000}-\u{AFFFD}]|[\u{B0000}-\u{BFFFD}]|[\u{C0000}-\u{CFFFD}]|[\u{D0000}–\u{DFFFD}])+/i

      def self.keywords
        @keywords ||= Set.new %w(
          break case continue default do else fallthrough if in for return switch where while
          
          as dynamicType is new super self Self Type __COLUMN__ __FILE__ __FUNCTION__ __LINE__
          
          associativity didSet get infix inout left mutating none nonmutating operator override postfix precedence prefix right set unowned unowned(safe) unowned(unsafe) weak willSet
        )
      end

      def self.declarations
        @declarations ||= Set.new %w(
          class deinit enum extension func import init let protocol static struct subscript typealias var 
        )
      end

      def self.types
        @types ||= Set.new %w(
          Int8 Int16 Int32 Int64 UInt8 UInt16 UInt32 UInt64 Int
          Double Float
          Bool 
          String Character 
        )
      end

      def self.constants
        @constants ||= Set.new %w(
          true false nil
        )
      end

      state :whitespace do
        rule /\s+/m, Text
        rule %r(\/\/.*?\n), Comment::Single
        rule %r((?<re>\/\*(?:(?>[^\/\*\*\/]+)|\g<re>)*\*\/))m, Comment::Multiline
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
        
        rule /(?!\b(if|while|for)\b)\b\w+(?=\s*\()/, Name::Function
        
        rule id do |m|
          if self.class.keywords.include? m[0]
            token Keyword
          elsif self.class.declarations.include? m[0]
            token Keyword::Declaration
          elsif self.class.types.include? m[0]
            token Keyword::Type
          elsif self.class.constants.include? m[0]
            token Keyword::Constant
          else
            token Name
          end
        end
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
