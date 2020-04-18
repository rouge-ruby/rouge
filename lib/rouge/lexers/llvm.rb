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
          acq_rel acquire addrspace addrspacecast afn alias aliasee align
          alignLog2 alignstack allOnes allocsize alwaysinline amdgpu_cs
          amdgpu_es amdgpu_gs amdgpu_hs amdgpu_kernel amdgpu_ls amdgpu_ps
          amdgpu_vs any anyregcc appending arcp argmemonly args arm_aapcs_vfpcc
          arm_aapcscc arm_apcscc asm atomic attributes available_externally
          begin bit bitMask blockaddress branchFunnel builtin byArg byte
          byteArray byval c callee caller calls cc ccc cold coldcc comdat
          common constant contract convergent critical cxx_fast_tlscc
          datalayout dbg declare default define dereferenceable
          dereferenceable_or_null distinct dllexport dllimport dsoLocal
          dso_local dso_preemptable end eq exact exactmatch extern_weak
          external externally_initialized false fast fastcc filter flags from
          funcFlags gc global guid gv hash hidden hot hotness ifunc immarg
          inaccessiblemem_or_argmemonly inaccessiblememonly inalloca inbounds
          indir info initialexec inlineBits inlinehint inrange inreg insts
          inteldialect internal jumptable kind landingpad largest linkage
          linker_private linkonce linkonce_odr live local_unnamed_addr
          localdynamic localexec max min minsize module monotonic musttail
          naked name nand ne nest ninf nnan no-jump-tables noRecurse noalias
          nobuiltin nocapture nocf_check noduplicate noduplicates
          noimplicitfloat noinline nonlazybind nonnull norecurse noredzone
          noredzone noreturn notEligibleToImport notail nounwind nsw nsz null
          nuw oeq offset oge ogt ole olt one opaque optforfuzzing optnone
          optsize ord path personality prefix preserve_allcc preserve_mostcc
          private prologue protected ptx_device ptx_kernel readNone readOnly
          readnone readonly reassoc refs relbf release resByArg
          returnDoesNotAlias returned returns_twice safestack samesize
          sanitize_address sanitize_hwaddress sanitize_memory sanitize_thread
          section seq_cst sge sgt shadowcallstack sideeffect signext single
          singleImpl singleImplName sizeM1 sizeM1BitWidth sle slt
          source_filename speculatable speculative_load_hardening sret ssp
          sspreq sspstrong strictfp summaries summary swiftcc swifterror
          swiftself syncscope tail target thread_local to triple true type
          typeCheckedLoadConstVCalls typeCheckedLoadVCalls typeIdInfo
          typeTestAssumeConstVCalls typeTestAssumeVCalls typeTestRes typeTests
          typeid ueq uge ugt ule ult umax umin undef une uniformRetVal
          uniqueRetVal unnamed_addr uno unordered unsat uselistorder
          uselistorder_bb uwtable vFuncId virtualConstProp volatile weak
          weak_odr webkit_jscc willreturn within wpdRes wpdResolutions
          writeonly x x86_fastcallcc x86_stdcallcc xchg zeroext zeroinitializer
        )
      end

      def self.instructions
        @instructions ||= Set.new %w(
          add alloca and ashr atomicrmw bitcast br call catch catchpad catchret
          catchswitch cleanup cleanuppad cleanupret cmpxchg extractelement
          extractvalue fadd fcmp fdiv fence fmul fpext fptosi fptoui fptrunc
          free frem fsub getelementptr getresult icmp indirectbr insertelement
          insertvalue inttoptr invoke load lshr malloc mul or phi ptrtoint
          resume ret sdiv select sext shl shufflevector sitofp srem store sub
          switch trunc udiv uitofp unreachable unwind urem va_arg xor zext
        )
      end

      def self.types
        @types ||= Set.new %w(
          double float fp128 half label metadata ppc_fp128 token void x86_fp80
          x86_mmx x86mmx
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
