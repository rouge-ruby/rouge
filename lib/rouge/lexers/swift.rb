# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Swift < RegexLexer
      tag 'swift'
      filenames '*.swift'

      desc 'Multi paradigm, compiled programming language developed by Apple for iOS and OS X development. (developer.apple.com/swift)'

      id_head = /_|(?!\p{Mc})\p{Alpha}|[^\u0000-\uFFFF]/
      id_rest = /[\p{Alnum}_]|[^\u0000-\uFFFF]/
      id = /#{id_head}#{id_rest}*/

      def self.keywords
        @keywords ||= Set.new %w(
          break case continue default do else fallthrough if in for return switch where while

          as dynamicType is new super self Self Type __COLUMN__ __FILE__ __FUNCTION__ __LINE__

          associativity didSet get infix inout left mutating none nonmutating operator override postfix precedence prefix right set unowned unowned(safe) unowned(unsafe) weak willSet
        )
      end

      def self.declarations
        @declarations ||= Set.new %w(
          class deinit enum extension final func import init internal lazy let optional private protocol public required static struct subscript typealias var dynamic
        )
      end

      def self.at_keywords
        @at_keywords ||= %w(
          autoclosure IBAction IBDesignable IBInspectable IBOutlet noreturn NSCopying NSManaged objc UIApplicationMain
        )
      end

      def self.types
        @types ||= Set.new %w(
          Int8 Int16 Int32 Int64 UInt8 UInt16 UInt32 UInt64 Int
          Double Float
          Bool
          String Character
          AnyObject Any
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

        rule %r{[()\[\]{}:;,?]}, Punctuation
        rule %r([-/=+*%<>!&|^.~]+), Operator
        rule /@?"/, Str, :dq
        rule /'(\\.|.)'/, Str::Char
        rule /(\d+\*|\d*\.\d+)(e[+-]?[0-9]+)?/i, Num::Float
        rule /\d+e[+-]?[0-9]+/i, Num::Float
        rule /0_?[0-7]+(?:_[0-7]+)*/, Num::Oct
        rule /0x[0-9A-Fa-f]+(?:_[0-9A-Fa-f]+)*/, Num::Hex
        rule /0b[01]+(?:_[01]+)*/, Num::Bin
        rule %r{[\d]+(?:_\d+)*}, Num::Integer

        rule /(?!\b(if|while|for|private|internal|@objc)\b)\b#{id}(?=\s*[(])/, Name::Function

        rule /(#?(?!default)#{id})(\s*)(:)/ do
          groups Name::Variable, Text, Punctuation
        end

        rule /(let|var)\b(\s*)(#{id})/ do
          groups Keyword, Text, Name::Variable
        end

        rule /@(#{id})/ do |m|
          if m[1] == 'objc'
            token Keyword::Declaration
            push :objc_setting
          elsif self.class.at_keywords.include? m[1]
            token Keyword
          else
            token Error
          end
        end

        rule id do |m|
          if self.class.keywords.include? m[0]
            token Keyword
          elsif self.class.declarations.include? m[0]
            token Keyword::Declaration
            if %w(private internal).include? m[0]
              push :access_control_setting
            elsif %w(protocol class extension struct enum).include? m[0]
              push :type_definition
            end
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
      
      state :access_control_setting do
        rule /\( *(\w+) *\)/ do |m|
          if m[1] == 'set'
            token Keyword::Declaration
          else
            token Error
          end
        end
        rule(//) { pop! }
      end
      
      state :objc_setting do
        rule /(\( *)(\w+)( *\))/ do |m|
          groups Keyword::Declaration, Name::Class, Keyword::Declaration
        end
        rule(//) { pop! }
      end

      state :dq do
        rule /\\[\\0tnr'"]/, Str::Escape
        rule /\\[(]/, Str::Escape, :interp
        rule /\\u\{\h{1,8}\}/, Str::Escape
        rule /[^\\"]+/, Str
        rule /"/, Str, :pop!
      end

      state :interp do
        rule /[(]/, Punctuation, :interp_inner
        rule /[)]/, Str::Escape, :pop!
        mixin :root
      end

      state :interp_inner do
        rule /[(]/, Punctuation, :push
        rule /[)]/, Punctuation, :pop!
        mixin :root
      end

      state :type_definition do
        mixin :whitespace
        rule id, Name::Constant, :pop!
      end

      state :namespace do
        mixin :whitespace
        rule /(?=[(])/, Text, :pop!
        rule /(#{id}|[.])+/, Name::Namespace, :pop!
      end
    end
  end
end
