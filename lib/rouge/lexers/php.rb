# -*- coding: utf-8 -*- #

# Rewritten from PHP's lexer (Zend/zend_language_scanner.l)
# C/re2c to ruby/rouge equivalents:
# - BEGIN(state) => goto(state)
# - yy_push_state(state) => push(state)
# - yy_pop_state() => pop!
# - yyless => a (positive) lookahead assertion (?=...)
#
# Note that third argument of RegexLexer#rule (if used) internally calls push, not goto
#
# Elements not handled:
# - asp_tags (<%=? ... %>) (removed by PHP 7.0.0)
# - "long" tags (<script language="php"> ... </script>) (also removed by PHP 7.0.0)
# - major part of keywords can be used as identifier (introduced by PHP 7.0.0)

module Rouge
  module Lexers
    class PHP < TemplateLexer
      title "PHP"
      desc "The PHP scripting language (php.net)"
      tag 'php'
      aliases 'php', 'php3', 'php4', 'php5'
      filenames '*.php', '*.php[345t]','*.phtml',
                # Support Drupal file extensions, see:
                # https://github.com/gitlabhq/gitlabhq/issues/8900
                '*.module', '*.inc', '*.profile', '*.install', '*.test'
      mimetypes 'text/x-php'

      default_options :parent => 'html'

      def initialize(opts={})
        # if truthy, the lexer starts highlighting with php code
        # (no <?php required)
        @start_inline = opts.delete(:start_inline)
        @short_open_tag = opts.delete(:short_open_tag) { true }
        @funcnamehighlighting = opts.delete(:funcnamehighlighting) { true }
        @disabledmodules = opts.delete(:disabledmodules) { [] }

        super(opts)
      end

      def self.builtins
        load Pathname.new(__FILE__).dirname.join('php/builtins.rb')
        self.builtins
      end

      def builtins
        return [] unless @funcnamehighlighting

        @builtins ||= Set.new.tap do |builtins|
          self.class.builtins.each do |mod, fns|
            next if @disabledmodules.include? mod
            builtins.merge(fns)
          end
        end
      end

      def start_inline?
        !!@start_inline
      end

      def short_open_tag?
        !!@short_open_tag
      end

      NUMBER_OCT = '0[0-7]+'
      NUMBER_BIN = '0[bB][01]+'
      NUMBER_HEX = '0[xX][a-fA-F0-9]+'
      NEWLINE = '(?:\r\n?|\n)'
      WHITESPACE = '[ \n\r\t]+'
      TABS_AND_SPACES = '(?:[ \t]*)'
      # not strictly equivalent, PHP permits *bytes* in range [0x7F;0xFF]
      LABEL_FIRST_CHAR = '[a-zA-Z_]'
      LABEL = "#{LABEL_FIRST_CHAR}[a-zA-Z0-9_]*"
      NAMESPACED_LABEL = "[\\\\]?#{LABEL}(?:[\\\\]#{LABEL})*"

      start do
        goto :in_scripting if start_inline?
      end

      def self.keywords
        @keywords ||= Set.new %w(
          and or as parent eval break exit case extends FALSE print for
          require continue foreach require_once declare return default
          static do switch die stdClass echo else TRUE elseif var empty
          if xor enddeclare include virtual endfor include_once while
          endforeach global __FILE__ endif list __LINE__ endswitch new
          endwhile not array final interface implements public private
          protected abstract clone try catch throw finally use namespace
          yield __NAMESPACE__ trait __TRAIT__ class const callable
          function insteadof __DIR__ goto __CLASS__ __FUNCTION__
          __METHOD__ __halt_compiler instanceof self
        )
      end

      def self.analyze_text(text)
        return 1 if text.shebang?('php')
        return 0.3 if /<\?(?!xml)/ =~ text
        0
      end

      ##### mixins to be included (DRY) #####

      # recognize variables (in regular php and interpolated string)
      state :common do
        rule /\$#{LABEL}/, Name::Variable
      end

      DEFAULTS = Hash.new(Error).tap do |h|
        h[:nowdoc] = Str::Heredoc
        h[:heredoc] = Str::Heredoc
        h[:backquote] = Str::Backtick
        h[:single_quotes] = Str::Single
        h[:double_quotes] = Str::Double
      end

      # assignment by default
      state :default do
        rule /#{NEWLINE}/ do
          token DEFAULTS[state.name.to_sym]
        end
        rule /./ do
          token DEFAULTS[state.name.to_sym]
        end
      end

      # common rules for variables interpolation (its use implies common mixin)
      state :interpolation do
        rule /\$\{/, Str::Interpol, :looking_for_varname
        rule /\{(?=\$)/, Str::Interpol, :in_scripting
        rule /\$#{LABEL}(?=->#{LABEL_FIRST_CHAR})/, Name::Variable, :looking_for_property
        rule /\$#{LABEL}(?=\[)/, Name::Variable, :var_offset

        # Unicode escaped sequences (\u{...}) (PHP >= 7)
        rule /\\u\{[0-9a-fA-F]+\}/, Str::Escape
        # regular octal (\0DD), hexadecimal (\xDD) and "named" (eg \n) sequences
        rule /\\0[0-9]{2}|\\[xX][0-9A-Fa-f]{2}|\\[$efrntv\\]/, Str::Escape
      end

      # handle end of (here|now)doc (its use implies default mixin)
      # "label" ending the (here|now)doc must be:
      # - at the beginning of the line (no indentation)
      # - followed by a ; then a newline even if it is the last instruction of the PHP block
      state :here_and_now_doc do
        rule /^(#{LABEL})(;?)(?=#{NEWLINE})/ do |m|
          if m[1] == @label
            groups Name::Constant, Punctuation
            goto :in_scripting
          else
            token DEFAULTS[state.name.to_sym]
          end
        end
      end

      ##### real lexer states #####

      state :root do
        rule /(<\?php)([ \t]|#{NEWLINE})/i do
          groups Comment::Preproc, Text
          goto :in_scripting
        end
        rule /<\?=?/ do |m|
          if '<?' == m[0] && !short_open_tag?
            delegate parent
          else
            token Comment::Preproc
            goto :in_scripting
          end
        end
        rule(/.*?(?=<\?)|.*/m) { delegate parent }
      end

      state :in_scripting do
        rule /\?>/ do
          token Comment::Preproc
          goto :root
        end
        rule /#{WHITESPACE}/, Text
        rule /#.*/, Comment::Single
        rule %r(//.*), Comment::Single
        # empty comment, otherwise seen as the start of a docstring
        rule %r(/\*\*/), Comment::Multiline
        rule %r(/\*\*#{WHITESPACE}.*?\*/)m, Str::Doc
        rule %r(/\*.*?\*/)m, Comment::Multiline

        rule /(::)(\s*)(#{LABEL})/ do
          groups Operator, Text, Name::Attribute
        end

        rule /\(#{TABS_AND_SPACES}(?:int(?:eger)?|real|double|float|string|binary|array|object|bool(?:ean)|unset)#{TABS_AND_SPACES}\)/i, Operator

        rule /[\[\]();,]+/, Punctuation

        rule /\{/, Punctuation, :in_scripting
        rule /}/ do
          pop!
          token state?(:in_scripting) ? Punctuation : Str::Interpol
        end

        rule /(class)(#{WHITESPACE})(#{LABEL})/i do
          groups Keyword, Text, Name::Class
        end

        # these two gives inconsistent results when preceded by "use". Eg:
        # use function A\B\c as foo, A\B\d as bar /* ... */;
        # A\B\c will be highlighted as Name::Function when A\B\d as Name::Other
        # (by rule /#{NAMESPACED_LABEL}/)
        # we can't rely on a negative lookbehind assertion (?<!use#{WHITESPACE})
        # to exclude this particular case as the number of #{WHITESPACE} is not
        # known nor fixed
=begin
        rule /(function)(#{WHITESPACE})(#{NAMESPACED_LABEL})/i do
          groups Keyword, Text, Name::Function
        end
        rule /(const)(#{WHITESPACE})(#{NAMESPACED_LABEL})/i do
          groups Keyword, Text, Name::Constant
        end
=end

        # anonymous functions
        rule /(function)(\s*)(?=\()/ do
          groups Keyword, Text
        end

        # yield from (PHP >= 7)
        rule /(yield)(#{WHITESPACE})(from)/i do
          groups Keyword, Text, Keyword
        end

        rule /(?:true|false|null)\b/i, Keyword::Constant
        # PHP 7.0: generalized typehinting
        # PHP 7.1: null allowed by prefixing type by a '?' + void (which is not nullable) and iterable added
        # from builtin_types in Zend/zend_compile.c
        rule /(?:void|\??(?:int|float|bool|string|iterable))\b/i, Keyword::Type
        # PHP 7.1: self and callable are keywords, handle them here as nullable types
        rule /\??(?:self|callable)\b/i, Keyword::Type

        rule /(\d+\.\d*|\d*\.\d+)(e[+-]?\d+)?/i, Num::Float
        rule /\d+e[+-]?\d+/i, Num::Float
        rule /#{NUMBER_OCT}/, Num::Oct
        rule /#{NUMBER_BIN}/, Num::Bin
        rule /#{NUMBER_HEX}/, Num::Hex
        rule /\d+/, Num::Integer

        rule /b?"/ do
          token Str::Double
          goto :double_quotes
        end
        rule /b?'/ do
          token Str::Single
          goto :single_quotes
        end
        rule /`/ do
          token Str::Backtick
          goto :backquote
        end
        rule /(b?<<<)(#{TABS_AND_SPACES})(["']?)(#{LABEL})(\3)(#{NEWLINE})/ do |m|
          @label = m[4]
          groups Operator, Text, Str::Heredoc, Name::Constant, Str::Heredoc, Text
          goto "'" == m[3] ? :nowdoc : :heredoc
        end

        rule /#{NAMESPACED_LABEL}/ do |m|
          token (
            if m[0].include? '\\'
              Name::Other
            else
              downcased = m[0].downcase
              if self.class.keywords.include? downcased
                Keyword
              elsif self.builtins.include? downcased
                Name::Builtin
              else
                Name::Other
              end
            end
          )
        end

        rule /->/, Operator, :looking_for_property
        # keep this last to not have precedence and create conflicts
        rule /[~!%^&*+=\|:.<>\/?@-]+/, Operator

        mixin :common
        mixin :default
      end

      # handles "short" (ie not surrounded by brackets)
      # interpolation of array or string variable offset (eg: "$foo[...]")
      state :var_offset do
        rule /\[/, Punctuation
        rule /]/, Punctuation, :pop!
        rule /#{NAMESPACED_LABEL}/, Name::Constant
        # non decimal integers are treated as strings
        rule /#{NUMBER_BIN}|#{NUMBER_OCT}|#{NUMBER_HEX}/, Str
        rule /0|[1-9]\d*/, Num::Integer

        mixin :common
        mixin :default
      end

      state :looking_for_property do
        rule /->/, Operator
        rule /#{LABEL}/, Name::Variable::Instance, :pop! # instance variable or method name (instance method call)
        rule /#{WHITESPACE}/, Text
        rule // do
          pop!
        end
      end

      state :looking_for_varname do
        rule /#{LABEL}(?=[\[}])/ do
          pop!
          push :in_scripting
          token Name::Variable
        end
        rule // do |m|
          pop!
          push :in_scripting
        end
      end

      state :nowdoc do
        mixin :here_and_now_doc
        mixin :default
      end

      state :heredoc do
        mixin :common
        mixin :interpolation
        mixin :here_and_now_doc
        mixin :default
      end

      state :backquote do
        mixin :common
        mixin :interpolation

        rule /\\[\\`]/, Str::Escape
        rule /`/ do
          token Str::Backtick
          goto :in_scripting
        end

        mixin :default
      end

      state :single_quotes do
        rule /\\[\\']/, Str::Escape
        rule /'/ do
          token Str::Single
          goto :in_scripting
        end

        mixin :default
      end

      state :double_quotes do
        mixin :interpolation
        mixin :common

        rule /\\[\\"]/, Str::Escape
        # end of (double quoted) string
        rule /"/ do
          token Str::Double
          goto :in_scripting
        end

        mixin :default
      end
    end
  end
end
