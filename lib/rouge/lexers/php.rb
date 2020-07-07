# -*- coding: utf-8 -*- #
# frozen_string_literal: true

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

      option :start_inline, 'Whether to start with inline php or require <?php ... ?>. (default: best guess)'
      option :funcnamehighlighting, 'Whether to highlight builtin functions (default: true)'
      option :disabledmodules, 'Disable certain modules from being highlighted as builtins (default: empty)'

      def initialize(*)
        super

        # if truthy, the lexer starts highlighting with php code
        # (no <?php required)
        @start_inline = bool_option(:start_inline) { :guess }
        @funcnamehighlighting = bool_option(:funcnamehighlighting) { true }
        @disabledmodules = list_option(:disabledmodules)
      end

      def self.detect?(text)
        return true if text.shebang?('php')
        return false if /^<\?hh/ =~ text
        return true if /^<\?php/ =~ text
      end

      def self.keywords
        # - isset, unset and empty are actually keywords (directly handled by PHP's lexer but let's pretend these are functions, you use them like so)
        # - self and parent are kind of keywords, they are not handled by PHP's lexer
        # - use, const, namespace and function are handled by specific rules to highlight what's next to the keyword
        @keywords ||= Set.new %w(
          old_function cfunction
          __class__ __dir__ __file__ __function__ __halt_compiler __line__
          __method__ __namespace__ __trait__ abstract and array as break
          case catch clone continue declare default die do echo else
          elseif enddeclare endfor endforeach endif endswitch endwhile eval
          exit extends final finally fn for foreach global goto if implements
          include include_once instanceof insteadof list new or parent print
          private protected public require require_once return self static
          switch throw try var while xor yield
        )
      end

      def self.builtins
        Kernel::load File.join(Lexers::BASE_DIR, 'php/keywords.rb')
        builtins
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

      # source: http://php.net/manual/en/language.variables.basics.php
      # the given regex is invalid utf8, so... we're using the unicode
      # "Letter" property instead.
      id = /[\p{L}_][\p{L}\p{N}_]*/
      ns = /(?:#{id}\\)+/
      id_with_ns = /(?:#{ns})?#{id}/

      start do
        case @start_inline
        when true
          push :php
        when :guess
          push :start
        end
      end

      state :escape do
        rule %r/\?>/ do
          token Comment::Preproc
          reset_stack
        end
      end

      state :return do
        rule(//) { pop! }
      end

      state :start do
        # some extremely rough heuristics to decide whether to start inline or not
        rule(/\s*(?=<)/m) { delegate parent; pop! }
        rule(/[^$]+(?=<\?(php|=))/i) { delegate parent; pop! }

        rule(//) { goto :php }
      end

      state :names do
        rule %r/#{id_with_ns}(?=\s*\()/ do |m|
          name = m[0].downcase
          if self.class.keywords.include? name
            token Keyword
          elsif self.builtins.include? name
            token Name::Builtin
          else
            token Name::Function
          end
        end

        rule id_with_ns do |m|
          name = m[0].downcase
          if self.class.keywords.include? name
            token Keyword
          elsif m[0] =~ /^__.*?__$/
            token Name::Builtin
          elsif m[0] =~ /^(E|PHP)(_[[:upper:]]+)+$/
            token Keyword::Constant
          elsif m[0] =~ /(\\|^)[[:upper:]][[[:upper:]][[:digit:]]_]+$/
            token Name::Constant
          elsif m[0] =~ /(\\|^)[[:upper:]][[:alnum:]]*?$/
            token Name::Class
          else
            token Name
          end
        end
      end

      state :operators do
        rule %r/[~!%^&*+\|:.<>\/@-]+/, Operator
      end

      state :string do
        rule %r/"/, Str::Double, :pop!
        rule %r/[^\\{$"]+/, Str::Double
        rule %r/\\u\{[0-9a-fA-F]+\}/, Str::Escape
        rule %r/\\([efrntv\"$\\]|[0-7]{1,3}|[xX][0-9a-fA-F]{1,2})/, Str::Escape
        rule %r/\$#{id}(\[\S+\]|->#{id})?/, Name::Variable

        rule %r/\{\$\{/, Str::Interpol, :string_interp_double
        rule %r/\{(?=\$)/, Str::Interpol, :string_interp_single
        rule %r/(\{)(\S+)(\})/ do
          groups Str::Interpol, Name::Variable, Str::Interpol
        end

        rule %r/[${\\]+/, Str::Double
      end

      state :string_interp_double do
        rule %r/\}\}/, Str::Interpol, :pop!
        mixin :php
      end

      state :string_interp_single do
        rule %r/\}/, Str::Interpol, :pop!
        mixin :php
      end

      state :values do
        # heredocs
        rule %r/<<<(["']?)(#{id})\1\n.*?\n\s*\2;?/im, Str::Heredoc

        # numbers
        rule %r/(\d[_\d]*)?\.(\d[_\d]*)?(e[+-]?\d[_\d]*)?/i, Num::Float
        rule %r/0[0-7][0-7_]*/, Num::Oct
        rule %r/0b[01][01_]*/i, Num::Bin
        rule %r/0x[a-f0-9][a-f0-9_]*/i, Num::Hex
        rule %r/\d[_\d]*/, Num::Integer

        # strings
        rule %r/'([^'\\]*(?:\\.[^'\\]*)*)'/, Str::Single
        rule %r/`([^`\\]*(?:\\.[^`\\]*)*)`/, Str::Backtick
        rule %r/"/, Str::Double, :string

        # functions
        rule %r/function\b/i do
          push :in_function_return
          push :in_function_params
          push :in_function_name
          token Keyword
        end

        # constants
        rule %r/(true|false|null)\b/i, Keyword::Constant
      end

      state :variables do
        rule %r/\$\{\$+#{id}\}/, Name::Variable
        rule %r/\$+#{id}/, Name::Variable
      end

      state :whitespace do
        rule %r/\s+/, Text
        rule %r/#.*?$/, Comment::Single
        rule %r(//.*?$), Comment::Single
        rule %r(/\*\*(?!/).*?\*/)m, Comment::Doc
        rule %r(/\*.*?\*/)m, Comment::Multiline
      end

      state :root do
        rule %r/<\?(php|=)?/i, Comment::Preproc, :php
        rule(/.*?(?=<\?)|.*/m) { delegate parent }
      end

      state :php do
        mixin :escape

        mixin :whitespace
        mixin :values
        mixin :variables

        rule %r/use\b/i, Keyword::Namespace, :in_use
        rule %r/namespace\b/i, Keyword::Namespace, :in_namespace
        rule %r/const\b/i, Keyword, :in_const
        rule %r/catch\b/i, Keyword, :in_catch
        rule %r/new\b/i, Keyword, :in_new
        rule %r/(class|interface|trait|extends|implements)\b/i, Keyword::Declaration, :in_declaration
        rule %r/stdClass\b/, Name::Class

        mixin :names

        rule %r/[;,\(\)\{\}\[\]]/, Punctuation

        mixin :operators
        rule %r/[=?]/, Operator
      end

      state :in_assign do
        rule %r/,/, Punctuation, :pop!
        rule %r/[\[\]]/, Punctuation
        rule %r/\(/, Punctuation, :in_assign_function
        mixin :escape
        mixin :whitespace
        mixin :values
        mixin :variables
        mixin :names
        mixin :operators
        mixin :return
      end

      state :in_assign_function do
        rule %r/\)/, Punctuation, :pop!
        rule %r/,/, Punctuation
        mixin :in_assign
      end

      state :in_catch do
        rule %r/\(/, Punctuation
        rule %r/\|/, Operator
        rule id, Name::Class
        mixin :escape
        mixin :whitespace
        mixin :return
      end

      state :in_const do
        rule id, Name::Constant
        rule %r/=/, Operator, :in_assign
        mixin :escape
        mixin :whitespace
        mixin :return
      end

      state :in_declaration do
        rule id_with_ns, Name::Class, :pop!
        mixin :escape
        mixin :whitespace
        mixin :return
      end

      state :in_function_body do
        rule %r/{/, Punctuation, :push
        rule %r/}/, Punctuation, :pop!
        mixin :php
      end

      state :in_function_name do
        rule %r/&/, Operator
        rule id, Name
        rule %r/\(/, Punctuation, :pop!
        mixin :escape
        mixin :whitespace
        mixin :return
      end

      state :in_function_params do
        rule %r/\)/, Punctuation, :pop!
        rule %r/,/, Punctuation
        rule %r/=/, Operator, :in_assign
        rule %r/\??#{id}/, Keyword::Type, :in_assign
        mixin :escape
        mixin :whitespace
        mixin :variables
        mixin :return
      end

      state :in_function_return do
        rule %r/:/, Punctuation
        rule %r/use\b/i, Keyword, :in_function_use
        rule %r/\??#{id}/, Keyword::Type, :in_assign
        rule %r/\{/ do
          token Punctuation
          goto :in_function_body
        end
        mixin :escape
        mixin :whitespace
        mixin :return
      end

      state :in_function_use do
        rule %r/[,\(]/, Punctuation
        rule %r/&/, Operator
        rule %r/\)/, Punctuation, :pop!
        mixin :escape
        mixin :whitespace
        mixin :variables
        mixin :return
      end

      state :in_namespace do
        rule id_with_ns, Name::Namespace, :pop!
        mixin :escape
        mixin :whitespace
        mixin :return
      end

      state :in_new do
        rule %r/class\b/i, Keyword::Declaration, :pop!
        rule id_with_ns, Name::Class, :pop!
        mixin :escape
        mixin :whitespace
        mixin :return
      end

      state :in_use do
        rule %r/[,\}]/, Punctuation
        rule %r/(function|const)\b/i, Keyword
        rule %r/(#{ns})(\{)/ do
          groups Name::Namespace, Punctuation
        end
        rule %r/#{id_with_ns}(_#{id})+/, Name::Function
        mixin :escape
        mixin :whitespace
        mixin :names
        mixin :return
      end
    end
  end
end
