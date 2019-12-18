# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class LLVM < RegexLexer
      title "LLVM"
      desc 'The LLVM Compiler Infrastructure (http://llvm.org/)'
      tag 'llvm'

      filenames '*.ll'
      mimetypes 'text/x-llvm'

      string = /"[^"]*?"/
      identifier = /([-a-zA-Z$._][-a-zA-Z$._0-9]*|#{string})/

      def self.keywords
        @keywords ||= Set.new %w(
          addrspace addrspacecast alias align alignstack allocsize alwaysinline
          appending arcp argmemonly arm_aapcs_vfpcc arm_aapcscc arm_apcscc asm
          attributes available_externally begin builtin byval c cc ccc cold
          coldcc common constant convergent datalayout dbg declare default
          define dllexport dllimport end eq exact extern_weak external false
          fast fastcc gc global hidden inaccessiblemem_or_argmemonly
          inaccessiblememonly inbounds inlinehint inreg internal jumptable
          landingpad linker_private linkonce linkonce_odr minsize module naked
          ne nest ninf nnan no-jump-tables noalias nobuiltin nocapture
          nocf_check noduplicate noimplicitfloat noinline nonlazybind norecurse
          noredzone noredzone noreturn nounwind nsw nsz null nuw oeq oge ogt
          ole olt one opaque optforfuzzing optnone optsize ord personality
          private protected ptx_device ptx_kernel readnone readonly
          returns_twice safestack sanitize_address sanitize_hwaddress
          sanitize_memory sanitize_thread section sge sgt shadowcallstack
          sideeffect signext sle slt speculatable speculative_load_hardening
          sret ssp sspreq sspstrong strictfp tail target thread_local to triple
          true type ueq uge ugt ule ult undef une unnamed_addr uno uwtable
          volatile weak weak_odr writeonly x x86_fastcallcc x86_stdcallcc
          zeroext zeroinitializer
        )
      end

      def self.instructions
        @instructions ||= Set.new %w(
          add alloca and ashr bitcast br call catch cleanup extractelement
          extractvalue fadd fcmp fdiv fmul fpext fptosi fptoui fptrunc free
          frem fsub getelementptr getresult icmp insertelement insertvalue
          inttoptr invoke load lshr malloc mul or phi ptrtoint resume ret sdiv
          select sext shl shufflevector sitofp srem store sub switch trunc udiv
          uitofp unreachable unwind urem va_arg xor zext
        )
      end

      def self.types
        @types ||= Set.new %w(
          double float fp128 half label metadata ppc_fp128 void x86_fp80 x86mmx
        )
      end

      state :basic do
        rule %r/;.*?$/, Comment::Single
        rule %r/\s+/, Text

        rule %r/#{identifier}\s*:/, Name::Label

        rule %r/@(#{identifier}|\d+)/, Name::Variable::Global
        rule %r/#\d+/, Name::Variable::Global
        rule %r/(%|!)#{identifier}/, Name::Variable
        rule %r/(%|!)\d+/, Name::Variable

        rule %r/c?#{string}/, Str

        rule %r/0[xX][a-fA-F0-9]+/, Num
        rule %r/-?\d+(?:[.]\d+)?(?:[eE][-+]?\d+(?:[.]\d+)?)?/, Num

        rule %r/[=<>{}\[\]()*.,!]|x/, Punctuation
      end

      state :root do
        mixin :basic

        rule %r/i[1-9]\d*/, Keyword::Type

        rule %r/\w+/ do |m|
          if self.class.types.include? m[0]
            token Keyword::Type
          elsif self.class.instructions.include? m[0]
            token Keyword
          elsif self.class.keywords.include? m[0]
            token Keyword
          else
            token Error
          end
        end
      end
    end
  end
end
