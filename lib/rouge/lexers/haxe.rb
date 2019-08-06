# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Haxe < RegexLexer
      title "Haxe"
      desc "Haxe Cross-platform Toolkit (http://haxe.org)"

      tag 'haxe'
      aliases 'hx', 'haxe'
      filenames '*.hx'
      mimetypes 'text/haxe', 'text/x-haxe', 'text/x-hx'

      def self.detect?(text)
        return true if text.shebang? "haxe"
      end

      def self.keywords
        @keywords ||= Set.new %w(
          break case cast catch class continue default do else enum false for
          function if import interface macro new null override package private
          public return switch this throw true try untyped while
        )
      end

      def self.imports
        @imports ||= Set.new %w(
          import using
        )
      end

      def self.declarations
        @declarations ||= Set.new %w(
          abstract dynamic extern extends implements inline
          static typedef var
        )
      end

      def self.reserved
        @reserved ||= Set.new %w(
          super trace inline build autoBuild enum
        )
      end

      def self.constants
        @constants ||= Set.new %w(true false null)
      end

      def self.builtins
        @builtins ||= %w(
          Void Dynamic Math Class Any Float Int UInt String StringTools Sys
          EReg isNaN parseFloat parseInt this Array Map Date DateTools Bool
          Lambda Reflect Std File FileSystem
        )
      end

      id = /[$a-zA-Z_][a-zA-Z0-9_]*/

      state :comments_and_whitespace do
        rule %r/\s+/, Text
        rule %r(//.*?$), Comment::Single
        rule %r(/\*.*?\*/)m, Comment::Multiline
      end

      state :expr_start do
        mixin :comments_and_whitespace

        rule %r(~) do
          token Str::Regex
          goto :regex
        end

        rule %r/[{]/, Punctuation, :object

        rule %r//, Text, :pop!
      end

      state :regex do
        rule %r(/) do
          token Str::Regex
          goto :regex_end
        end

        rule %r([^/]\n), Error, :pop!

        rule %r/\n/, Error, :pop!
        rule %r/\[\^/, Str::Escape, :regex_group
        rule %r/\[/, Str::Escape, :regex_group
        rule %r/\\./, Str::Escape
        rule %r{[(][?][:=<!]}, Str::Escape
        rule %r/[{][\d,]+[}]/, Str::Escape
        rule %r/[()?]/, Str::Escape
        rule %r/./, Str::Regex
      end

      state :regex_end do
        rule %r/[gim]+/, Str::Regex, :pop!
        rule(//) { pop! }
      end

      state :regex_group do
        # specially highlight / in a group to indicate that it doesn't
        # close the regex
        rule %r/\//, Str::Escape

        rule %r([^/]\n) do
          token Error
          pop! 2
        end

        rule %r/\]/, Str::Escape, :pop!
        rule %r/\\./, Str::Escape
        rule %r/./, Str::Regex
      end

      state :bad_regex do
        rule %r/[^\n]+/, Error, :pop!
      end

      state :root do
        rule %r/\n/, Text, :statement
        rule %r(\{), Text, :expr_start
        mixin :comments_and_whitespace
        rule %r(\+\+ | -- | ~ | && | \|\| | \\(?=\n) | << | >> | ==
               | != )x,
          Operator, :expr_start
        rule %r([-:<>+*%&|\^/!={}]=?), Operator, :expr_start
        rule %r/[(\[,]/, Punctuation, :expr_start
        rule %r/;/, Punctuation, :statement
        rule %r/[)\].]/, Punctuation

        rule %r/[?]/ do
          token Punctuation
          push :ternary
          push :expr_start
        end

        rule id do |m|
          if self.class.keywords.include? m[0]
            token Keyword
            push :expr_start
          elsif self.class.imports.include? m[0]
            token Keyword
            push :namespace
          elsif self.class.declarations.include? m[0]
            token Keyword::Declaration
            push :expr_start
          elsif self.class.reserved.include? m[0]
            token Keyword::Reserved
          elsif self.class.constants.include? m[0]
            token Keyword::Constant
          elsif self.class.builtins.include? m[0]
            token Name::Builtin
          else
            token Name::Other
          end
        end

        rule %r/\-?\d+\.\d+(?:[eE]\d+)?[fd]?/, Num::Float
        rule %r/0x\h+/, Num::Hex
        rule %r/\-?[0-9]+/, Num::Integer
        rule %r/"(\\\\|\\"|[^"])*"/, Str::Double
        rule %r/'(\\\\|\\'|[^'])*'/, Str::Single
      end

      # braced parts that aren't object literals
      state :statement do
        rule %r/(#{id})(\s*)(:)/ do
          groups Name::Label, Text, Punctuation
        end

        mixin :expr_start
      end

      # object literals
      state :object do
        mixin :comments_and_whitespace
        rule %r/[}]/ do
          token Punctuation
          goto :statement
        end

        rule %r/(#{id})(\s*)(:)/ do
          groups Name::Attribute, Text, Punctuation
          push :expr_start
        end

        rule %r/:/, Punctuation
        mixin :root
      end

      # ternary expressions, where <id>: is not a label!
      state :ternary do
        rule %r/:/ do
          token Punctuation
          goto :expr_start
        end

        mixin :root
      end
    end
  end
end
