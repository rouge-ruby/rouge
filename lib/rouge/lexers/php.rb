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

      # source: http://php.net/manual/en/language.variables.basics.php
      # the given regex is invalid utf8, so... we're using the unicode
      # "Letter" property instead.
      id = /[\p{L}_][\p{L}\p{N}_]*/
      nsid = /#{id}(?:\\#{id})*/

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
        # (echo parent ; echo self ; sed -nE 's/<ST_IN_SCRIPTING>"((__)?[[:alpha:]_]+(__)?)".*/\1/p' zend_language_scanner.l | tr '[A-Z]' '[a-z]') | sort -u | grep -Fwv -e isset -e unset -e empty -e const -e use -e function -e namespace
        # - isset, unset and empty are actually keywords (directly handled by PHP's lexer but let's pretend these are functions, you use them like so)
        # - self and parent are kind of keywords, they are not handled by PHP's lexer
        # - use, const, namespace and function are handled by specific rules to highlight what's next to the keyword
        # - class is also listed here, in addition to the rule below, to handle anonymous classes
        @keywords ||= Set.new %w(
          old_function cfunction
          __class__ __dir__ __file__ __function__ __halt_compiler
          __line__ __method__ __namespace__ __trait__ abstract and
          array as break callable case catch class clone continue
          declare default die do echo else elseif enddeclare
          endfor endforeach endif endswitch endwhile eval exit
          extends final finally fn for foreach global goto if
          implements include include_once instanceof insteadof
          interface list new or parent print private protected
          public require require_once return self static switch
          throw trait try var while xor yield
        )
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
        rule %r/\?>/, Comment::Preproc, :pop!
        # heredocs
        rule %r/<<<(["']?)(#{id})\1\n.*?\n\s*\2;?/im, Str::Heredoc
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
        rule %r/[\[\]{}();,]/, Punctuation
        rule %r/(class|interface|trait)(\s+)(#{nsid})/i do
          groups Keyword::Declaration, Text, Name::Class
        end
        rule %r/(use)(\s+)(function|const|)(\s*)(#{nsid})/i do
          groups Keyword::Namespace, Text, Keyword::Namespace, Text, Name::Namespace
          push :use
        end
        rule %r/(namespace)(\s+)(#{nsid})/i do
          groups Keyword::Namespace, Text, Name::Namespace
        end
        # anonymous functions
        rule %r/(function)(\s*)(?=\()/i do
          groups Keyword, Text
        end

        # named functions
        rule %r/(function)(\s+)(&?)(\s*)/i do
          groups Keyword, Text, Operator, Text
          push :funcname
        end

        rule %r/(const)(\s+)(#{id})/i do
          groups Keyword, Text, Name::Constant
        end

        rule %r/stdClass\b/i, Name::Class
        rule %r/(true|false|null)\b/i, Keyword::Constant
        rule %r/(E|PHP)(_[[:upper:]]+)+\b/, Keyword::Constant
        rule %r/\$\{\$+#{id}\}/i, Name::Variable
        rule %r/\$+#{id}/i, Name::Variable
        rule %r/(yield)([ \n\r\t]+)(from)/i do
          groups Keyword, Text, Keyword
        end

        # may be intercepted for builtin highlighting
        rule %r/\\?#{nsid}/i do |m|
          name = m[0].downcase

          if self.class.keywords.include? name
            token Keyword
          elsif self.builtins.include? name
            token Name::Builtin
          else
            token Name::Other
          end
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

      state :use do
        rule %r/(\s+)(as)(\s+)(#{id})/i do
          groups Text, Keyword, Text, Name
          :pop!
        end
        rule %r/\\\{/, Operator, :uselist
        rule %r/;/, Punctuation, :pop!
      end

      state :uselist do
        rule %r/\s+/, Text
        rule %r/,/, Operator
        rule %r/\}/, Operator, :pop!
        rule %r/(as)(\s+)(#{id})/i do
          groups Keyword, Text, Name
        end
        rule %r/#{id}/, Name::Namespace
      end

      state :funcname do
        rule %r/#{id}/, Name::Function, :pop!
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
