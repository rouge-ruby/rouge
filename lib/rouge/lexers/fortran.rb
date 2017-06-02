# -*- coding: utf-8 -*- #
# vim: set ts=2 sw=2 et:

# TODO: Implement format list support.

module Rouge
  module Lexers
    class Fortran < RegexLexer
      title "Fortran"
      desc "Fortran 2008 (free-form)"

      tag 'fortran'
      filenames '*.f90', '*.f95', '*.f03', '*.f08',
                '*.F90', '*.F95', '*.F03', '*.F08'
      mimetypes 'text/x-fortran'

      name = /[A-Z][_A-Z0-9]*/i
      kind_param = /(\d+|#{name})/
      exponent = /[ED][+-]?\d+/i

      def self.keywords
        # Fortran allows to omit whitespace between certain keywords...
        @keywords ||= Set.new %w(
          abstract all allocatable allocate assign assignment asynchronous
          backspace bind block blockdata close common concurrent contiguous call
          case class codimension contains continue cycle data deallocate
          deferred dimension do elemental else elseif elsewhere end endblock
          endblockdata enddo endenum endfile endforall endfunction endif
          endinterface endmodule endprogram endselect endsubmodule endsubroutine
          endtype endwhere endwhile entry enum enumerator equivalence error exit
          external final flush forall format function generic go goto if
          implicit import in include inout inquire intent interface intrinsic is
          module namelist non_overridable none nopass nullify only open operator
          optional out parameter pass pause pointer print private procedure
          program protected public pure read recursive result return rewind save
          select selectcase sequence stop submodule subroutine target then to
          type use value volatile wait where while write
        )
      end

      def self.types
        # There is a separate rule for "double precision" (two words) below
        @types ||= Set.new %w(
          character complex doubleprecision integer logical real
        )
      end

      def self.intrinsics
        @intrinsics ||= Set.new %w(
          abs achar acos acosh adjustl adjustr aimag aint all allocated anint
          any asin asinh associated atan atan2 atanh bessel_j0 bessel_j1
          bessel_jn bessel_y0 bessel_y1 bessel_yn bge bgt bit_size ble blt btest
          c_associated c_f_pointer c_f_procpointer c_funloc c_loc c_sizeof
          ceiling char cmplx command_argument_count compiler_options
          compiler_version conjg cos cosh count cpu_time cshift date_and_time
          dble digits dim dot_product dprod dshiftl dshiftr eoshift epsilon erf
          erfc_scaled erfc execute_command_line exp exponent extends_type_of
          findloc floor fraction gamma get_command_argument get_command
          get_environment_variable huge hypot iachar iall iand iany ibclr ibits
          ibset ichar ieee_class ieee_copy_sign ieee_get_flag
          ieee_get_halting_mode ieee_get_rounding_mode ieee_get_status
          ieee_get_underflow_mode ieee_is_finite ieee_is_nan ieee_is_normal
          ieee_logb ieee_next_after ieee_rem ieee_rint ieee_scalb
          ieee_selected_real_kind ieee_set_flag ieee_set_halting_mode
          ieee_set_rounding_mode ieee_set_status ieee_set_underflow_mode
          ieee_support_datatype ieee_support_denormal ieee_support_divide
          ieee_support_flag ieee_support_halting ieee_support_inf
          ieee_support_io ieee_support_nan ieee_support_rounding
          ieee_support_sqrt ieee_support_standard ieee_support_underflow_control
          ieee_unordered ieee_value ieor image_index index int ior iparity
          is_contiguous is_iostat_end is_iostat_eor ishft ishftc kind lbound
          lcobound leadz len_trim len lge lgt lle llt log_gamma log log10
          logical maskl maskr matmul max maxexponent maxloc maxval merge_bits
          merge min minexponent minloc minval mod modulo move_alloc mvbits
          nearest new_line nint norm2 not null num_images pack parity popcnt
          poppar present product radix random_number random_seed range real
          repeat reshape rrspacing same_type_as scale scan selected_char_kind
          selected_int_kind selected_real_kind set_exponent shape shifta shiftl
          shiftr sign sin sinh size spacing spread sqrt storage_size sum
          system_clock tan tanh this_image tiny trailz transfer transpose trim
          ubound ucobound unpack verify
        )
      end

      state :root do
        rule /[\s\n]+/, Text::Whitespace
        rule /!.*$/, Comment::Single
        rule /^#.*$/, Comment::Preproc

        rule /::|[()\/;,:&\[\]]/, Punctuation

        # TODO: This does not take into account line continuation.
        rule /^(\s*)([0-9]+)\b/m do |m|
          token Text::Whitespace, m[1]
          token Name::Label, m[2]
        end

        # Format statements are quite a strange beast.
        # Better process them in their own state.
        rule /\b(FORMAT)(\s*)(\()/mi do |m|
          token Keyword, m[1]
          token Text::Whitespace, m[2]
          token Punctuation, m[3]
          push :format_spec
        end

        rule %r(
          [+-]? # sign
          (
            (\d+[.]\d*|[.]\d+)(#{exponent})?
            | \d+#{exponent} # exponent is mandatory
          )
          (_#{kind_param})? # kind parameter
        )xi, Num::Float

        rule /[+-]?\d+(_#{kind_param})?/i, Num::Integer
        rule /B'[01]+'|B"[01]+"/i, Num::Bin
        rule /O'[0-7]+'|O"[0-7]+"/i, Num::Oct
        rule /Z'[0-9A-F]+'|Z"[0-9A-F]+"/i, Num::Hex
        rule /(#{kind_param}_)?'/, Str::Single, :string_single
        rule /(#{kind_param}_)?"/, Str::Double, :string_double
        rule /[.](TRUE|FALSE)[.](_#{kind_param})?/i, Keyword::Constant

        rule %r{\*\*|//|==|/=|<=|>=|=>|[-+*/<>=%]}, Operator
        rule /\.(?:EQ|NE|LT|LE|GT|GE|NOT|AND|OR|EQV|NEQV|[A-Z]+)\./i, Operator::Word

        # To make sure "double precision" written as two words is highlighted
        # properly. "doubleprecision" is covered by a different rule.
        rule /double\s+precision\b/i, Keyword::Type

        rule /#{name}/m do |m|
          match = m[0].downcase
          if self.class.keywords.include? match
            token Keyword
          elsif self.class.types.include? match
            token Keyword::Type
          elsif self.class.intrinsics.include? match
            token Name::Builtin
          else
            token Name
          end
        end

      end

      state :string_single do
        rule /[^']+/, Str::Single
        rule /''/, Str::Escape
        rule /'/, Str::Single, :pop!
      end

      state :string_double do
        rule /[^"]+/, Str::Double
        rule /""/, Str::Escape
        rule /"/, Str::Double, :pop!
      end

      state :format_spec do
        rule /'/, Str::Single, :string_single
        rule /"/, Str::Double, :string_double
        rule /\(/, Punctuation, :format_spec
        rule /\)/, Punctuation, :pop!
        rule /,/, Punctuation
        rule /[\s\n]+/, Text::Whitespace
        # Edit descriptors could be seen as a kind of "format literal".
        rule /[^\s'"(),]+/, Literal
      end
    end
  end
end
