module Rouge
  module Lexers
    class Ruby < RegexLexer
      desc "The Ruby programming language (ruby-lang.org)"
      tag 'ruby'
      aliases 'rb'
      filenames '*.rb', '*.ruby', '*.rbw', '*.rake', '*.gemspec',
                'Rakefile', 'Guardfile', 'Gemfile', 'Capfile',
                'Vagrantfile', '*.ru', '*.prawn'

      mimetypes 'text/x-ruby', 'application/x-ruby'

      def self.analyze_text(text)
        return 1 if text.shebang? 'ruby'
      end

      state :strings do
        # symbols
        rule %r(
          :  # initial :
          @{0,2} # optional ivar, for :@foo and :@@foo
          [a-z_]\w*[!?]? # the symbol
        )xi, 'Literal.String.Symbol'

        # special symbols
        rule %r(:(?:\*\*|[-+]@|[/\%&\|^`~]|\[\]=?|<<|>>|<=?>|<=?|===?)),
          'Literal.String.Symbol'

        rule /:'(\\\\|\\'|[^'])*'/, 'Literal.String.Symbol'
        rule /\b[a-z_]\w*?:\s+/, 'Literal.String.Symbol'
        rule /'(\\\\|\\'|[^'])*'/, 'Literal.String.Single'
        rule /:"/, 'Literal.String.Symbol', :simple_sym
        rule /"/, 'Literal.String.Double', :simple_string
        rule /(?<!\.)`/, 'Literal.String.Backtick', :simple_backtick

        # %-style delimiters
        # %(abc), %[abc], %<abc>, %.abc., %r.abc., etc
        delimiter_map = { '{' => '}', '[' => ']', '(' => ')', '<' => '>' }
        rule /%([rqswQWxiI])?([^\w\s])/ do |m|
          open = Regexp.escape(m[2])
          close = Regexp.escape(delimiter_map[m[2]] || m[2])
          interp = /[rQWxI]/ === m[1]
          toktype = 'Literal.String.Other'

          debug { "    open: #{open.inspect}" }
          debug { "    close: #{close.inspect}" }

          # regexes
          if m[1] == 'r'
            toktype = 'Literal.String.Regex'
            push :regex_flags
          end

          token toktype

          push do
            rule /\\[##{open}#{close}\\]/, 'Literal.String.Escape'
            # nesting rules only with asymmetric delimiters
            if open != close
              rule /#{open}/ do
                token toktype
                push
              end
            end
            rule /#{close}/, toktype, :pop!

            if interp
              mixin :string_intp_escaped
              rule /#/, toktype
            else
              rule /[\\#]/, toktype
            end

            rule /[^##{open}#{close}\\]+/m, toktype
          end
        end
      end

      state :regex_flags do
        rule /[mixounse]*/, 'Literal.String.Regex', :pop!
      end

      # double-quoted string and symbol
      [[:string, 'Literal.String.Double', '"'],
       [:sym, 'Literal.String.Symbol', '"'],
       [:backtick, 'Literal.String.Backtick', '`']].each do |name, tok, fin|
        state :"simple_#{name}" do
          mixin :string_intp_escaped
          rule /[^\\#{fin}#]+/m, tok
          rule /[\\#]/, tok
          rule /#{fin}/, tok, :pop!
        end
      end

      keywords = %w(
        BEGIN END alias begin break case defined\? do else elsif end
        ensure for if in next redo rescue raise retry return super then
        undef unless until when while yield
      )

      keywords_pseudo = %w(
        initialize new loop include extend raise attr_reader attr_writer
        attr_accessor attr catch throw private module_function public
        protected true false nil __FILE__ __LINE__
      )

      builtins_g = %w(
        Array Float Integer String __id__ __send__ abort ancestors
        at_exit autoload binding callcc caller catch chomp chop
        class_eval class_variables clone const_defined\? const_get
        const_missing const_set constants display dup eval exec exit
        extend fail fork format freeze getc gets global_variables gsub
        hash id included_modules inspect instance_eval instance_method
        instance_methods instance_variable_get instance_variable_set
        instance_variables lambda load local_variables loop method
        method_missing methods module_eval name object_id open p
        print printf private_class_method private_instance_methods
        private_methods proc protected_instance_methods protected_methods
        public_class_method public_instance_methods public_methods putc
        puts raise rand readline readlines require scan select self send
        set_trace_func singleton_methods sleep split sprintf srand sub
        syscall system taint test throw to_a to_s trace_var trap untaint
        untrace_var warn
      )

      builtins_q = %w(
        autoload block_given const_defined eql equal frozen
        include instance_of is_a iterator kind_of method_defined
        nil private_method_defined protected_method_defined
        public_method_defined respond_to tainted
      )

      builtins_b = %w(chomp chop exit gsub sub)

      start do
        push :expr_start
        @heredoc_queue = []
      end

      state :root do
        rule /\n\s*/m, 'Text', :expr_start
        rule /\s+/, 'Text' # NB: NOT /m
        rule /#.*$/, 'Comment.Single'

        rule %r(=begin\b.*?end\b)m, 'Comment.Multiline'
        rule /(?:#{keywords.join('|')})\b/, 'Keyword', :expr_start
        rule /(?:#{keywords_pseudo.join('|')})\b/, 'Keyword.Pseudo', :expr_start
        rule %r(
          (module)
          (\s+)
          ([a-zA-Z_][a-zA-Z0-9_]*(::[a-zA-Z_][a-zA-Z0-9_]*)*)
        )x do
          group 'Keyword'
          group 'Text'
          group 'Name.Namespace'
        end

        rule /def\s+/, 'Keyword', :funcname
        rule /class\s+/, 'Keyword', :classname

        rule /(?:#{builtins_q.join('|')})\?/, 'Name.Builtin', :expr_start
        rule /(?:#{builtins_b.join('|')})!/,  'Name.Builtin', :expr_start
        rule /(?<!\.)(?:#{builtins_g.join('|')})\b/,
          'Name.Builtin', :method_call

        rule /__END__/, 'Comment.Preproc', :end_part

        rule /0_?[0-7]+(?:_[0-7]+)*/, 'Literal.Number.Oct'
        rule /0x[0-9A-Fa-f]+(?:_[0-9A-Fa-f]+)*/, 'Literal.Number.Hex'
        rule /0b[01]+(?:_[01]+)*/, 'Literal.Number.Bin'
        rule /[\d]+(?:_\d+)*/, 'Literal.Number.Integer'

        # names
        rule /@@[a-z_]\w*/i, 'Name.Variable.Class'
        rule /@[a-z_]\w*/i, 'Name.Variable.Instance'
        rule /\$\w+/, 'Name.Variable.Global'
        rule %r(\$[!@&`'+~=/\\,;.<>_*\$?:"]), 'Name.Variable.Global'
        rule /\$-[0adFiIlpvw]/, 'Name.Variable.Global'
        rule /::/, 'Operator'

        mixin :strings

        # char operator.  ?x evaulates to "x", unless there's a digit
        # beforehand like x>=0?n[x]:""
        rule %r(
          \?(\\[MC]-)*     # modifiers
          (\\([\\abefnrstv\#"']|x[a-fA-F0-9]{1,2}|[0-7]{1,3})|\S)
          (?!\w)
        )x, 'Literal.String.Char'

        mixin :has_heredocs

        rule /[A-Z][a-zA-Z0-9_]+/, 'Name.Constant', :method_call
        rule /(\.|::)([a-z_]\w*[!?]?|[*%&^`~+-\/\[<>=])/,
          'Name.Function', :expr_start
        rule /[a-zA-Z_]\w*[?!]/, 'Name', :expr_start
        rule /[a-zA-Z_]\w*/, 'Name', :method_call
        rule /\[|\]|\*\*|<<?|>>?|>=|<=|<=>|=~|={3}|!~|&&?|\|\||\.{1,3}/,
          'Operator', :expr_start
        rule /[-+\/*%=<>&!^|~]=?/, 'Operator', :expr_start
        rule %r<[({,?:\\;/]>, 'Punctuation', :expr_start
        rule %r<[)}]>, 'Punctuation'
      end

      state :has_heredocs do
        rule /(?<!\w)(<<-?)(["`']?)([a-zA-Z_]\w*)(\2)/ do |m|
          token 'Operator', m[1]
          token 'Name.Constant', "#{m[2]}#{m[3]}#{m[4]}"
          @heredoc_queue << [m[1] == '<<-', m[3]]
          push :heredoc_queue unless state? :heredoc_queue
        end

        rule /(<<-?)(["'])(\2)/ do |m|
          token 'Operator', m[1]
          token 'Name.Constant', "#{m[2]}#{m[3]}#{m[4]}"
          @heredoc_queue << [m[1] == '<<-', '']
          push :heredoc_queue unless state? :heredoc_queue
        end
      end

      state :heredoc_queue do
        rule /(?=\n)/ do
          pop!; push :resolve_heredocs
        end

        mixin :root
      end

      state :resolve_heredocs do
        mixin :string_intp_escaped

        rule /(\n)([^#\\\n]*)$/ do |m|
          tolerant, heredoc_name = @heredoc_queue.first
          check = tolerant ? m[2].strip : m[2].rstrip

          group 'Literal.String.Heredoc'

          # check if we found the end of the heredoc
          if check == heredoc_name
            group 'Name.Constant'
            @heredoc_queue.shift
            # if there's no more, we're done looking.
            pop! if @heredoc_queue.empty?
          else
            group 'Literal.String.Heredoc'
          end
        end

        rule /[#\\\n]/, 'Literal.String.Heredoc'
        rule /[^#\\\n]+/, 'Literal.String.Heredoc'
      end

      state :funcname do
        rule /\s+/, 'Text'
        rule /\(/, 'Punctuation', :defexpr
        rule %r(
          (?:([a-zA-Z_][\w_]*)(\.))?
          (
            [a-zA-Z_][\w_]*[!?]? |
            \*\*? | [-+]@? | [/%&\|^`~] | \[\]=? |
            << | >> | <=?> | >=? | ===?
          )
        )x do |m|
          debug { "matches: #{[m[0], m[1], m[2], m[3]].inspect}" }
          group 'Name.Class'
          group 'Operator'
          group 'Name.Function'
          pop!
        end

        rule(//) { pop! }
      end

      state :classname do
        rule /\s+/, 'Text'
        rule /\(/, 'Punctuation', :defexpr

        # class << expr
        rule /<</, 'Operator', :pop!
        rule /[A-Z_]\w*/, 'Name.Class'

        rule(//) { pop! }
      end

      state :defexpr do
        rule /(\))(\.|::)?/ do
          group 'Punctuation'
          group 'Operator'
          pop!
        end
        rule /\(/, 'Operator', :defexpr
        mixin :root
      end

      state :in_interp do
        rule /}/, 'Literal.String.Interpol', :pop!
        mixin :root
      end

      state :string_intp do
        rule /\#{/, 'Literal.String.Interpol', :in_interp
        rule /#(@@?|\$)[a-z_]\w*/i, 'Literal.String.Interpol'
      end

      state :string_intp_escaped do
        mixin :string_intp
        rule /\\([\\abefnrstv#"']|x[a-fA-F0-9]{1,2}|[0-7]{1,3})/,
          'Literal.String.Escape'
        rule /\\./, 'Literal.String.Escape'
      end

      state :method_call do
        rule %r((\s+)(/)(?=\S|\s*/)) do
          group 'Text'
          group 'Literal.String.Regex'
          pop!
          push :slash_regex
        end

        rule(%r((?=\s*/))) { pop! }

        rule(//) { pop!; push :expr_start }
      end

      state :expr_start do
        rule %r((\s*)(/)) do
          group 'Text'
          group 'Literal.String.Regex'
          pop!
          push :slash_regex
        end

        # special case for using a single space.  Ruby demands that
        # these be in a single line, otherwise it would make no sense.
        rule /(\s*)(%[rqswQWxiI]? \S* )/ do
          group 'Text'
          group 'Literal.String.Other'
          pop!
        end

        rule(//) { pop! }
      end

      state :slash_regex do
        mixin :string_intp
        rule %r(\\\\), 'Literal.String.Regex'
        rule %r(\\/), 'Literal.String.Regex'
        rule %r([\\#]), 'Literal.String.Regex'
        rule %r([^\\/#]+)m, 'Literal.String.Regex'
        rule %r(/) do
          token 'Literal.String.Regex'
          pop!; push :regex_flags
        end
      end

      state :end_part do
        # eat up the rest of the stream as Comment.Preproc
        rule /.+/m, 'Comment.Preproc', :pop!
      end
    end
  end
end
