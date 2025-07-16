# -*- coding: utf-8 -*- #
# frozen_string_literal: true

# Note that like most assembly languages there's no proper grammar for RISC-V assembly.
# It's pretty much "what do GCC and Clang accept". I recommend not trying to read
# their source code because it's a complete mess.

module Rouge
  module Lexers
    class RiscvAsm < RegexLexer
      title "RiscvAsm"
      desc "RISC-V assembly syntax"
      tag 'riscvasm'
      filenames '*.s', '*.S'

      # C preprocessor directives. These are only processed for .S files - not .s - however
      # the parsing is the same in both cases.
      def self.preproc_directive
        @preproc_directive ||= %w(
          define elif else endif error if ifdef ifndef include line pragma undef warning
        )
      end

      # Standard register name, including ABI names.
      def self.register
        @register ||= %w(
          x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 x20 x21 x22 x23 x24 x25 x26 x27 x28 x29 x30 x31
          f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20 f21 f22 f23 f24 f25 f26 f27 f28 f29 f30 f31
          v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 v16 v17 v18 v19 v20 v21 v22 v23 v24 v25 v26 v27 v28 v29 v30 v31
          zero ra sp gp tp t0 t1 t2 s0 fp s1 a0 a1 a2 a3 a4 a5 a6 a7 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 t3 t4 t5 t6
          ft0 ft1 ft2 ft3 ft4 ft5 ft6 ft7 fs0 fs1 fa0 fa1 fa2 fa3 fa4 fa5 fa6 fa7 fs2 fs3 fs4 fs5 fs6 fs7 fs8 fs9 fs10 fs11 ft8 ft9 ft10 ft11
        )
      end

      # These keywords are used for some vector instructions (vsetvli etc.).
      def self.other_keyword
        @other_keyword ||= %w(
          e8 e16 e32 e64 mf8 mf4 mf2 m1 m2 m4 m8 ta tu ma mu v0.t
        )
      end

      # For %pcrel_hi(...) relocations etc.
      def self.relocation_function
        @relocation_function ||= %w(
          hi lo
          pcrel_hi pcrel_lo
          tprel_hi tprel_lo
          tprel_add
          tls_ie_pcrel_hi
          tls_gd_pcrel_hi
          got_pcrel_hi
        )
      end

      state :comments_and_whitespace do
        # Don't eat newlines because those are significant.
        rule %r/[ \t]+/, Text::Whitespace
        rule %r((//|#).*), Comment::Single
        rule %r(/\*.*?\*/)m, Comment::Multiline
      end

      state :literals do
        # 1f, 2b forward/backward label references.
        rule %r/[0-9]+[fb]\b/, Name::Label

        # Octal
        rule %r/\-?0[0-7]+\b/, Num::Oct
        # Binary
        rule %r/\-?0b[01]+\b/, Num::Integer
        # Hex
        rule %r/\-?0x[0-9a-fA-F]+\b/, Num::Hex
        # Decimal
        rule %r/\-?[0-9]+\b/, Num::Integer

        # Float. RISC-V supposedly supports C float literals but I doubt
        # it really supports all the hex variants etc.
        # This is not quite accurate since you can have e.g. `.3`.
        rule %r/\-?[0-9]+\.[0-9]*([eE]-?[0-9]+)?[fFlL]?\b/, Num::Float

        # Strings.
        rule %r/"(\\\\|\\"|[^"])*"/, Str::Double
        rule %r/'(\\\\|\\'|[^'])*'/, Str::Single
      end

      state :root do
        # Preprocessor directive. Awkwardly these are the same as single line comments.
        # It seems like GCC will silently ignore unknown directives so that comments
        # work - even for `.s` files. Yes that means if you have a typo like
        #
        #     #defien DISABLE_DEV_BACKDOOR 1
        #
        # Then it will silently ignore it!
        #
        rule %r/^[ \t]*#[ \t]*(:?#{RiscvAsm.preproc_directive.join('|')})\b/, Comment::Preproc, :preprocessor_directive

        mixin :comments_and_whitespace

        # End of line.
        rule %r/\n/, Text::Whitespace

        # Assembly directive.
        rule %r/\.\w+/, Name::Attribute, :directive

        # Label.
        rule %r/((\w+)|(\d+)):/, Name::Label

        # Instruction or maybe macro call.
        rule %r/[\w\.]+\b/, Name::Builtin, :args
      end

      state :preprocessor_directive do
        mixin :comments_and_whitespace
        mixin :literals

        # Escaped newline. This is one case where you can't parse
        # .S and .s the same - if you try to escape a newline in a
        # preprocessor directive in .S it will work but in .s it
        # will be ignored. Here we assume .S.
        rule %r/\\\n/, Text

        rule %r/./, Text
        rule %r/\n/, Text, :pop!
      end

      state :directive do
        mixin :comments_and_whitespace
        mixin :literals

        rule %r/./, Text
        rule %r/\n/, Text, :pop!
      end

      state :args do
        mixin :comments_and_whitespace
        mixin :literals

        # End of instruction.
        rule %r/[;\n]/, Text::Whitespace, :pop!

        # Register names.
        rule %r/(?:#{RiscvAsm.register.join('|')})\b/, Name::Constant
        # Other keywords.
        rule %r/(?:#{RiscvAsm.other_keyword.join('|')})\b/, Name::Constant
        # Relocations
        rule %r/%(?:#{RiscvAsm.relocation_function.join('|')})\b/, Name::Builtin

        # Operators
        rule %r/[-~*\/%<>|&\^!+(),]/, Operator
        # Variables.
        rule %r/\\?[\$\w]+/, Name::Variable
      end
    end
  end
end
