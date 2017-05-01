# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Actionscript < RegexLexer
      title "ActionScript"
      desc "ActionScript 3 (https://www.adobe.com/go/as3lr)"

      tag 'actionscript'
      aliases 'as', 'as3'
      filenames '*.as'
      mimetypes 'application/x-actionscript', 'text/x-actionscript'

      state :comments_and_whitespace do
        rule %r(\s+), Text
        rule %r(//.*?$), Comment::Single
        rule %r(/\*\*.*?\*/)m, Comment::Doc
        rule %r(/\*.*?\*/)m, Comment::Multiline
      end

      state :expr_start do
        mixin :comments_and_whitespace

        rule %r(/) do
          token Str::Regex
          goto :regex
        end

        rule %r([{]), Punctuation, :object

        rule %r(), Text, :pop!
      end

      state :regex do
        rule %r(/) do
          token Str::Regex
          goto :regex_end
        end

        rule %r([^/]\n), Error, :pop!

        rule %r(\n), Error, :pop!
        rule %r(\[\^), Str::Escape, :regex_group
        rule %r(\[), Str::Escape, :regex_group
        rule %r(\\.), Str::Escape
        rule %r{[(][?][:=<!]}, Str::Escape
        rule %r([{][\d,]+[}]), Str::Escape
        rule %r([()?]), Str::Escape
        rule %r(.), Str::Regex
      end

      state :regex_end do
        rule %r([gim]+), Str::Regex, :pop!
        rule(//) { pop! }
      end

      state :regex_group do
        # specially highlight / in a group to indicate that it doesn't
        # close the regex
        rule %r(\/), Str::Escape

        rule %r([^/]\n) do
          token Error
          pop! 2
        end

        rule %r(\]), Str::Escape, :pop!
        rule %r(\\.), Str::Escape
        rule %r(.), Str::Regex
      end

      state :bad_regex do
        rule %r([^\n]+), Error, :pop!
      end

      def self.keywords
        @keywords ||= Set.new %w(
          break case continue default do else for each in if label
          return super switch throw try catch finally while with

          delete is new typeof
        )
      end

      def self.constants
        @constants ||= Set.new %w(
          false Infinity NaN null this true undefined
        )
      end

      def self.declarations
        @declarations ||= Set.new %w(
          class const extends function get implements
          interface namespace package set var
        )
      end

      def self.reserved
        @reserved ||= Set.new %w(
          import include flash_proxy object_proxy
        )
      end

      def self.types
        @types ||= Set.new %w(
          ArgumentError Array Boolean Class Date DefinitionError Error
          EvalError Function int JSON Math Namespace Number Null Object QName
          RangeError ReferenceError RegExp SecurityError String SyntaxError
          TypeError uint void URIError Vector VerifyError XML XMLList
        )
      end

      def self.attributes
        @attributes ||= Set.new %w(
          dynamic final internal native override
          private protected public static
        )
      end

      def self.builtins
        @builtins ||= Set.new %w(
          arguments decodeURI decodeURIComponent encodeURI encodeURIComponent
          escape isFinite isNaN isXMLName parseFloat parseInt trace unescape
        )
      end

      id = %r([$a-zA-Z_][a-zA-Z0-9_]*)

      state :root do
        rule %r(\A\s*#!.*?\n)m, Comment::Preproc, :statement
        rule %r(\n), Text, :statement
        rule %r((?<=\n)(?=\s|/|<!--)), Text, :expr_start
        mixin :comments_and_whitespace
        rule %r(\+\+ | -- | ~ | && | \|\| | \\(?=\n) | << | >>>? | === | !== )x, Operator, :expr_start
        rule %r([-<>+*%&|\^/!=]=?), Operator, :expr_start
        rule %r{[(\[,]}, Punctuation, :expr_start
        rule %r(;), Punctuation, :statement
        rule %r{[)\].]}, Punctuation
        rule %r(:), Punctuation

        rule %r([?]) do
          token Punctuation
          push :ternary
          push :expr_start
        end

        rule %r([{}]), Punctuation, :statement

        rule id do |m|
          if self.class.keywords.include? m[0]
            token Keyword
            push :expr_start
          elsif self.class.declarations.include? m[0]
            token Keyword::Declaration
            push :expr_start
          elsif self.class.attributes.include? m[0]
            token Name::Attribute
          elsif self.class.reserved.include? m[0]
            token Keyword::Reserved
          elsif self.class.constants.include? m[0]
            token Keyword::Constant
          elsif self.class.builtins.include? m[0]
            token Name::Builtin
          elsif self.class.types.include? m[0]
            token Keyword::Type
          else
            token Name::Other
          end
        end

        rule %r(\-?[0-9][0-9]*\.[0-9]+([eE][0-9]+)?[fd]?), Num::Float
        rule %r(0x[0-9a-fA-F]+), Num::Hex
        rule %r(\-?[0-9]+), Num::Integer
        rule %r("(\\\\|\\"|[^"])*"), Str::Double
        rule %r('(\\\\|\\'|[^'])*'), Str::Single
      end

      # braced parts that aren't object literals
      state :statement do
        rule %r((#{id})(\s*)(:)) do
          groups Name::Label, Text, Punctuation
        end

        rule %r([{}]), Punctuation

        mixin :expr_start
      end

      # object literals
      state :object do
        mixin :comments_and_whitespace
        rule %r([}]) do
          token Punctuation
          goto :statement
        end

        rule %r{(#{id})(\s*)(:)} do
          groups Name::Attribute, Text, Punctuation
          push :expr_start
        end

        rule %r(:), Punctuation
        mixin :root
      end

      # ternary expressions, where <id>: is not a label!
      state :ternary do
        rule %r(:) do
          token Punctuation
          goto :expr_start
        end

        mixin :root
      end
    end
  end
end
