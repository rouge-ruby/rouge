# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Logtalk < RegexLexer
      title "Logtalk"
      desc "The Logtalk programming language (https://logtalk.org/)"
      tag 'logtalk'
      aliases 'lgt'
      filenames '*.lgt', '*.logtalk'
      mimetypes 'text/x-logtalk'

      def self.analyze_text(text)
          return 1.0 if text.include? ':- object('
          return 1.0 if text.include? ':- protocol('
          return 1.0 if text.include? ':- category('
          return 0.9 if text =~ %r/^:-\s[a-z]/
      end

      state :root do
        # Directives
        rule %r/^\s*:-\s/, Keyword, :directives
        # Whitespace
        mixin :whitespace
        # Comments
        mixin :comments
        # Numbers
        mixin :numbers
        # Variables
        mixin :variables
        # Event handlers
        rule %r/(after|before)(?=[(])/, Keyword
        # Message forwarding handler
        rule %r/forward(?=[(])/, Keyword
        # Execution-context methods
        rule %r/(context|parameter|this|self|sender)(?=[(])/, Keyword
        # Reflection
        rule %r/(current_predicate|predicate_property)(?=[(])/, Keyword
        # DCGs and term expansion
        rule %r/(expand_goal|expand_term|goal_expansion|term_expansion|phrase)(?=[(])/, Keyword
        # Entity
        rule %r/(abolish_object|abolish_protocol|abolish_category)(?=[(])/, Keyword
        rule %r/(create_object|create_protocol|create_category)(?=[(])/, Keyword
        rule %r/(current_object|current_protocol|current_category)(?=[(])/, Keyword
        rule %r/(object_property|protocol_property|category_property)(?=[(])/, Keyword
        # Entity relations
        rule %r/(complements_object|conforms_to_protocol)(?=[(])/, Keyword
        rule %r/(extends_object|extends_protocol|extends_category)(?=[(])/, Keyword
        rule %r/(implements_protocol|imports_category)(?=[(])/, Keyword
        rule %r/(instantiates_class|specializes_class)(?=[(])/, Keyword
        # Events
        rule %r/(current_event|abolish_events|define_events)(?=[(])/, Keyword
        # Flags
        rule %r/(create_logtalk_flag|current_logtalk_flag|set_logtalk_flag)(?=[(])/, Keyword
        # Compiling, loading, and library paths
        rule %r/(logtalk_compile|logtalk_load)(?=[(])/, Keyword
        rule %r/(logtalk_library_path|logtalk_load_context|logtalk_make|logtalk_make_target_action)(?=[(])/, Keyword
        rule %r/\blogtalk_make\b/, Keyword
        # Database
        rule %r/(clause|retract|retractall)(?=[(])/, Keyword
        rule %r/(abolish|asserta|assertz)(?=[(])/, Keyword
        # Control constructs
        rule %r/(call|catch|throw)(?=[(])/, Keyword
        rule %r/(fail|false|true|instantiation_error|system_error)\b/, Keyword
        rule %r/(uninstantiation_error|type_error|domain_error|existence_error|permission_error|representation_error|evaluation_error|resource_error|syntax_error)(?=[(])/, Keyword
        # All solutions
        rule %r/(bagof|setof|findall|forall)(?=[(])/, Keyword
        # Multi-threading meta-predicates
        rule %r/threaded(?=[(])/, Keyword
        rule %r/(threaded_call|threaded_cancel|threaded_once|threaded_ignore|threaded_exit|threaded_peek)(?=[(])/, Keyword
        rule %r/(threaded_wait|threaded_notify)(?=[(])/, Keyword
        # Threaded engines
        rule %r/(threaded_engine|threaded_engine_create|threaded_engine_destroy|threaded_engine_self)(?=[(])/, Keyword
        rule %r/(threaded_engine_next|threaded_engine_next_reified)(?=[(])/, Keyword
        rule %r/(threaded_engine_yield|threaded_engine_post|threaded_engine_fetch)(?=[(])/, Keyword
        # Term unification
        rule %r/(subsumes_term|unify_with_occurs_check)(?=[(])/, Keyword
        # Term creation and decomposition
        rule %r/(functor|arg|copy_term|numbervars|term_variables)(?=[(])/, Keyword
        # Evaluable functors
        rule %r/(div|rem|max|min|mod|abs|sign)(?=[(])/, Keyword
        rule %r/(float_integer_part|float_fractional_part)(?=[(])/, Keyword
        rule %r/(floor|truncate|round|ceiling)(?=[(])/, Keyword
        # Other arithmetic functors
        rule %r/(cos|acos|asin|atan|atan2|exp|log|sin|sqrt|tan|xor)(?=[(])/, Keyword
        # Term testing
        rule %r/(var|atom|atomic|integer|float|callable|compound|nonvar|number|ground|acyclic_term)(?=[(])/, Keyword
        # Term comparison
        rule %r/compare(?=[(])/, Keyword
        # Stream selection and control
        rule %r/(current_input|current_output|set_input|set_output)(?=[(])/, Keyword
        rule %r/(open|close)(?=[(])/, Keyword
        rule %r/flush_output(?=[(])/, Keyword
        rule %r/(at_end_of_stream|flush_output)\b/, Keyword
        rule %r/(stream_property|at_end_of_stream|set_stream_position)(?=[(])/, Keyword
        # Character and byte input/output
        rule %r/nl(?=[(])/, Keyword
        rule %r/(get_byte|get_char|get_code)(?=[(])/, Keyword
        rule %r/(peek_byte|peek_char|peek_code)(?=[(])/, Keyword
        rule %r/(put_byte|put_char|put_code)(?=[(])/, Keyword
        rule %r/\bnl\b/, Keyword
        # Term input/output
        rule %r/(read|read_term)(?=[(])/, Keyword
        rule %r/(write|writeq|write_canonical|write_term)(?=[(])/, Keyword
        rule %r/(current_op|op)(?=[(])/, Keyword
        rule %r/(char_conversion|current_char_conversion)(?=[(])/, Keyword
        # Atomic term processing
        rule %r/(atom_length|atom_chars|atom_concat|atom_codes)(?=[(])/, Keyword
        rule %r/(char_code|sub_atom)(?=[(])/, Keyword
        rule %r/(number_chars|number_codes)(?=[(])/, Keyword
        # Implementation defined hooks functions
        rule %r/(set_prolog_flag|current_prolog_flag)(?=[(])/, Keyword
        rule %r/halt(?=[(])/, Keyword
        rule %r/\bhalt\b/, Keyword
        # Message sending operators
        rule %r/(::|:|\^\^)/, Operator
        # External call
        rule %r/[{}]/, Keyword
        # Logic and control
        rule %r/(ignore|once)(?=[(])/, Keyword
        rule %r/\brepeat\b/, Keyword
        # Sorting
        rule %r/(keysort|sort)(?=[(])/, Keyword
        # Bitwise functors
        rule %r(>>|<<|/\\|\\\\|\\), Operator
        # Predicate aliases
        rule %r/\bas\b/, Operator
        # Arithemtic evaluation
        rule %r/\bis\b/, Keyword
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
        rule %r/\b(e|pi|div|mod|rem)\b/, Operator
        # Other arithemtic functors
        rule %r/\b\*\*\b/, Operator
        # DCG rules
        rule %r/-->/, Operator
        # Control constructs
        rule %r/([!;]|->)/, Operator
        # Logic and control
        rule %r/\\+/, Operator
        # Mode operators
        rule %r/[?@]/, Operator
        # Existential quantifier
        rule %r/\^/, Operator
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
        rule %r/(elif|if)(?=[(])/, Keyword, :pop!
        rule %r/(else|endif)(?=[.])/, Keyword, :pop!
        # Entity directives
        rule %r/(category|object|protocol)(?=[(])/, Keyword, :entity_relations
        rule %r/(end_category|end_object|end_protocol)(?=[.])/, Keyword, :pop!
        # Predicate scope directives
        rule %r/(public|protected|private)(?=[(])/, Keyword, :pop!
        # Other directives
        rule %r/(encoding|ensure_loaded|export)(?=[(])/, Keyword, :pop!
        rule %r/(include|initialization|info)(?=[(])/, Keyword, :pop!
        rule %r/(built_in|dynamic|synchronized|threaded)(?=[.])/, Keyword, :pop!
        rule %r/(alias|dynamic|discontiguous|meta_non_terminal|meta_predicate|mode|multifile|synchronized)(?=[(])/, Keyword, :pop!
        rule %r/(set_logtalk_flag|set_prolog_flag)(?=[(])/, Keyword, :pop!
        rule %r/op(?=[(])/, Keyword, :pop!
        rule %r/(calls|coinductive|module|reexport|uses|use_module)(?=[(])/, Keyword, :pop!
        rule %r/[a-z][a-zA-Z0-9_]*(?=[(])/, Text, :pop!
        rule %r/[a-z][a-zA-Z0-9_]*(?=[.])/, Text, :pop!
        # End of entity-opening directive
        rule %r/[)][.]/, Punctuation, :pop!
      end

      state :entity_relations do
        rule %r/(complements|extends|instantiates|implements|imports|specializes)(?=[(])/, Keyword
        # Numbers
        mixin :numbers
        # Variables
        mixin :variables
        # Atoms
        mixin :atoms
        # Strings
        mixin :strings
        # End of entity-opening directive
        rule %r/(?=[)][.])/, Punctuation, :pop!
        # Scope operator
        rule %r/(::)/, Operator
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
        rule %r/[a-z][a-zA-Z0-9_]*/, Text
        rule %r/[']/, Str, :quoted_atoms
      end

      state :quoted_atoms do
        rule %r/[']/, Str, :pop!
        rule %r/\\([\\abfnrtv"']|(x[a-fA-F0-9]+|[0-7]+)\\)/, Str::Escape
        rule %r/[^\\'\n]+/, Str
      end

      state :strings do
        rule %r/["]/, Str, :double_quoted_terms
      end

      state :double_quoted_terms do
        rule %r/["]/, Str, :pop!
        rule %r/\\([\\abfnrtv"']|(x[a-fA-F0-9]+|[0-7]+)\\)/, Str::Escape
        rule %r/[^\\"\n]+/, Str
      end

      state :numbers do
        rule %r/0'[\\]?./, Num
        rule %r/0b[01]+/, Num
        rule %r/0o[0-7]+/, Num
        rule %r/0x[0-9a-fA-F]+/, Num
        rule %r/\d+\.?\d*((e|E)(\+|-)?\d+)?/, Num
      end

      state :punctuation do
        rule %r/[()\[\],.|]/, Punctuation
      end

      state :whitespace do
        rule %r/\n/, Text
        rule %r/\s+/, Text
      end

      state :comments do
        rule %r/%.*\n/, Comment::Single
        rule %r/\/\*/, Comment::Multiline, :nested_comment
      end

      state :nested_comment do
        rule %r([^/\*]+), Comment::Multiline
        rule %r(/\*), Comment::Multiline, :nested_comment
        rule %r(\*/), Comment::Multiline, :pop!
        rule %r([*/]), Comment::Multiline
      end

    end
  end
end
