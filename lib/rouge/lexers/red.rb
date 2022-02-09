# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Red < RegexLexer
      title 'Red Language'
      desc 'Red (http://www.red-lang.org/)'

      tag 'red'
      filenames '*.red'
      mimetypes 'text/red'

      id = /[a-z0-9!$\%&*+,\/:<=>?@^_~|-]+/i

      def self.functions
        @functions ||= Set.new %w(
          ? ?? a-an about acos action? all-word? also alter any-block?
          any-function? any-list? any-object? any-path? any-string? any-word?
          asin atan atan2 attempt binary? bitset? block? body-of cause-error cd
          center-face change-dir char? charset class-of clean-path
          clear-reactions collect comment common-substr context cos datatype?
          date? dir dir? dirize distance? do-actor do-events do-file do-safe
          do-thru draw dump-face dump-reactions ellipsize-at email? empty?
          error? eval-set-path exists-thru? expand expand-directives extract
          extract-boot-args face? fetch-help fifth file? first flip-exe-flag
          float? foreach-face fourth function? get-path? get-scroller get-word?
          halt handle? hash? help help-string hex-to-rgb image? immediate? input
          insert-event-func integer? issue? keys-of last layout link-sub-to-parent
          link-tabs-to-parent list-dir lit-path? lit-word? ll load load-thru
          logic? ls make-dir map? math matrix metrics? mod modulo native? none?
          normalize-dir number? object object? offset? on-face-deep-change*
          on-parse-event op? overlap? pad pair? paren? parse-func-spec
          parse-trace path-thru path? percent? probe pwd q quit quote react
          react? read-thru red-complete-file red-complete-input red-complete-path
          refinement? rejoin remove-event-func repend replace request-dir
          request-file request-font routine routine? save scalar? second series?
          set-flag set-focus set-path? set-word? show sin size-text source
          spec-of split split-path sqrt string? suffix? tag? tan third time?
          to-binary to-bitset to-block to-char to-date to-email to-file to-float
          to-get-path to-get-word to-hash to-image to-integer to-issue
          to-lit-path to-lit-word to-logic to-map to-none to-pair to-paren to-path
          to-percent to-red-file to-refinement to-set-path to-set-word to-string
          to-tag to-time to-tuple to-typeset to-unset to-url to-word tuple?
          typeset? unset? unview update-font-faces url? values-of vector? View
          what what-dir within? word? words-of
        )
      end

      def self.actions
        @actions ||= Set.new %w(
          absolute add and~ append at back change clear complement copy delete
          divide even? find form head head? index? insert length? make modify
          mold move multiply negate next odd? or~ pick poke power put random
          read reflect remainder remove reverse round select skip sort subtract
          swap tail tail? take to trim write xor~
        )
      end

      def self.natives
        @natives ||= Set.new %w(
          all any arccosine arcsine arctangent arctangent2 as as-pair bind
          browse call catch checksum complement? compose construct context?
          cosine debase dehex difference do does enbase equal? exclude exp
          extend func function get get-env greater-or-equal? greater? has in
          intersect lesser-or-equal? lesser? list-env log-10 log-2 log-e
          lowercase max min NaN? negative? new-line new-line? not not-equal?
          now parse positive? prin print reduce remove-each same? set set-env
          shift sign? sine size? square-root stats strict-equal? tangent throw
          to-hex to-local-file try type? union unique unset uppercase value?
          wait zero?
        )
      end

      def self.datatypes
        @datatypes ||= Set.new %w(
          action! binary! bitset! block! char! datatype! date! email! error!
          event! file! float! function! get-path! get-word! handle! hash! image!
          integer! issue! lit-path! lit-word! logic! map! native! none! object!
          op! pair! paren! path! percent! point! refinement! routine! set-path!
          set-word! string! tag! time! tuple! typeset! unset! url! vector! word!
        )
      end

      def self.operators
        @operators ||= Set.new %w(
          + < <> % << = * / - > <= >= ** // == =? >> >>> and or
        )
      end

      state :root do
        # comments
        rule /;.+$/, Comment::Single
        rule /comment {.*}/m, Comment::Multiline

        rule /[+-]?[0-9]+\.[0-9]*E[+-]?[0-9]+/, Literal::Number::Float
        rule /[+-]?\.[0-9]+E[+-]?[0-9]+/, Literal::Number::Float
        rule /[+-]?[0-9]+E[+-]?[0-9]+/, Literal::Number::Float
        rule /[+-]?[0-9]*\.[0-9]+?/, Literal::Number::Float
        rule /[+-]?[0-9]+/, Literal::Number::Integer

        rule /\./, Punctuation
        rule /,/, Punctuation
        rule /;/, Punctuation
        rule /\(/, Punctuation
        rule /\)/, Punctuation
        rule /\{/, Punctuation
        rule /\}/, Punctuation
        rule /\[/, Punctuation
        rule /\]/, Punctuation
        rule /\^\^/, Punctuation

        rule /<[^>]*>/, Name::Label
        rule /\s+/, Text::Whitespace
        rule /""".*?"""/m, Literal::String
        rule /"([^"\\]|\\.)*"/, Literal::String
        rule /'''.*?'''/m, Literal::String
        rule /'([^'\\]|\\.)*'/, Literal::String

        # email
        rule /\w[-\w._]*\@\w[-\w._]*/, Keyword::Type

        # time
        rule  /\b\d+:\d+(:\d+)?/, Keyword::Type

        # url
        rule  /\w[-\w_]*\:(\/\/)?\w[-\w._]*(:\d+)?/, Keyword::Type

        # date
        rule /(\b\d{1,4}[-\/]\d{1,2}[-\/]\d{1,2}|\d{1,2}[-\/]\d{1,2}[-\/]\d{1,4})\b/, Keyword::Type

        # tuple
        rule  /\b\d{1,3}\.\d{1,3}\.\d{1,3}(\.\d{1,3}){0,9}/, Keyword::Type

        # pair
        rule  /[+-]?\d+x[-+]?\d+/, Keyword::Type

        # binary -- ToDo

        # issue
        rule /#\w[-\w'*.]*/, Keyword::Type

        # file
        rule /%[-\w\.\/]+/, Keyword::Type

        # char
        rule /#"(\^[-@\/_~^"HKLM\[]|.)"/, Literal::String::Char

        # get word
        rule  /\:\w[-\w'*.?!]*/, Name::Property

        # set word
        rule  /\w[-\w'*.?!]*\:/, Name::Variable

        # lit word
        rule /'\w[-\w'*.?!]*/, Name::Entity

        # word
        rule /\b\w+[-\w'*.!?]*/, Name

        # get path
        rule  /:\w[-\w'*.?!]*(\/\w[-\w'*.?!]*)(\/\w[-\w'*.?!]*)*/, Name::Variable

        # set path
        rule  /\w[-\w'*.?!]*(\/\w[-\w'*.?!]*)(\/\w[-\w'*.?!]*)*:/, Name::Variable

        # lit path
        rule /'\w[-\w'*.?!]*(\/\w[-\w'*.?!]*)(\/\w[-\w'*.?!]*)*/, Name::Variable

        # path
        rule  /\w[-\w'*.?!]*(\/\w[-\w'*.?!]*)(\/\w[-\w'*.?!]*)*/, Name::Variable

        # refinement
        rule  /\/\w[-\w'*.?!]*/, Name::Variable

        rule id do |m|
          match = m[0]
          if self.class.functions.include? match
            token Name::Function
          elsif self.class.actions.include? match
            token Name::Builtin::Pseudo
          elsif self.class.natives.include? match
            token Name::Builtin
          elsif self.class.datatypes.include? match
            token Keyword::Type
          elsif self.class.operators.include? match
            token Operator
          else
            token Text
          end
        end

      end

    end
  end
end
