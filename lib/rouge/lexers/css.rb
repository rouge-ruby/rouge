# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class CSS < RegexLexer
      title "CSS"
      desc "Cascading Style Sheets, used to style web pages"

      tag 'css'
      filenames '*.css'
      mimetypes 'text/css'

      lazy { require_relative 'css/builtins' }

      # Documentation: https://www.w3.org/TR/CSS21/syndata.html#characters

      # [jneen] workaround for:
      # https://bugs.ruby-lang.org/issues/21870#change-116371
      #
      # As of ruby 4+, \p{Word} matches ZWJ and ZWNJ, so the additional
      # \p{Cf} is not needed.
      #
      # That being said... this still warns, but at least it's only once?
      identifier = if RUBY_VERSION < '4'
        /[\p{L}_-][\p{Word}\p{Cf}-]*/
      else
        /[\p{L}_-][\p{Word}-]*/
      end

      number = /-?(?:[0-9]+(\.[0-9]+)?|\.[0-9]+)/

      # source: http://www.w3.org/TR/CSS21/syndata.html#vendor-keyword-history
      VENDOR_PREFIXES = %w(
        -ah- -atsc- -hp- -khtml- -moz- -ms- -o- -rim- -ro- -tc- -wap-
        -webkit- -xv- mso- prince-
      )

      state :root do
        mixin :basics
        rule %r/{/, Punctuation, :stanza
        rule %r/:[:]?#{identifier}/, Name::Decorator
        rule %r/\.#{identifier}/, Name::Class
        rule %r/##{identifier}/, Name::Function
        rule %r/@#{identifier}/, Keyword, :at_rule
        rule identifier, Name::Tag
        rule %r([~^*!%&\[\]()<>|+=@:;,./?-]), Operator
        rule %r/"(\\\\|\\"|[^"])*"/, Str::Single
        rule %r/'(\\\\|\\'|[^'])*'/, Str::Double
        rule %r/[0-9]{1,3}\%/, Num
      end

      state :value do
        mixin :basics
        rule %r/#[0-9a-f]{3,8}/i, Name::Other # colors
        rule %r/#{number}(?:%|(?:px|pt|pc|in|cm|mm|Q|em|rem|ex|ch|vw|vh|vmin|vmax|fr|dpi|dpcm|dppx|deg|grad|rad|turn|s|ms|Hz|kHz)\b)?/, Num
        rule %r/[\[\]():.,]/, Punctuation
        rule %r/"(\\\\|\\"|[^"])*"/, Str::Single
        rule %r/'(\\\\|\\'|[^'])*'/, Str::Double
        rule %r/(true|false)/i, Name::Constant
        rule %r/\-\-#{identifier}/, Literal
        rule %r([*+/-]), Operator
        rule %r/(url(?:-prefix)?)([(])(.*?)([)])/ do
          groups Name::Function, Punctuation, Str::Other, Punctuation
        end

        keywords identifier do
          transform(&:downcase)

          rule COLORS, Name::Other
          rule BUILTINS, Name::Builtin
          rule FUNCTIONS, Name::Function
          default Name
        end
      end

      state :at_rule do
        rule %r/(?:<=|>=|~=|\|=|\^=|\$=|\*=|<|>|=)/, Operator
        rule %r/{(?=\s*#{identifier}\s*:)/m, Punctuation, :at_stanza
        rule %r/{/, Punctuation, :at_body
        rule %r/;/, Punctuation, :pop!
        mixin :value
      end

      state :at_body do
        mixin :at_content
        mixin :root
      end

      state :at_stanza do
        mixin :at_content
        mixin :stanza
      end

      state :at_content do
        rule %r/}/ do
          token Punctuation
          pop! 2
        end
      end

      state :basics do
        rule %r/\s+/m, Text
        rule %r(/\*(?:.*?)\*/)m, Comment
      end

      state :stanza do
        mixin :basics
        rule %r/}/, Punctuation, :pop!

        rule %r/(#{identifier})(\s*)(:)/m do |m|
          name_tok = if PROPERTIES.include? m[1]
            Name::Label
          elsif VENDOR_PREFIXES.any? { |p| m[1].start_with?(p) }
            Name::Label
          else
            Name::Property
          end

          groups name_tok, Text, Punctuation

          push :stanza_value
        end

        mixin :root
      end

      state :stanza_value do
        rule %r/;/, Punctuation, :pop!
        rule(/(?=})/) { pop! }
        rule %r/!\s*important\b/, Comment::Preproc
        rule %r/^@.*?$/, Comment::Preproc
        mixin :value
      end
    end
  end
end
