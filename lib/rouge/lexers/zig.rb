# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Zig < RegexLexer
      tag 'zig'
      aliases 'zir'
      filenames '*.zig, *.zir'
      mimetypes 'text/x-zig'

      def self.keywords 
        @keywords ||= %w(
          align linksection threadlocal struct enum union error break return continue asm defer errdefer
          const var extern packed export pub noalias inline noinline comptime callconv volatile allowzero
          null undefined usingnamespace test void noreturn type anyerror anyframe fn true false
          unreachable try catch async suspend nosuspend await resume if else switch and or orelse while for
        )
      end

      def self.builtins
        @builtins ||= %w(
          @addWithOverflow @as @atomicLoad @atomicStore @bitCast @breakpoint
          @alignCast @alignOf @cDefine @cImport @cInclude
          @bitOffsetOf @byteOffsetOf @OpaqueType @panic @ptrCast
          @bitReverse @Vector @sin @cos @exp @exp2 @log @log2 @log10 @fabs @floor @ceil @trunc @round
          @cUndef @canImplicitCast @clz @cmpxchgWeak @cmpxchgStrong @compileError
          @compileLog @ctz @popCount @divExact @divFloor @divTrunc
          @embedFile @export @tagName @TagType @errorName @call
          @errorReturnTrace @fence @fieldParentPtr @field @unionInit
          @frameAddress @import @newStackCall @asyncCall @intToPtr
          @intCast @floatCast @intToFloat @floatToInt @boolToInt @errSetCast
          @intToError @errorToInt @intToEnum @enumToInt @setAlignStack @frame @Frame @frameSize 
          @memcpy @memset @mod @mulWithOverflow @splat
          @ptrToInt @rem @returnAddress @setCold @Type @shuffle
          @setGlobalLinkage @setGlobalSection @shlExact @This @hasDecl @hasField
          @setRuntimeSafety @setEvalBranchQuota @setFloatMode
          @shlWithOverflow @shrExact @sizeOf @bitSizeOf @sqrt @byteSwap @subWithOverflow 
          @truncate @typeInfo @typeName @TypeOf @atomicRmw @bytesToSlice @sliceToBytes
          bool f16 f32 f64 f128 i0 u0 isize usize comptime_int comptime_float c_short c_ushort c_int
          c_uint c_long c_ulong c_longlong c_ulonglong c_longdouble c_void
        )
      end

      state :whitespace do
        rule %r/\s+/, Text
        rule %r(//[^\n]*), Comment
      end

      state :root do
        mixin :whitespace
      end
    end
  end
end
