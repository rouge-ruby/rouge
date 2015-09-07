# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Logtalk < RegexLexer
      title "Logtalk"
      desc "The Logtalk programming language (http://logtalk.org/)"
      tag 'logtalk'
      aliases 'logtalk'
      filenames '*.lgt', '*.logtalk'
      mimetypes 'text/x-logtalk'

      def self.analyze_text(text)
          return 1.0 if text.include? ':- object('
          return 1.0 if text.include? ':- protocol('
          return 1.0 if text.include? ':- category('
          return 0.9 if text =~ /^:-\s[a-z]/
      end

      state :basic do
        # Directives
        rule /^\s*:-\s/, Keyword, :directives
        # Whitespace
        mixin :whitespace
        # Comments
        mixin :comments
        # Numbers
        mixin :numbers
        # Variables
        mixin :variables
        # Event handlers
        rule /(after|before)(?=[(])/, Keyword
        # Message forwarding handler
        rule /forward(?=[(])/, Keyword
        # Execution-context methods
        rule /(parameter|this|se(lf|nder))(?=[(])/, Keyword
        # Reflection
        rule /(current_predicate|predicate_property)(?=[(])/, Keyword
        # DCGs and term expansion
        rule /(expand_(goal|term)|(goal|term)_expansion|phrase)(?=[(])/, Keyword
        # Entity
        rule /(abolish|c(reate|urrent))_(object|protocol|category)(?=[(])/, Keyword
        rule /(object|protocol|category)_property(?=[(])/, Keyword
        # Entity relations
        rule /co(mplements_object|nforms_to_protocol)(?=[(])/, Keyword
        rule /extends_(object|protocol|category)(?=[(])/, Keyword
        rule /imp(lements_protocol|orts_category)(?=[(])/, Keyword
        rule /(instantiat|specializ)es_class(?=[(])/, Keyword
        # Events
        rule /(current_event|(abolish|define)_events)(?=[(])/, Keyword
        # Flags
        rule /(create|current|set)_logtalk_flag(?=[(])/, Keyword
        # Compiling, loading, and library paths
        rule /logtalk_(compile|l(ibrary_path|oad|oad_context)|make)(?=[(])/, Keyword
        rule /\blogtalk_make\b/, Keyword
        # Database
        rule /(clause|retract(all)?)(?=[(])/, Keyword
        rule /a(bolish|ssert(a|z))(?=[(])/, Keyword
        # Control constructs
        rule /(ca(ll|tch)|throw)(?=[(])/, Keyword
        rule /(fa(il|lse)|true)\b/, Keyword
        # All solutions
        rule /((bag|set)of|f(ind|or)all)(?=[(])/, Keyword
        # Multi-threading meta-predicates
        rule /threaded(_(call|once|ignore|exit|peek|wait|notify))?(?=[(])/, Keyword
        # Term unification
        rule /(subsumes_term|unify_with_occurs_check)(?=[(])/, Keyword
        # Term creation and decomposition
        rule /(functor|arg|copy_term|numbervars|term_variables)(?=[(])/, Keyword
        # Evaluable functors
        rule /(div|rem|m(ax|in|od)|abs|sign)(?=[(])/, Keyword
        rule /float(_(integer|fractional)_part)?(?=[(])/, Keyword
        rule /(floor|t(an|runcate)|round|ceiling)(?=[(])/, Keyword
        # Other arithmetic functors
        rule /(cos|a(cos|sin|tan|tan2)|exp|log|s(in|qrt)|xor)(?=[(])/, Keyword
        # Term testing
        rule /(var|atom(ic)?|integer|float|c(allable|ompound)|n(onvar|umber)|ground|acyclic_term)(?=[(])/, Keyword
        # Term comparison
        rule /compare(?=[(])/, Keyword
        # Stream selection and control
        rule /(curren|se)t_(in|out)put(?=[(])/, Keyword
        rule /(open|close)(?=[(])/, Keyword
        rule /flush_output(?=[(])/, Keyword
        rule /(at_end_of_stream|flush_output)\b/, Keyword
        rule /(stream_property|at_end_of_stream|set_stream_position)(?=[(])/, Keyword
        # Character and byte input/output
        rule /(nl|(get|peek|put)_(byte|c(har|ode)))(?=[(])/, Keyword
        rule /\bnl\b/, Keyword
        # Term input/output
        rule /read(_term)?(?=[(])/, Keyword
        rule /write(q|_(canonical|term))?(?=[(])/, Keyword
        rule /(current_)?op(?=[(])/, Keyword
        rule /(current_)?char_conversion(?=[(])/, Keyword
        # Atomic term processing
        rule /atom_(length|c(hars|o(ncat|des)))(?=[(])/, Keyword
        rule /(char_code|sub_atom)(?=[(])/, Keyword
        rule /number_c(har|ode)s(?=[(])/, Keyword
        # Implementation defined hooks functions
        rule /(se|curren)t_prolog_flag(?=[(])/, Keyword
        rule /\bhalt\b/, Keyword
        rule /halt(?=[(])/, Keyword
        # Message sending operators
        rule /(::|:|\^\^)/, Operator
        # External call
        rule /[{}]/, Keyword
        # Logic and control
        rule /(ignore|once)(?=[(])/, Keyword
        rule /\brepeat\b/, Keyword
        # Sorting
        rule /(key)?sort(?=[(])/, Keyword
        # Bitwise functors
        rule %r(>>|<<|/\\|\\\\|\\), Operator
        # Predicate aliases
        rule /\bas\b/, Operator
        # Arithemtic evaluation
        rule /\bis\b/, Keyword
        # Arithemtic comparison
        rule %r(=:=|=\\=|<|=<|>=|>), Operator
        # Term creation and decomposition
        rule %r(=\.\.), Operator
        # Term unification
        rule %r(=|\\=), Operator
        # Term comparison
        rule %r(==|\\==|@=<|@<|@>=|@>), Operator
        # Evaluable functors
        rule %r(//|[-+*/]), Operator
        rule /\b(e|pi|div|mod|rem)\b/, Operator
        # Other arithemtic functors
        rule /\b\*\*\b/, Operator
        # DCG rules
        rule /-->/, Operator
        # Control constructs
        rule /([!;]|->)/, Operator
        # Logic and control
        rule /\\+/, Operator
        # Mode operators
        rule /[?@]/, Operator
        # Existential quantifier
        rule /\^/, Operator
        # Strings
        mixin :strings
        # Punctuation
        mixin :punctuation
        # Atoms
        mixin :atoms
      end

      state :directives do
        # Whitespace
        mixin :whitespace
        # Conditional compilation directives
        rule /(el)?if(?=[(])/, Keyword, :pop!
        rule /(e(lse|ndif))(?=[.])/, Keyword, :pop!
        # Entity directives
        rule /(category|object|protocol)(?=[(])/, Keyword, :entity_relations
        rule /(end_(category|object|protocol))(?=[.])/, Keyword, :pop!
        # Predicate scope directives
        rule /(public|protected|private)(?=[(])/, Keyword, :pop!
        # Other directives
        rule /e(n(coding|sure_loaded)|xport)(?=[(])/, Keyword, :pop!
        rule /in(clude|itialization|fo)(?=[(])/, Keyword, :pop!
        rule /(built_in|dynamic|synchronized|threaded)(?=[.])/, Keyword, :pop!
        rule /(alias|d(ynamic|iscontiguous)|m(eta_(non_terminal|predicate)|ode|ultifile)|s(et_(logtalk|prolog)_flag|ynchronized))(?=[(])/, Keyword, :pop!
        rule /op(?=[(])/, Keyword, :pop!
        rule /(c(alls|oinductive)|module|reexport|use(s|_module))(?=[(])/, Keyword, :pop!
        rule /[a-z][a-zA-Z0-9_]*(?=[(])/, Text, :pop!
        rule /[a-z][a-zA-Z0-9_]*(?=[.])/, Text, :pop!
        # End of entity-opening directive
        rule /[)][.]/, Punctuation, :pop!
      end

      state :entity_relations do
        rule /(complements|extends|i(nstantiates|mp(lements|orts))|specializes)(?=[(])/, Keyword
        # Numbers
        mixin :numbers
        # Variables
        mixin :variables
        # Atoms
        mixin :atoms
        # Strings
        mixin :strings
        # End of entity-opening directive
        rule /(?=[)][.])/, Punctuation, :pop!
        # Scope operator
        rule /(::)/, Operator
        # Punctuation
        mixin :punctuation
        # Whitespace
        mixin :whitespace
        # Comments
        mixin :comments
      end

      state :variables do
        rule /([A-Z_][a-zA-Z0-9_]*)/, Name::Variable
      end

      state :atoms do
        rule /[a-z][a-zA-Z0-9_]*/, Text
        rule /[']/, Str, :quoted_atoms
      end

      state :quoted_atoms do
        rule /['][']/, Str
        rule /[']/, Str, :pop!
        rule %r(\\([\\abfnrtv"\']|(x[a-fA-F0-9]+|[0-7]+)\\)), Str::Escape
        rule %r(\\), Str::Escape
        rule /[^']*/, Str
      end

      state :strings do
        rule /"(\\\\|\\"|[^"])*"/, Str
#       rule %r("[^\\'\n]+"), Str
      end

      state :numbers do
        rule /0'./, Num
        rule /0b[01]+/, Num
        rule /0o[0-7]+/, Num
        rule /0x[0-9a-fA-F]+/, Num
        rule /\d+\.?\d*((e|E)(\+|-)?\d+)?/, Num
      end

      state :punctuation do
        rule /[()\[\],.|]/, Punctuation
      end

      state :whitespace do
        rule /\n/, Text
        rule /\s+/, Text
      end

      state :comments do
        rule /%.*?\n/, Comment::Single
        rule /\/\*/, Comment::Multiline, :nested_comment
      end

      state :nested_comment do
        rule %r([^/\*]+), Comment::Multiline
        rule %r(/\*), Comment::Multiline, :nested_comment
        rule %r(\*/), Comment::Multiline, :pop!
        rule %r([*/]), Comment::Multiline
      end

      state :root do
        mixin :basic
        mixin :directives
      end

    end
  end
end
