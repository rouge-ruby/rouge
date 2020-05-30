# -*- coding: utf-8 -*- #
# frozen_string_literal: true

# uses the rust lexer as a starting point

module Rouge
  module Lexers
    class Zig < RegexLexer
      tag 'zig'
      aliases 'zir'
      filenames '*.zig'
      mimetypes 'text/x-zig'

      title 'Zig'
      desc 'The Zig programming language'

      def self.keywords 
        @keywords ||= %w(
          align linksection threadlocal struct enum union error break return
          continue asm defer errdefer const var extern packed export pub
          noalias inline noinline comptime callconv volatile allowzero null
          undefined usingnamespace test void noreturn type anyerror anyframe fn
          true false unreachable try catch async suspend nosuspend await resume
          if else switch and or orelse while for
        )
      end

      def self.builtins
        @builtins ||= %w(
          @addWithOverflow @as @atomicLoad @atomicStore @bitCast @breakpoint
          @alignCast @alignOf @cDefine @cImport @cInclude @bitOffsetOf
          @byteOffsetOf @OpaqueType @panic @ptrCast @bitReverse @Vector @sin
          @cos @exp @exp2 @log @log2 @log10 @fabs @floor @ceil @trunc @round
          @cUndef @canImplicitCast @clz @cmpxchgWeak @cmpxchgStrong
          @compileError @compileLog @ctz @popCount @divExact @divFloor
          @divTrunc @embedFile @export @tagName @TagType @errorName @call
          @errorReturnTrace @fence @fieldParentPtr @field @unionInit
          @frameAddress @import @newStackCall @asyncCall @intToPtr @intCast
          @floatCast @intToFloat @floatToInt @boolToInt @errSetCast @intToError
          @errorToInt @intToEnum @enumToInt @setAlignStack @frame @Frame
          @frameSize @memcpy @memset @mod @mulWithOverflow @splat @ptrToInt
          @rem @returnAddress @setCold @Type @shuffle @setGlobalLinkage
          @setGlobalSection @shlExact @This @hasDecl @hasField
          @setRuntimeSafety @setEvalBranchQuota @setFloatMode @shlWithOverflow
          @shrExact @sizeOf @bitSizeOf @sqrt @byteSwap @subWithOverflow
          @truncate @typeInfo @typeName @TypeOf @atomicRmw @bytesToSlice
          @sliceToBytes bool f16 f32 f64 f128 i0 u0 isize usize comptime_int
          comptime_float c_short c_ushort c_int c_uint c_long c_ulong
          c_longlong c_ulonglong c_longdouble c_void
        )
      end

      id = /[a-z_]\w*/i
      hex = /[0-9a-f]/i
      escapes = %r(
      \\ ([nrt'"\\0] | x#{hex}{2} | u#{hex}{4} | U#{hex}{8})
      )x
      size = /8|16|32|64/

      state :bol do
        mixin :whitespace
        rule %r/#\s[^\n]*/, Comment::Special
        rule(//) { pop! }
      end

      state :attribute do
        mixin :whitespace
        mixin :has_literals
        rule %r/[(,)=:]/, Name::Decorator
        rule %r/\]/, Name::Decorator, :pop!
        rule id, Name::Decorator
      end

      state :whitespace do
        rule %r/\s+/, Text
        rule %r(//[^\n]*), Comment
      end

      state :root do
        rule %r/\n/, Text, :bol
        mixin :whitespace
        rule %r/#!?\[/, Name::Decorator, :attribute
        rule %r/\b(?:#{Zig.keywords.join('|')})\b/, Keyword
        mixin :has_literals

        rule %r([=-]>), Keyword
        rule %r(<->), Keyword
        rule %r/[()\[\]{}|,:;]/, Punctuation
        rule %r/[*\/!@~&+%^<>=\?-]|\.{1,3}/, Operator

        rule %r/([.]\s*)?#{id}(?=\s*[(])/m, Name::Function
          rule %r/[.]\s*#{id}/, Name::Property
          rule %r/(#{id})(::)/m do
            groups Name::Namespace, Punctuation
          end

          rule %r/'#{id}/, Name::Variable
          rule %r/#{id}/ do |m|
            name = m[0]
            if self.class.builtins.include? name
              token Name::Builtin
            else
              token Name
            end
          end
      end

      state :has_literals do
        # constants
        rule %r/\b(?:true|false|nil)\b/, Keyword::Constant
        # characters
        rule %r(
        ' (?: #{escapes} | [^\\] ) '
        )x, Str::Char

        rule %r/"/, Str, :string
        rule %r/r(#*)".*?"\1/m, Str

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
        )x, Num::Float

        rule %r(
        ( 0b[10_]+
         | 0x[0-9a-fA-F_]+
         | [0-9_]+
        ) (u#{size}?|i#{size})?
        )x, Num::Integer
      end

      state :string do
        rule %r/"/, Str, :pop!
        rule escapes, Str::Escape
        rule %r/[^"\\]+/m, Str
      end
    end
  end
end
