# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Verilog < RegexLexer
      tag 'verilog'
      aliases 'systemverilog', 'sv'
      filenames '*.v', '*.sv', '*.svh'
      mimetypes 'text/x-chdr', 'text/x-csrc'

      title "SystemVerilog"
      desc "SystemVerilog HDVL"

      # optional comment or whitespace
      ws = %r((?:\s|//.*?\n|/[*].*?[*]/)+)
      id = /[a-zA-Z_][a-zA-Z0-9_]*/

      def self.keywords
        @keywords ||= Set.new %w(
        accept_on alias always always_comb always_ff always_latch and
        assert assign assume automatic before begin bind bins binsof
        break case casex casez cell checker class clocking cmos config
        constraint context continue cover covergroup coverpoint cross
        deassign default defparam design disable dist do edge else end
        endcase endchecker endclass endclocking endconfig endfunction
        endgenerate endgroup endinterface endmodule endpackage
        endprimitive endprogram endproperty endspecify endsequence
        endtable endtask enum eventually expect export extends extern
        final first_match for force foreach forever fork forkjoin
        function generate genvar global highz0 highz1 if iff ifnone
        ignore_bins illegal_bins implements implies import incdir
        include initial inside instance interconnect interface
        intersect join join_any join_none large let liblist library
        local localparam logic longint macromodule matches medium
        modport module nand negedge nettype new nexttime nmos nor
        noshowcancelled not notif0 notif1 null or output package
        packed parameter pmos posedge primitive priority program
        property protected pull0 pull1 pulldown pullup
        pulsestyle_ondetect pulsestyle_onevent pure randcase
        randsequence rcmos reject_on release repeat restrict return
        rnmos rpmos rtran rtranif0 rtranif1 s_always s_eventually
        s_nexttime s_until s_until_with scalared sequence
        showcancelled small soft solve specify struct super
        sync_accept_on sync_reject_on table tagged task this
        throughout timeprecision timeunit tran tranif0 tranif1 type
        typedef union unique unique0 until until_with untyped use
        uwire var vectored virtual wait wait_order wand weak while
        wildcard with within wor xnor xor ) end

      def self.keywords_type
        @keywords_type ||= Set.new %w(
        logic bit reg wire wor wand int longint real shortint float
        byte char unsigned signed void input output integer signed
        shortreal realtime ref reg supply0 supply1 strong0 strong1 tri
        tri0 tri1 triand trior trireg strong static string specparam
        time unsigned wand weak0 weak1 chandle buf bufif0 bufif1 const
        rand randc event
        )
      end

      def self.reserved
        @reserved ||= Set.new %w(
          
        )
      end

      # high priority for filename matches
      def self.analyze_text(*)
        0.3
      end

      def self.builtins
        @builtins ||= Set.new %w(
        $display $write $dumpon $dumpoff $finish
        )
      end

      start { push :bol }

      state :expr_bol do
        mixin :inline_whitespace

        rule /\`if\s0/, Comment, :if_0
        rule /\`/, Comment::Preproc, :macro

        rule(//) { pop! }
      end

      # :expr_bol is the same as :bol but without labels, since
      # labels can only appear at the beginning of a statement.
      state :bol do
        rule /#{id}:(?!:)/, Name::Label
        mixin :expr_bol
      end

      state :inline_whitespace do
        rule /[ \t\r]+/, Text
        rule /\\\n/, Text # line continuation
        rule %r(/(\\\n)?[*].*?[*](\\\n)?/)m, Comment::Multiline
      end

      state :whitespace do
        rule /\n+/m, Text, :bol
        rule %r(//(\\.|.)*?\n), Comment::Single, :bol
        mixin :inline_whitespace
      end

      state :expr_whitespace do
        rule /\n+/m, Text, :expr_bol
        mixin :whitespace
      end

      state :statements do
        mixin :whitespace
        rule /L?"/, Str, :string
        rule %r(L?'(\\.|\\[0-7]{1,3}|\\x[a-f0-9]{1,2}|[^\\'\n])')i, Str::Char
        rule %r((\d+[.]\d*|[.]?\d+)e[+-]?\d+[lu]*)i, Num::Float
        rule %r(\d+e[+-]?\d+[lu]*)i, Num::Float
        rule /[0-9]*`h[0-9a-f]+/i, Num::Hex
        rule /[0-9]*`b[0-1]+/i, Num::binary
        rule /0[0-7]+/i, Num::Oct
        rule /\d/i, Num::Integer
        rule %r(\*/), Error
        rule %r([~!%^&*+=\|?:<>/-]), Operator
        rule /[()\[\],.]/, Punctuation
        rule /\bcase\b/, Keyword, :case
        rule /(?:true|false|NULL)\b/, Name::Builtin
        rule id do |m|
          name = m[0]

          if self.class.keywords.include? name
            token Keyword
          elsif self.class.keywords_type.include? name
            token Keyword::Type
          elsif self.class.reserved.include? name
            token Keyword::Reserved
          elsif self.class.builtins.include? name
            token Name::Builtin
          else
            token Name
          end
        end
      end

      state :case do
        rule /:/, Punctuation, :pop!
        mixin :statements
      end

      state :root do
        mixin :expr_whitespace

        # functions
        rule %r(
          ([\w*\s]+?[\s*]) # return arguments
          (#{id})          # function name
          (\s*\([^;]*?\))  # signature
          (#{ws})({)         # open brace
        )mx do |m|
          # TODO: do this better.
          recurse m[1]
          token Name::Function, m[2]
          recurse m[3]
          recurse m[4]
          token Punctuation, m[5]
          push :function
        end

        # function declarations
        rule %r(
          ([\w*\s]+?[\s*]) # return arguments
          (#{id})          # function name
          (\s*\([^;]*?\))  # signature
          (#{ws})(;)       # semicolon
        )mx do |m|
          # TODO: do this better.
          recurse m[1]
          token Name::Function, m[2]
          recurse m[3]
          recurse m[4]
          token Punctuation, m[5]
          push :statement
        end

        rule(//) { push :statement }
      end

      state :statement do
        rule /;/, Punctuation, :pop!
        mixin :expr_whitespace
        mixin :statements
        rule /[{}]/, Punctuation
      end

      state :function do
        mixin :whitespace
        mixin :statements
        rule /;/, Punctuation
        rule /{/, Punctuation, :function
        rule /}/, Punctuation, :pop!
      end

      state :string do
        rule /"/, Str, :pop!
        rule /\\([\\abfnrtv"']|x[a-fA-F0-9]{2,4}|[0-7]{1,3})/, Str::Escape
        rule /[^\\"\n]+/, Str
        rule /\\\n/, Str
        rule /\\/, Str # stray backslash
      end

      state :macro do
        # NB: pop! goes back to :bol
        rule /\n/, Comment::Preproc, :pop!
        rule %r([^/\n\\]+), Comment::Preproc
        rule /\\./m, Comment::Preproc
        mixin :inline_whitespace
        rule %r(/), Comment::Preproc
      end

      state :if_0 do
        # NB: no \b here, to cover #ifdef and #ifndef
        rule /^\s*#if/, Comment, :if_0
        rule /^\s*#\s*el(?:se|if)/, Comment, :pop!
        rule /^\s*#\s*endif\b.*?(?<!\\)\n/m, Comment, :pop!
        rule /.*?\n/, Comment
      end
    end
  end
end
