# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class MXML < RegexLexer
      title "MXML"
      desc "MXML"
      tag 'mxml'
      filenames '*.mxml'
      mimetypes 'application/xv+xml'

      state :root do
        mixin :xml_root
      end

      state :xml_root do
        rule /[^<&]+/, Text
        rule /&\S*?;/, Name::Entity
        rule /<!\[CDATA\[/, Comment::Preproc, :actionscript
        rule /<!--/, Comment, :xml_comment
        rule /<\?.*?\?>/, Comment::Preproc
        rule /<![^>]*>/, Comment::Preproc

        # open tags
        rule %r(<\s*[\w:.-]+)m, Name::Tag, :xml_tag

        # self-closing tags
        rule %r(<\s*/\s*[\w:.-]+\s*>)m, Name::Tag
      end

      state :xml_comment do
        rule /[^-]+/m, Comment
        rule /-->/, Comment, :xml_root
        rule /-/, Comment
      end

      state :xml_tag do
        rule /\s+/m, Text
        rule /[\w.:-]+\s*=/m, Name::Attribute, :xml_attribute
        rule %r(/?\s*>), Name::Tag, :xml_root
      end

      state :xml_attribute do
        rule /\s+/m, Text
        rule /"{|"@{/, Str, :actionscript
        rule /".*?"|'.*?'|[^\s>]+/, Str, :xml_tag
      end

      state :actionscript do
        rule /\]\]\>/ do
          token Comment::Preproc
          goto :xml_root
        end
        
        rule /\}"/ do
          token Str
          goto :xml_tag
        end
        
        mixin :actionscript_root
      end
      
      def self.keywords
        @keywords ||= Set.new %w(
          for in while do break return continue switch case default
          if else throw try catch finally new delete typeof is
          this with
        )
      end

      def self.declarations
        @declarations ||= Set.new %w(var with function)
      end

      def self.reserved
        @reserved ||= Set.new %w(
          dynamic final internal native public protected private class const
          override static package interface extends implements namespace
          set get import include super flash_proxy object_proxy trace
        )
      end

      def self.constants
        @constants ||= Set.new %w(true false null NaN Infinity undefined)
      end

      def self.builtins
        @builtins ||= %w(
          void Function Math Class
          Object RegExp decodeURI
          decodeURIComponent encodeURI encodeURIComponent
          eval isFinite isNaN parseFloat parseInt this
        )
      end

      id = /[$a-zA-Z_][a-zA-Z0-9_]*/
      
      state :actionscript_root do
        rule /\A\s*#!.*?\n/m, Comment::Preproc, :actionscript_statement
        rule /\n/, Text, :actionscript_statement
        rule %r((?<=\n)(?=\s|/|<!--)), Text, :actionscript_expr_start
        mixin :actionscript_comments_and_whitespace
        rule %r(\+\+ | -- | ~ | && | \|\| | \\(?=\n) | << | >>>? | ===
               | !== )x,
          Operator, :actionscript_expr_start
        rule %r([:-<>+*%&|\^/!=]=?), Operator, :actionscript_expr_start
        rule /[(\[,]/, Punctuation, :actionscript_expr_start
        rule /;/, Punctuation, :actionscript_statement
        rule /[)\].]/, Punctuation

        rule /[?]/ do
          token Punctuation
          push :actionscript_ternary
          push :actionscript_expr_start
        end

        rule /[{}]/, Punctuation, :actionscript_statement

        rule id do |m|
          if self.class.keywords.include? m[0]
            token Keyword
            push :actionscript_expr_start
          elsif self.class.declarations.include? m[0]
            token Keyword::Declaration
            push :actionscript_expr_start
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

        rule /\-?[0-9][0-9]*\.[0-9]+([eE][0-9]+)?[fd]?/, Num::Float
        rule /0x[0-9a-fA-F]+/, Num::Hex
        rule /\-?[0-9]+/, Num::Integer
        rule /"(\\\\|\\"|[^"])*"/, Str::Double
        rule /'(\\\\|\\'|[^'])*'/, Str::Single
      end
    
      state :actionscript_comments_and_whitespace do
        rule /\s+/, Text
        rule %r(//.*?$), Comment::Single
        rule %r(/\*.*?\*/)m, Comment::Multiline
      end

      state :actionscript_expr_start do
        mixin :actionscript_comments_and_whitespace

        rule %r(/) do
          token Str::Regex
          goto :actionscript_regex
        end

        rule /[{]/, Punctuation, :actionscript_object

        rule //, Text, :pop!
      end

      state :actionscript_regex do
        rule %r(/) do
          token Str::Regex
          goto :actionscript_regex_end
        end

        rule %r([^/]\n), Error, :pop!

        rule /\n/, Error, :pop!
        rule /\[\^/, Str::Escape, :actionscript_regex_group
        rule /\[/, Str::Escape, :actionscript_regex_group
        rule /\\./, Str::Escape
        rule %r{[(][?][:=<!]}, Str::Escape
        rule /[{][\d,]+[}]/, Str::Escape
        rule /[()?]/, Str::Escape
        rule /./, Str::Regex
      end

      state :actionscript_regex_end do
        rule /[gim]+/, Str::Regex, :pop!
        rule(//) { pop! }
      end

      state :actionscript_regex_group do
        # specially highlight / in a group to indicate that it doesn't
        # close the regex
        rule /\//, Str::Escape

        rule %r([^/]\n) do
          token Error
          pop! 2
        end

        rule /\]/, Str::Escape, :pop!
        rule /\\./, Str::Escape
        rule /./, Str::Regex
      end

      state :actionscript_bad_regex do
        rule /[^\n]+/, Error, :pop!
      end

      # braced parts that aren't object literals
      state :actionscript_statement do
        rule /(#{id})(\s*)(:)/ do
          groups Name::Label, Text, Punctuation
        end

        rule /[{}]/, Punctuation

        mixin :actionscript_expr_start
      end

      # object literals
      state :actionscript_object do
        mixin :actionscript_comments_and_whitespace
        rule /[}]/ do
          token Punctuation
          goto :actionscript_statement
        end

        rule /(#{id})(\s*)(:)/ do
          groups Name::Attribute, Text, Punctuation
          push :actionscript_expr_start
        end

        rule /:/, Punctuation
        mixin :actionscript
      end

      # ternary expressions, where <id>: is not a label!
      state :actionscript_ternary do
        rule /:/ do
          token Punctuation
          goto :actionscript_expr_start
        end

        mixin :actionscript
      end
    end
  end
end
