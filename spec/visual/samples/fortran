! vim: set ts=4 sw=4 et ft=fortran:

module rats

    type rational
        integer :: numerator
        integer :: denominator
    end type rational

    type, extends(rational) :: printable_rational
        contains
        procedure, pass :: printme => rat_print
    end type printable_rational

    interface operator(+)
        module procedure rat_add
    end interface

    interface operator(-)
        module procedure rat_sub
    end interface

    interface operator (*)
        module procedure rat_mul
    end interface

    interface operator(/)
        module procedure rat_div
    end interface

    ! Interface to allow implementation of rat_print in submodule
    interface
        module subroutine rat_print(self)
        class(printable_rational), intent(inout) :: self
        end subroutine rat_print
    end interface

contains

    integer function gcd(a, b)
        integer, intent(in) :: a, b
        integer :: j, k, t

        j = a; k = b

        do while (k /= 0)
            t = mod(j, k)
            j = k
            k = t
        end do

        gcd = a
    end function gcd

    integer function lcm(a, b)
        integer, intent(in) :: a, b
        lcm = abs(a * b) / gcd(a, b)
    end function lcm

    type(rational) function rat_normalize(q)
        type(rational), intent(in) :: q
        integer :: n

        n = gcd(abs(q%numerator), abs(q%denominator))
        rat_normalize%numerator = sign(q%numerator / n, sign(1, q%numerator) * sign(1, q%denominator))
        rat_normalize%denominator = q%denominator / n
    end function rat_normalize

    integer function rat_numerator(q)
        type(rational), intent(in) :: q
        rat_numerator = q%numerator
    end function rat_numerator

    integer function rat_denominator(q)
        type(rational), intent(in) :: q
        rat_denominator =q%denominator
    end function rat_denominator

    type(rational) function rat_add(r, q)
        type(rational), intent(in) :: r, q
        integer :: n

        n = lcm(r%denominator, q%denominator)
        rat_add%numerator = (n / r%denominator) * r%numerator + (n / q%denominator) * q%numerator
        rat_add%denominator = n

        rat_add = rat_normalize(rat_add)
    end function rat_add

    type(rational) function rat_sub(r, q)
        type(rational), intent(in) :: r, q
        rat_sub = r + rational(- q%numerator, q%denominator)
    end function rat_sub

    type(rational) function rat_mul(r, q)
        type(rational), intent(in) :: r, q

        rat_mul%numerator = r%numerator * q%numerator
        rat_mul%denominator = r%denominator * q%denominator

        rat_mul = rat_normalize(rat_mul)
    end function rat_mul

    type(rational) function rat_div(r, q)
        type(rational), intent(in) :: r, q
        rat_div = r * rational(q%denominator, q%numerator)
    end function rat_div

end module rats

submodule (rats) rats_print_implementation
contains
    module procedure rat_print
    print '(I0, "/", I0)', self%numerator, self%denominator
    end procedure rat_print
end submodule rats_print_implementation

program bottles
    use rats
    implicit none

    character(len=*), parameter :: towels = 'Don''t Panic!'
    integer :: nbottles = 99
    type(rational) :: r = rational(1, 2), q = rational(1, 6)
    type(printable_rational) :: p

    do while (nbottles > 0)
        call print_bottles(nbottles)
        nbottles = nbottles - 1
    end do

    print *, towels

    r = r - q
    write(*, '(I0, "/", I0)') rat_numerator(r), rat_denominator(r)

    p = printable_rational(r)
    call p%printme()
contains

    subroutine print_bottles(n)
        implicit none
        integer, intent(in) :: n

#if defined(VERBOSE)
        select case (n)
        case (2)
            write(*, 100) n
            write(*, 110) n
            write(*, 120)
            write(*, 230)
        case (1)
            write(*, 200)
            write(*, 210)
            write(*, 120)
            write(*, 330)
        case default
            write(*, 100) n
            write(*, 110) n
            write(*, 120)
            write(*, 130) n - 1
        end select

100     format (I0, 1X, 'bottles of beer on the wall,')
110     format (I0, 1X, 'bottles of beer.')
120     format ('Take one down, pass it around,')
130     format (I0, 1X, 'bottles of beer on the wall.', /)
200     format ('One last bottle of beer on the wall,')
210     format ('one last bottle of beer.')
230     format ('one last bottle of beer on the wall.', /)
330     format ('no more bottles of beer on the wall.', /)
#endif

    end subroutine print_bottles

    subroutine share_bottles(n, m)
      use, intrinsic :: ieee_arithmetic
      implicit none
      integer, intent(in) :: n, m

      double precision :: double
      doubleprecision  :: another_double

      if (m == 0) then
        double = ieee_value(double, IEEE_QUIET_NAN)
        error stop
      else
        double = real(n, kind(double)) / real(m, kind(another_double))
        print '(A,F0.2,A)', 'Everyone gets ', double, ' bottles!'
      endif
    end subroutine share_bottles

end program bottles
