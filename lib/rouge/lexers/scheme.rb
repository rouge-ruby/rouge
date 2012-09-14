module Rouge
  module Lexers
    class Scheme < RegexLexer
      tag 'scheme'
      filenames '*.scm', '*.ss', '*.rkt'
      mimetypes 'text/x-scheme', 'application/x-scheme'

      keywords = %w(
        lambda define if else cond and or case let let* letrec begin
        do delay set! => quote quasiquote unquote unquote-splicing
        define-syntax let-syntax letrec-syntax syntax-rules
      )

      builtins = %w(
        * + - / < <= = > >= abs acos angle append apply asin
        assoc assq assv atan boolean? caaaar caaadr caaar caadar
        caaddr caadr caar cadaar cadadr cadar caddar cadddr caddr
        cadr call-with-current-continuation call-with-input-file
        call-with-output-file call-with-values call/cc car cdaaar cdaadr
        cdaar cdadar cdaddr cdadr cdar cddaar cddadr cddar cdddar cddddr
        cdddr cddr cdr ceiling char->integer char-alphabetic? char-ci<=?
        char-ci<? char-ci=? char-ci>=? char-ci>? char-downcase
        char-lower-case? char-numeric? char-ready? char-upcase
        char-upper-case? char-whitespace? char<=? char<? char=? char>=?
        char>? char? close-input-port close-output-port complex? cons
        cos current-input-port current-output-port denominator
        display dynamic-wind eof-object? eq?  equal? eqv? eval
        even? exact->inexact exact? exp expt floor for-each force gcd
        imag-part inexact->exact inexact? input-port? integer->char
        integer? interaction-environment lcm length list list->string
        list->vector list-ref list-tail list?  load log magnitude
        make-polar make-rectangular make-string make-vector map
        max member memq memv min modulo negative? newline not
        null-environment null? number->string number? numerator odd?
        open-input-file open-output-file output-port? pair?  peek-char
        port? positive? procedure? quotient rational? rationalize
        read read-char real-part real?  remainder reverse round
        scheme-report-environment set-car! set-cdr! sin sqrt string
        string->list string->number string->symbol string-append
        string-ci<=?  string-ci<? string-ci=? string-ci>=? string-ci>?
        string-copy string-fill! string-length string-ref
        string-set! string<=? string<? string=? string>=?
        string>? string? substring symbol->string symbol?
        tan transcript-off transcript-on truncate values vector
        vector->list vector-fill! vector-length vector-ref
        vector-set! vector? with-input-from-file with-output-to-file
        write write-char zero?
      )

      id = /[a-z0-9!$\%&*+,\/:<=>?@^_~|-]+/i

      escape = Regexp.method(:escape)

      state :root do
        # comments
        rule /;.*$/, 'Comment.Single'
        rule /\s+/m, 'Text'
        rule /-?\d+\.\d+/, 'Number.Float'

        # support for uncommon kinds of numbers -
        # have to figure out what the characters mean
        # rule /(#e|#i|#b|#o|#d|#x)[\d.]+/, 'Number'
        rule /"(\\\\|\\"|[^"])*"/, 'Literal.String'
        rule /'#{id}/i, 'Literal.String.Symbol'
        rule /#\\([()\/'"._!\$%& ?=+-]{1}|[a-z0-9]+)/i,
          'Literal.String.Char'
        rule /#t|#f/, 'Name.Constant'
        rule /(?:'|#|`|,@|,|\.)/, 'Operator'
        rule /(?:#{keywords.map(&escape).join('|')})(?=[^\w-])/,
          'Keyword'

        rule /(['#])(\s*)(\()/m do
          group 'Literal.String.Symbol'
          group 'Text'
          group 'Punctuation'
        end

        rule /\(/, 'Punctuation', :command
        rule /\)/, 'Punctuation'

        rule id, 'Name.Variable'
      end

      state :command do
        rule /(?:#{builtins.map(&escape).join('|')})(?=[^\w-])/, 'Name.Builtin', :pop!
        rule id, 'Name.Function', :pop!
        rule(//) { pop! }
      end

    end
  end
end
