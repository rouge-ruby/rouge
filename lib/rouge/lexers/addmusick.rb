module Rouge
  module Lexers
    class AddmusicK < RegexLexer
      title 'AddmusicK'
      desc 'AddmusicK and Ramekin MML (https://smwc.me/s/37906)'
      tag 'addmusick'
      aliases 'ramekin', 'addmusickff', 'amk', 'rmk'

      filenames '*.amk', '*.rmk', '*.mml'

      KEYWORDS = Set.new %w(
        samples instruments instrument path default optimized pack
      )

      def self.detect?(analyzer)
        return true if analyzer.match?(/\A(\s+|;.*?$)*#spc\s*[{]/i)
        return true if analyzer.match?(/\A(\s+|;.*?$)*#option smwvtable\b/i)
        return true if analyzer.match?(/\A(\s+|;.*?$)*#amk \d/i)
      end

      def initialize(*)
        super

        @highlight_macros = bool_option(:macros) { true }
      end

      def note_token
        return Str if @last == :rest
        return Name::Function if @last == :fade || @last == :arp
        Str::Symbol
      end

      # override
      # [jneen] This override is required because AddmusicK has an extremely
      # free-form macro system that doesn't "look like a function call" the same
      # way that normal preproc macros do. They are quite literally arbitrary
      # characters that pre-empt other tokens, in all states.
      #
      # AddmusicK is technically *even more* lenient than this about where macros
      # can show up, e.g. "F=v123" will attempt to substitute into $FF twice.
      # Neither Ramekin nor this lexer support that.
      def step(state, stream)
        if @highlight_macros
          @macros.reverse_each do |macro|
            if stream.skip(macro)
              token Comment::Preproc
              return true
            end
          end
        end

        super(state, stream)
      end

      start do
        @macros = []
      end

      state :whitespace do
        rule %r/\s+/, Text
        rule %r/;.*/, Comment
      end

      state :ties do
        rule %r/\^/ do
          token(note_token)
          push :post_note
        end
      end

      state :root do
        mixin :whitespace
        rule %r/#spc/i, Keyword, :spc_pre
        rule %r/(#amk)(\s+)(\d+)/ do
          groups Keyword, Text, Num
        end

        rule %r/(#option)(\s+)(\w+)/ do
          groups Keyword, Text, Name::Tag
        end

        rule %r/#path\b/, Keyword, :string_arg
        rule %r/#tune:\S+/, Operator::Word
        rule %r(#legato/toggle), Operator::Word
        rule %r(#sustain/global-toggle), Operator::Word
        rule %r(#echo/toggle), Operator::Word
        rule %r(#amplify:\d+), Operator::Word
        rule %r(#echo/\w+:\S+), Comment::Preproc
        rule %r(#tuning:\h\h\h\h), Operator::Word
        arg = %r(\d+|max(?:-\d+)?)
        rule %r(#adsr:#{arg}(?:,#{arg}){3}), Operator::Word
        rule %r(#adsr:(?:flat|reset)), Operator::Word
        rule %r(#incompatible:\w+), Comment::Preproc
        rule %r(#bpm:\d+), Operator::Word
        rule %r(#arp/off), Operator::Word
        rule %r/#(?:arp|gliss)\[/ do
          token Operator::Word
          @last = :arp
          push :arp
          push :post_note
        end

        rule %r(#ifn?def\s*\w+), Comment::Preproc

        rule %r/[$]\h\h/, Name::Tag
        rule %r/@\d+/, Name::Tag
        rule %r/@\w+/, Name::Tag

        rule %r/[itwl]\d+/, Name::Function
        rule %r/[uvh_][+-]?\d+/, Name::Function
        rule %r/y[LR]?\d+/, Name::Function
        rule %r/y[C]/, Name::Function
        rule %r/o\d/, Name::Function
        rule %r/q\d\h/, Name::Function

        rule %r/[a-g][+-]?/ do
          @last = :note
          token Str::Symbol
          push :post_note
        end

        mixin :ties

        rule %r/#[.][\w-]*/, Name::Label

        rule %r/\\/ do
          @last = :fade
          token Name::Function
          push :post_note
        end

        rule %r/r/ do
          @last = :rest
          token Str
          push :post_note
        end

        rule %r/p\d+,\d+(?:,\d+)?/, Name::Function

        rule %r/#\d/ do
          token Name::Namespace
          @last = nil
        end

        rule %r/#(\w+)/ do |m|
          if KEYWORDS.include?(m[1])
            token Keyword
          else
            token Name::Class
          end
        end

        rule %r/("\s*)(\S+?)(\s*)(=)/ do |m|
          @macros << m[2]
          @macros.sort_by!(&:size)
          groups Comment::Preproc, Name::Class, Comment::Preproc, Comment::Preproc
          push :macro
        end

        rule %r/".*?"/m, Str::Double
        rule %r([{},/<>~&'`]), Punctuation
        rule %r([|]) do
          token Punctuation
          @last = nil
        end

        rule %r/[(][!]/, Name::Namespace, :remote

        rule %r/[(]\s*[\w-]+\s*[)]\d*/ do
          token Name::Namespace
          @last = nil
        end

        rule %r/[*]\d*/ do
          token Name::Namespace
          @last = nil
        end

        rule %r/\[\[?/, Name::Namespace
        rule %r/\]\]?\d*/ do
          token Name::Namespace
          @last = nil
        end

        rule %r/./ do
          if @highlight_macros
            fallthrough!
          else
            token Text
          end
        end
      end

      state :post_note do
        rule(/=\d+/) { token(note_token); pop! }
        rule(/\d+[.]*/) { token(note_token); pop! }
        rule(//) { pop! }
      end

      state :string_arg do
        mixin :whitespace
        rule %r/".*?"/, Str::Double, :pop!
        rule(//) { pop! }
      end

      state :spc_pre do
        mixin :whitespace
        rule %r/[{]/, Punctuation, :spc
        rule(//) { pop! }
      end

      state :spc do
        mixin :whitespace
        rule %r/#(?:title|author|game|comment)/, Name::Attribute
        rule %r/".*?"/, Str::Double
        rule(/[}]/) { token Punctuation; pop! 2 }
      end

      state :macro do
        rule %r/"/, Comment::Preproc, :pop!
        mixin :root
      end

      state :arp do
        mixin :whitespace
        mixin :ties
        rule %r([:/]), Punctuation
        rule %r/[+-]?\d+/, Num
        rule %r/\]/, Operator::Word, :pop!
      end

      state :remote do
        mixin :whitespace
        rule %r/,/, Punctuation
        rule %r/\d+/, Name::Namespace
        rule %r/#\w+/, Keyword
        rule %r/\w+/, Name::Namespace
        rule %r/[)]/, Name::Namespace, :pop!
      end
    end
  end
end
