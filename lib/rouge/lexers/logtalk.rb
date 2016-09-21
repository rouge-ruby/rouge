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
        rule /(parameter|this|self|sender)(?=[(])/, Keyword
        # Reflection
        rule /(current_predicate|predicate_property)(?=[(])/, Keyword
        # DCGs and term expansion
        rule /(expand_goal|expand_term|goal_expansion|term_expansion|phrase)(?=[(])/, Keyword
        # Entity
        rule /(abolish_object|abolish_protocol|abolish_category)(?=[(])/, Keyword
        rule /(create_object|create_protocol|create_category)(?=[(])/, Keyword
        rule /(current_object|current_protocol|current_category)(?=[(])/, Keyword
        rule /(object_property|protocol_property|category_property)(?=[(])/, Keyword
        # Entity relations
        rule /(complements_object|conforms_to_protocol)(?=[(])/, Keyword
        rule /(extends_object|extends_protocol|extends_category)(?=[(])/, Keyword
        rule /(implements_protocol|imports_category)(?=[(])/, Keyword
        rule /(instantiates_class|specializes_class)(?=[(])/, Keyword
        # Events
        rule /(current_event|abolish_events|define_events)(?=[(])/, Keyword
        # Flags
        rule /(create_logtalk_flag|current_logtalk_flag|set_logtalk_flag)(?=[(])/, Keyword
        # Compiling, loading, and library paths
        rule /(logtalk_compile|logtalk_load)(?=[(])/, Keyword
        rule /(logtalk_library_path|logtalk_load_context|logtalk_make)(?=[(])/, Keyword
        rule /\blogtalk_make\b/, Keyword
        # Database
        rule /(clause|retract|retractall)(?=[(])/, Keyword
        rule /(abolish|asserta|assertz)(?=[(])/, Keyword
        # Control constructs
        rule /(call|catch|throw)(?=[(])/, Keyword
        rule /(fail|false|true)\b/, Keyword
        # All solutions
        rule /(bagof|setof|findall|forall)(?=[(])/, Keyword
        # Multi-threading meta-predicates
        rule /threaded(?=[(])/, Keyword
        rule /(threaded_call|threaded_once|threaded_ignore|threaded_exit|threaded_peek)(?=[(])/, Keyword
        rule /(threaded_wait|threaded_notify)(?=[(])/, Keyword
        # Threaded engines
        rule /(threaded_engine|threaded_engine_create|threaded_engine_destroy|threaded_engine_self)(?=[(])/, Keyword
        rule /(threaded_engine_next|threaded_engine_next_reified)(?=[(])/, Keyword
        rule /(threaded_engine_yield|threaded_engine_post|threaded_engine_fetch)(?=[(])/, Keyword
        # Term unification
        rule /(subsumes_term|unify_with_occurs_check)(?=[(])/, Keyword
        # Term creation and decomposition
        rule /(functor|arg|copy_term|numbervars|term_variables)(?=[(])/, Keyword
        # Evaluable functors
        rule /(div|rem|max|min|mod|abs|sign)(?=[(])/, Keyword
        rule /(float_integer_part|float_fractional_part)(?=[(])/, Keyword
        rule /(floor|truncate|round|ceiling)(?=[(])/, Keyword
        # Other arithmetic functors
        rule /(cos|acos|asin|atan|atan2|exp|log|sin|sqrt|tan|xor)(?=[(])/, Keyword
        # Term testing
        rule /(var|atom|atomic|integer|float|callable|compound|nonvar|number|ground|acyclic_term)(?=[(])/, Keyword
        # Term comparison
        rule /compare(?=[(])/, Keyword
        # Stream selection and control
        rule /(current_input|current_output|set_input|set_output)(?=[(])/, Keyword
        rule /(open|close)(?=[(])/, Keyword
        rule /flush_output(?=[(])/, Keyword
        rule /(at_end_of_stream|flush_output)\b/, Keyword
        rule /(stream_property|at_end_of_stream|set_stream_position)(?=[(])/, Keyword
        # Character and byte input/output
        rule /nl(?=[(])/, Keyword
        rule /(get_byte|get_char|get_code)(?=[(])/, Keyword
        rule /(peek_byte|peek_char|peek_code)(?=[(])/, Keyword
        rule /(put_byte|put_char|put_code)(?=[(])/, Keyword
        rule /\bnl\b/, Keyword
        # Term input/output
        rule /(read|read_term)(?=[(])/, Keyword
        rule /(write|writeq|write_canonical|write_term)(?=[(])/, Keyword
        rule /(current_op|op)(?=[(])/, Keyword
        rule /(char_conversion|current_char_conversion)(?=[(])/, Keyword
        # Atomic term processing
        rule /(atom_length|atom_chars|atom_concat|atom_codes)(?=[(])/, Keyword
        rule /(char_code|sub_atom)(?=[(])/, Keyword
        rule /(number_chars|number_codes)(?=[(])/, Keyword
        # Implementation defined hooks functions
        rule /(set_prolog_flag|current_prolog_flag)(?=[(])/, Keyword
        rule /halt(?=[(])/, Keyword
        rule /\bhalt\b/, Keyword
        # Message sending operators
        rule /(::|:|\^\^)/, Operator
        # External call
        rule /[{}]/, Keyword
        # Logic and control
        rule /(ignore|once)(?=[(])/, Keyword
        rule /\brepeat\b/, Keyword
        # Sorting
        rule /(keysort|sort)(?=[(])/, Keyword
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
        rule /(elif|if)(?=[(])/, Keyword, :pop!
        rule /(else|endif)(?=[.])/, Keyword, :pop!
        # Entity directives
        rule /(category|object|protocol)(?=[(])/, Keyword, :entity_relations
        rule /(end_category|end_object|end_protocol)(?=[.])/, Keyword, :pop!
        # Predicate scope directives
        rule /(public|protected|private)(?=[(])/, Keyword, :pop!
        # Other directives
        rule /(encoding|ensure_loaded|export)(?=[(])/, Keyword, :pop!
        rule /(include|initialization|info)(?=[(])/, Keyword, :pop!
        rule /(built_in|dynamic|synchronized|threaded)(?=[.])/, Keyword, :pop!
        rule /(alias|dynamic|discontiguous|meta_non_terminal|meta_predicate|mode|multifile|synchronized)(?=[(])/, Keyword, :pop!
        rule /(set_logtalk_flag|set_prolog_flag)(?=[(])/, Keyword, :pop!
        rule /op(?=[(])/, Keyword, :pop!
        rule /(calls|coinductive|module|reexport|uses|use_module)(?=[(])/, Keyword, :pop!
        rule /[a-z][a-zA-Z0-9_]*(?=[(])/, Text, :pop!
        rule /[a-z][a-zA-Z0-9_]*(?=[.])/, Text, :pop!
        # End of entity-opening directive
        rule /[)][.]/, Punctuation, :pop!
      end

      state :entity_relations do
        rule /(complements|extends|instantiates|implements|imports|specializes)(?=[(])/, Keyword
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
