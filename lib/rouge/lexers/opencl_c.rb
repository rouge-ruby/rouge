# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    load_lexer 'c.rb'

    class OpenCLC < C
      tag 'opencl_c'
      title "OpenCL C"
      desc 'the OpenCL C programming language used to create kernels that are executed on OpenCL devices'
      aliases 'opencl'
      filenames '*.cl', '*.c', '*.h'

      mimetypes 'text/x-opencl_c', 'application/x-opencl_c'

      def self.keywords_type
        @keywords_type ||= Set.new %w(
          size_t ptrdiff_t intptr_t uintptr_t void

          unsigned
          bool 
          char cl_char uchar cl_uchar
          short cl_short ushort cl_ushort
          int cl_int int uint cl_uint
          long cl_long ulong cl_ulong
          float cl_float
          double cl_double
          half
          
          char2 char3 char4 char8 char16
          cl_char2 cl_char3 cl_char4 cl_char8 cl_char16
          uchar2 uchar3 uchar4 uchar8 uchar16
          cl_uchar2 cl_uchar3 cl_uchar4 cl_uchar8 cl_uchar16
          short2 short3 short4 short8 short16
          cl_short2 cl_short3 cl_short4 cl_short8 cl_short16
          ushort2 ushort3 ushort4 ushort8 ushort16
          cl_ushort2 cl_ushort3 cl_ushort4 cl_ushort8 cl_ushort16
          int2 int3 int4 int8 int16
          cl_int2 cl_int3 cl_int4 cl_int8 cl_int16
          uint2 uint3 uint4 uint8 uint16
          cl_uint2 cl_uint3 cl_uint4 cl_uint8 cl_uint16
          long2 long3 long4 long8 long16
          cl_long2 cl_long3 cl_long4 cl_long8 cl_long16
          ulong2 ulong3 ulong4 ulong8 ulong16
          cl_ulong2 cl_ulong3 cl_ulong4 cl_ulong8 cl_ulong16
          float2 float3 float4 float8 float16
          cl_float2 cl_float3 cl_float4 cl_float8 cl_float16
          double2 double3 double4 double8 double16
          
          image2d_t
          image3d_t
          image2d_array_t
          image1d_t
          image1d_buffer_t
          image1d_array_t
          image2d_depth_t
          image2d_array_depth_t
          sampler_t
          queue_t
          ndrange_t
          clk_event_t
          reserve_id_t
          event_t
          cl_mem_fence_flags
          
          queue_t
          cl_command_queue
          clk_event_t
          cl_event
          
          FLT_MAX FLT_MIN
        )
      end

      def self.keywords
        @keywords ||= Set.new %w(
          __global global
          __local local
          __constant constant
          __private private
          __generic generic
          __kernel kernel
          __read_only read_only
          __write_only write_only
          __read_write read_write
          uniform pipe
        )
      end

      def self.reserved
        @reserved ||= Set.new %w(
          __asm __int8 __based __except __int16 __stdcall __cdecl
          __fastcall __int32 __declspec __finally __int61 __try __leave
          inline _inline __inline naked _naked __naked restrict _restrict
          __restrict thread _thread __thread typename _typename __typename
          imaginary complex
        )
      end

      def self.builtins
        @builtins ||= %w(true false)
      end

      def self.analyze_text(text)
        return 1.0 if text =~ /(cl_int|cl_device|cl_float|cl_platform)\b/
        return 0.1
      end
    
    end
  end
end
