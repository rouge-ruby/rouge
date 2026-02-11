# -*- coding: utf-8 -*- #
# frozen_string_literal: true

require_relative 'c'

module Rouge
  module Lexers
    # This file defines the GLSL language lexer to the Rouge
    # syntax highlighter.
    #
    # Author: Sri Harsha Chilakapati
    class Glsl < C
      tag 'glsl'
      filenames '*.glsl', '*.frag', '*.vert', '*.geom', '*.vs', '*.gs', '*.shader'
      mimetypes 'x-shader/x-vertex', 'x-shader/x-fragment', 'x-shader/x-geometry'

      title "GLSL"
      desc "The GLSL shader language"

      def self.keywords
        @keywords ||= Set.new %w(
          const uniform buffer shared attribute varying
          coherent volatile restrict readonly writeonly
          atomic_uint
          layout
          centroid flat smooth noperspective
          patch sample
          invariant precise
          break continue do for while switch case default
          if else
          subroutine
          in out inout
          true false
          discard return
          lowp mediump highp precision
          struct

          row_major column_major
          shared packed std140 std43 binding offset align location
          early_fragment_tests
        )
      end

      def self.keywords_type
        @keywords_type ||= Set.new %w(
          int void bool float double
          
          vec2 vec3 vec4 ivec2 ivec3 ivec4 bvec2 bvec3 bvec4
          uint uvec2 uvec3 uvec4
          dvec2 dvec3 dvec4
          mat2 mat3 mat4
          mat2x2 mat2x3 mat2x4
          mat3x2 mat3x3 mat3x4
          mat4x2 mat4x3 mat4x4
          dmat2 dmat3 dmat4
          dmat2x2 dmat2x3 dmat2x4
          dmat3x2 dmat3x3 dmat3x4
          dmat4x2 dmat4x3 dmat4x4
          
          mat2 mat3 mat4 dmat2 dmat3 dmat4
          mat2x2 mat2x3 mat2x4 dmat2x2 dmat2x3 dmat2x4
          mat3x2 mat3x3 mat3x4 dmat3x2 dmat3x3 dmat3x4
          mat4x2 mat4x3 mat4x4 dmat4x2 dmat4x3 dmat4x4
          vec2 vec3 vec4 ivec2 ivec3 ivec4 bvec2 bvec3 bvec4 dvec2 dvec3 dvec4
          uint uvec2 uvec3 uvec4
          sampler1D sampler1DShadow sampler1DArray sampler1DArrayShadow
          isampler1D isampler1DArray usampler1D usampler1DArray
          sampler2D sampler2DShadow sampler2DArray sampler2DArrayShadow
          isampler2D isampler2DArray usampler2D usampler2DArray
          sampler2DRect sampler2DRectShadow isampler2DRect usampler2DRect
          sampler2DMS isampler2DMS usampler2DMS
          sampler2DMSArray isampler2DMSArray usampler2DMSArray
          sampler3D isampler3D usampler3D
          samplerCube samplerCubeShadow isamplerCube usamplerCube
          samplerCubeArray samplerCubeArrayShadow
          isamplerCubeArray usamplerCubeArray
          samplerBuffer isamplerBuffer usamplerBuffer
          image1D iimage1D uimage1D
          image1DArray iimage1DArray uimage1DArray
          image2D iimage2D uimage2D
          image2DArray iimage2DArray uimage2DArray
          image2DRect iimage2DRect uimage2DRect
          image2DMS iimage2DMS uimage2DMS
          image2DMSArray iimage2DMSArray uimage2DMSArray
          image3D iimage3D uimage3D
          imageCube iimageCube uimageCube
          imageCubeArray iimageCubeArray uimageCubeArray
          imageBuffer iimageBuffer uimageBuffer
          atomic_uint

          texture1D texture1DArray
          itexture1D itexture1DArray utexture1D utexture1DArray
          texture2D texture2DArray
          itexture2D itexture2DArray utexture2D utexture2DArray
          texture2DRect itexture2DRect utexture2DRect
          texture2DMS itexture2DMS utexture2DMS
          texture2DMSArray itexture2DMSArray utexture2DMSArray
          texture3D itexture3D utexture3D
          textureCube itextureCube utextureCube
          textureCubeArray itextureCubeArray utextureCubeArray
          textureBuffer itextureBuffer utextureBuffer
          sampler samplerShadow
          subpassInput isubpassInput usubpassInput
          subpassInputMS isubpassInputMS usubpassInputMS
        )
      end

      def self.reserved
        @reserved ||= Set.new %w(
          common partition active
          asm
          class union enum typedef template this
          resource
          goto
          inline noinline public static extern external interface
          long short half fixed unsigned superp
          input output
          hvec2 hvec3 hvec4 fvec2 fvec3 fvec4
          filter
          sizeof cast
          namespace using
          sampler3DRect
        )
      end

      def self.builtins
        @builtins ||= Set.new %w(
          gl_VertexID gl_VertexIndex gl_InstanceID gl_InstanceIndex gl_PerVertex gl_Position gl_PointSize gl_ClipDistance gl_CullDistance
          gl_PrimitiveIDIn gl_InvocationID gl_PrimitiveID gl_Layer gl_ViewportIndex
          gl_MaxPatchVertices gl_PatchVerticesIn gl_TessLevelOuter gl_TessLevelInner
          gl_TessCoord gl_FragCoord gl_FrontFacing gl_PointCoord gl_SampleID gl_SamplePosition
          gl_FragColor gl_FragData gl_MaxDrawBuffers gl_FragDepth gl_SampleMask
          gl_ClipVertex gl_FrontColor gl_BackColor gl_FrontSecondaryColor gl_BackSecondaryColor
          gl_TexCoord gl_FogFragCoord gl_Color gl_SecondaryColor gl_Normal gl_VertexID
          gl_MultiTexCord0 gl_MultiTexCord1 gl_MultiTexCord2 gl_MultiTexCord3
          gl_MultiTexCord4 gl_MultiTexCord5 gl_MultiTexCord6 gl_MultiTexCord7
          gl_FogCoord gl_MaxVertexAttribs gl_MaxVertexUniformComponents
          gl_MaxVaryingFloats gl_MaxVaryingComponents gl_MaxVertexOutputComponents
          gl_MaxGeometryInputComponents gl_MaxGeometryOutputComponents
          gl_MaxFragmentInputComponents gl_MaxVertexTextureImageUnits
          gl_MaxCombinedTextureImageUnits gl_MaxTextureImageUnits
          gl_MaxFragmentUniformComponents gl_MaxClipDistances
          gl_MaxGeometryTextureImageUnits gl_MaxGeometryUniformComponents
          gl_MaxGeometryVaryingComponents gl_MaxTessControlInputComponents
          gl_MaxTessControlOutputComponents gl_MaxTessControlTextureImageUnits
          gl_MaxTessControlUniformComponents gl_MaxTessControlTotalOutputComponents
          gl_MaxTessEvaluationInputComponents gl_MaxTessEvaluationOutputComponents
          gl_MaxTessEvaluationTextureImageUnits gl_MaxTessEvaluationUniformComponents
          gl_MaxTessPatchComponents gl_MaxTessGenLevel gl_MaxViewports
          gl_MaxVertexUniformVectors gl_MaxFragmentUniformVectors gl_MaxVaryingVectors
          gl_MaxTextureUnits gl_MaxTextureCoords gl_MaxClipPlanes gl_DepthRange
          gl_DepthRangeParameters gl_ModelViewMatrix gl_ProjectionMatrix
          gl_ModelViewProjectionMatrix gl_TextureMatrix gl_NormalMatrix
          gl_ModelViewMatrixInverse gl_ProjectionMatrixInverse gl_ModelViewProjectionMatrixInverse
          gl_TextureMatrixInverse gl_ModelViewMatrixTranspose
          gl_ModelViewProjectionMatrixTranspose gl_TextureMatrixTranspose
          gl_ModelViewMatrixInverseTranspose gl_ProjectionMatrixInverseTranspose
          gl_ModelViewProjectionMatrixInverseTranspose
          gl_TextureMatrixInverseTranspose gl_NormalScale gl_ClipPlane gl_PointParameters
          gl_Point gl_MaterialParameters gl_FrontMaterial gl_BackMaterial
          gl_LightSourceParameters gl_LightSource gl_MaxLights gl_LightModelParameters
          gl_LightModel gl_LightModelProducts gl_FrontLightModelProduct
          gl_BackLightModelProduct gl_LightProducts gl_FrontLightProduct
          gl_BackLightProduct gl_TextureEnvColor gl_EyePlaneS gl_EyePlaneT gl_EyePlaneR
          gl_EyePlaneQ gl_ObjectPlaneS gl_ObjectPlaneT gl_ObjectPlaneR gl_ObjectPlaneQ
          gl_FogParameters gl_Fog
          gl_DrawID gl_BaseVertex gl_BaseInstance
          gl_NumWorkGroups gl_WorkGroupID gl_LocalInvocationID gl_GlobalInvocationID gl_LocalInvocationIndex
          gl_WorkGroupSize gl_HelperInvocation
        )
      end
    end
  end
end
