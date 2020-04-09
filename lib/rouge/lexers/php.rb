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

      def reset_token
        @next_token = nil
      end

      # source: http://php.net/manual/en/language.variables.basics.php
      # the given regex is invalid utf8, so... we're using the unicode
      # "Letter" property instead.
      id = /[\p{L}_][\p{L}\p{N}_]*/
      id_with_ns_and_paren = /((?:#{id}\\?)+)(\s*)([(]?)/

      start do
        case @start_inline
        when true
          push :template
          push :php
        when false
          push :template
        when :guess
          # pass
        end
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

      def self.namespaces
        @namespaces ||= Set.new %w(namespace use)
      end

      def self.declarations
        @declarations ||= Set.new %w(class interface trait)
      end

      def self.detect?(text)
        return true if text.shebang?('php')
        return false if /^<\?hh/ =~ text
        return true if /^<\?php/ =~ text
      end

      state :root do
        # some extremely rough heuristics to decide whether to start inline or not
        rule(/\s*(?=<)/m) { delegate parent; push :template }
        rule(/[^$]+(?=<\?(php|=))/i) { delegate parent; push :template }

        rule(//) { push :template; push :php }
      end

      state :template do
        rule %r/<\?(php|=)?/i, Comment::Preproc, :php
        rule(/.*?(?=<\?)|.*/m) { delegate parent }
      end

      state :php do
        rule %r/\?>/ do
          @next_token = nil
          token Comment::Preproc
          pop!
        end

        # heredocs
        rule %r/<<<(["']?)(#{id})\1\n.*?\n\s*\2;?/im, Str::Heredoc

        # whitespace and comments
        rule %r/\s+/, Text
        rule %r/#.*?$/, Comment::Single
        rule %r(//.*?$), Comment::Single
        rule %r(/\*\*(?!/).*?\*/)m, Comment::Doc
        rule %r(/\*.*?\*/)m, Comment::Multiline

        rule %r/(->|::)(\s*)(#{id})/ do
          groups Operator, Text, Name::Attribute
        end

        rule %r/(void|\??(int|float|bool|string|iterable|self|callable))\b/i, Keyword::Type

        rule %r/[~!%^&*+=\|:.<>\/@-]+/, Operator
        rule %r/\?/, Operator

        rule %r/[;{]/ do
          token Punctuation
          @next_token = nil
        end
        rule %r/[\[\]}(),]/, Punctuation

        rule %r/stdClass\b/i, Name::Class
        rule %r/(true|false|null)\b/i, Keyword::Constant
        rule %r/(E|PHP)(_[[:upper:]]+)+\b/, Keyword::Constant
        rule %r/\$\{\$+#{id}\}/, Name::Variable
        rule %r/\$+#{id}/, Name::Variable
        rule %r/(yield)([ \n\r\t]+)(from)/i do
          groups Keyword, Text, Keyword
        end

        rule id_with_ns_and_paren do |m|
          name = m[1].downcase
          first = Name

          if self.class.namespaces.include? name
            first = Keyword::Namespace
            @next_token = Name::Namespace
          elsif self.class.declarations.include? name
            first = Keyword::Declaration
            @next_token = Name::Class
          elsif "const" == name
            first = Keyword
            @next_token = Name::Constant if @next_token.nil?
          elsif "function" == name
            first = Keyword
            @next_token = Name::Function
          elsif self.class.keywords.include? name
            first = Keyword
          elsif self.builtins.include? name
            first = Name::Builtin
          elsif @next_token == Name::Function
            first = Name::Function
            @next_token = nil
          elsif @next_token
            first = @next_token
          else
            if m[1] =~ /^[[:upper:]][[[:upper:]]\d_]+$/
              first = Name::Constant
            elsif m[1] =~ /^[[:upper:]][[:alnum:]]+?$/
              first = Name::Class
            elsif m[3] == "("
              first = Name::Function
            else
              first = Name
            end
          end

          groups first, Text, Punctuation
        end

        rule %r/(\d[_\d]*)?\.(\d[_\d]*)?(e[+-]?\d[_\d]*)?/i, Num::Float
        rule %r/0[0-7][0-7_]*/, Num::Oct
        rule %r/0b[01][01_]*/i, Num::Bin
        rule %r/0x[a-f0-9][a-f0-9_]*/i, Num::Hex
        rule %r/\d[_\d]*/, Num::Integer

        rule %r/'([^'\\]*(?:\\.[^'\\]*)*)'/, Str::Single
        rule %r/`([^`\\]*(?:\\.[^`\\]*)*)`/, Str::Backtick
        rule %r/"/, Str::Double, :string
      end

      state :string do
        rule %r/"/, Str::Double, :pop!
        rule %r/[^\\{$"]+/, Str::Double
        rule %r/\\u\{[0-9a-fA-F]+\}/, Str::Escape
        rule %r/\\([efrntv\"$\\]|[0-7]{1,3}|[xX][0-9a-fA-F]{1,2})/,
          Str::Escape
        rule %r/\$#{id}(\[\S+\]|->#{id})?/, Name::Variable

        rule %r/\{\$\{/, Str::Interpol, :interp_double
        rule %r/\{(?=\$)/, Str::Interpol, :interp_single
        rule %r/(\{)(\S+)(\})/ do
          groups Str::Interpol, Name::Variable, Str::Interpol
        end

        rule %r/[${\\]+/, Str::Double
      end

      state :interp_double do
        rule %r/\}\}/, Str::Interpol, :pop!
        mixin :php
      end

      state :interp_single do
        rule %r/\}/, Str::Interpol, :pop!
        mixin :php
      end
    end
  end
end
