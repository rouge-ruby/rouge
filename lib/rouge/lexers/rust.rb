module Rouge
  module Lexers
    class Rust < RegexLexer
      desc 'The Rust programming language (rust-lang.org)'
      tag 'rust'
      aliases 'rs'
      # TODO: *.rc conflicts with the rc shell...
      filenames '*.rs', '*.rc'
      mimetypes 'text/x-rust'

      def self.analyze_text(text)
        return 1 if text.shebang? 'rustc'
      end

      def self.keywords
        @keywords ||= %w(
          as assert break const copy do drop else enum extern fail false
          fn for if impl let log loop match mod move mut priv pub pure
          ref return self static struct true trait type unsafe use while
        )
      end

      def self.builtins
        @builtins ||= Set.new %w(
          Add BitAnd BitOr BitXor bool c_char c_double c_float char
          c_int clock_t c_long c_longlong Cons Const Copy c_schar c_short
          c_uchar c_uint c_ulong c_ulonglong c_ushort c_void dev_t DIR
          dirent Div Either Eq Err f32 f64 Failure FILE float fpos_t
          i16 i32 i64 i8 Index ino_t int intptr_t Left mode_t Modulo Mul
          Neg Nil None Num off_t Ok Option Ord Owned pid_t Ptr ptrdiff_t
          Right Send Shl Shr size_t Some ssize_t str Sub Success time_t
          u16 u32 u64 u8 uint uintptr_t
        )
      end

      def macro_closed?
        @macro_delims.values.all?(&:zero?)
      end

      start {
        @macro_delims = { ']' => 0, ')' => 0, '}' => 0 }
      }

      delim_map = { '[' => ']', '(' => ')', '{' => '}' }

      id = /[a-z_]\w*/i
      hex = /[0-9a-f]/i
      escapes = %r(
        \\ ([nrt'\\] | x#{hex}{2} | u#{hex}{4} | U#{hex}{8})
      )x
      size = /8|16|32|64/

      state :start_line do
        mixin :whitespace
        rule /\s+/, 'Text'
        rule /#\[/ do
          token 'Comment.Preproc'; push :attribute
        end
        rule(//) { pop! }
      end

      state :attribute do
        mixin :whitespace
        mixin :has_literals
        rule /[(,)=]/, 'Comment.Preproc'
        rule /\]/, 'Comment.Preproc', :pop!
        rule id, 'Comment.Preproc'
      end

      state :whitespace do
        rule /\s+/, 'Text'
        rule %r(//[^\n]*), 'Comment'
        rule %r(/[*].*?[*]/)m, 'Comment.Multiline'
      end

      state :root do
        rule /\n/, 'Text', :start_line
        mixin :whitespace
        rule /\b(?:#{Rust.keywords.join('|')})\b/, 'Keyword'
        mixin :has_literals

        rule %r([=-]>), 'Keyword'
        rule %r(<->), 'Keyword'
        rule /[()\[\]{}|,:;]/, 'Punctuation'
        rule /[*!@~&+%^<>=-]/, 'Operator'

        rule /([.]\s*)?#{id}(?=\s*[(])/m, 'Name.Function'
        rule /[.]\s*#{id}/, 'Name.Property'
        rule /(#{id})(::)/m do
          group 'Name.Namespace'; group 'Punctuation'
        end

        # macros
        rule /\bmacro_rules!/, 'Name.Decorator', :macro_rules
        rule /#{id}!/, 'Name.Decorator', :macro

        rule /#{id}/ do |m|
          name = m[0]
          if self.class.builtins.include? name
            token 'Name.Builtin'
          else
            token 'Name'
          end
        end
      end

      state :macro do
        mixin :has_literals

        rule /[\[{(]/ do |m|
          @macro_delims[delim_map[m[0]]] += 1
          debug { "    macro_delims: #{@macro_delims.inspect}" }
          token 'Punctuation'
        end

        rule /[\]})]/ do |m|
          @macro_delims[m[0]] -= 1
          debug { "    macro_delims: #{@macro_delims.inspect}" }
          pop! if macro_closed?
          token 'Punctuation'
        end

        # same as the rule in root, but don't push another macro state
        rule /#{id}!/, 'Name.Decorator'
        mixin :root

        # No syntax errors in macros
        rule /./, 'Text'
      end

      state :macro_rules do
        rule /[$]#{id}(:#{id})?/, 'Name.Variable'
        rule /[$]/, 'Name.Variable'

        mixin :macro
      end

      state :has_literals do
        # constants
        rule /\b(?:true|false|nil)\b/, 'Keyword.Constant'
        # characters
        rule %r(
          ' (?: #{escapes} | [^\\] ) '
        )x, 'Literal.String.Char'

        rule /"/, 'Literal.String', :string

        # numbers
        dot = /[.][0-9_]+/
        exp = /e[-+]?[0-9_]+/
        flt = /f32|f64/

        rule %r(
          [0-9]+
          (#{dot}  #{exp}? #{flt}?
          |#{dot}? #{exp}  #{flt}?
          |#{dot}? #{exp}? #{flt}
          )
        )x, 'Literal.Number.Float'

        rule %r(
          ( 0b[10_]+
          | 0x[0-9a-fA-F-]+
          | [0-9]+
          ) (u#{size}?|i#{size})?
        )x, 'Literal.Number.Integer'

      end

      state :string do
        rule /"/, 'Literal.String', :pop!
        rule escapes, 'Literal.String.Escape'
        rule /%%/, 'Literal.String.Interpol'
        rule %r(
          %
          ( [0-9]+ [$] )?  # Parameter
          [0#+-]*          # Flag
          ( [0-9]+ [$]? )? # Width
          ( [.] [0-9]+ )?  # Precision
          [bcdfiostuxX?]   # Type
        )x, 'Literal.String.Interpol'
        rule /[^%"\\]+/m, 'Literal.String'
      end
    end
  end
end
