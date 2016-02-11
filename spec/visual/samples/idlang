; vim: set ts=4 sw=4 et ft=idlang:

;+
; Greatest common divisor function
;-
function gcd, a, b

    compile_opt idl2, hidden

    j = a & k = b

    while (finite(k) and (k /= 0)) do begin
        t = j mod k
        j = k
        k = t
    endwhile

    return, a

end

;+
; Least common multiple funcion
;-
function lcm, a, b

    compile_opt idl2, hidden
    return, abs(a * b) / gcd(a, b)

end

pro rat::normalize

    compile_opt idl2, hidden

    n = gcd(abs(self.numerator), abs(self.denominator))
    ; Note: This only works in IDL >= 8.3
    new_numerator = (self.numerator / n) * $
        signum(signum(self.numerator) * signum(self.denominator))
    new_denominator = self.denominator / n

    self.numerator = temporary(new_numerator)
    self.denominator = temporary(new_denominator)

end

function rat::numerator

    compile_opt idl2, hidden
    return, self.numerator

end

function rat::denominator

    compile_opt idl2, hidden
    return, self.denominator

end

pro rat::add, q

    compile_opt idl2, hidden

    n = lcm(self.denominator, q->denominator())
    new_numerator = (n / self.denominator) * self.numerator + $
        (n / q->denominator()) * q->numerator()
    new_denominator = n

    self.numerator = temporary(new_numerator)
    self.denominator = temporary(new_denominator)

    self.normalize

end

pro rat::sub, q

    compile_opt idl2, hidden

    r = obj_new('rat', -q->numerator(), q->denominator())
    self.add, r
    obj_destroy, r

end

pro rat::mul, r, q

    compile_opt idl2, hidden

    self.numerator = self.numerator * q->numerator()
    self.denominator = self.denominator * q->denominator()

    self.normalize

end

pro rat::div, q

    compile_opt idl2, hidden

    r = obj_new('rat', q->denominator(), q->numerator())
    self.mul, r
    obj_destroy, r

end

function rat::INIT, numerator, denominator

    compile_opt idl2, hidden

    if (n_params() eq 2) then begin
        self.numerator = numerator
        self.denominator = denominator
    endif $
    else if (obj_valid(numerator)) then begin
        ; numerator is actually a "rat" object
        self.numerator = numerator->numerator()
        self.denominator = numerator->denominator()
    endif

    return, 1

end

pro rat__define, class

    compile_opt idl2, hidden

    class = { rat, $
        numerator: 0., $
        denominator: 0. $
    }

end

pro print_bottle, n, verbose=verbose

    compile_opt idl2
    on_error, 2

    verbose = keyword_set(verbose)
    !quiet = ~verbose

    if (verbose) then begin

        case (n) of
            2: begin
                print, n, format='(I0, 1X, "bottles of beer on the wall,")'
                print, n, format='(I0, 1X, "bottles of beer.")'
                print, format='("Take one down, pass it around,")'
                print, format='("one last bottle of beer on the wall.", /)'
            end

            1: begin
                print, n, format='("One last bottle of beer on the wall,")'
                print, n, format='("one last bottle of beer.")'
                print, format='("Take one down, pass it around,")'
                print, format='("no more bottles of beer on the wall.", /)'
            end

            default: begin
                print, n, format='(I0, 1X, "bottles of beer on the wall,")'
                print, n, format='(I0, 1X, "bottles of beer.")'
                print, format='("Take one down, pass it around,")'
                print, n - 1, format='(I0, 1X, "bottles of beer on the wall.", /)'
            end
        endcase

    endif

end

pro bottles

    compile_opt idl2
    on_error, 2

    towels = 'Don''t Panic!'
    nbottles = 99S
    r = obj_new('rat', 1, 2)
    q = obj_new('rat', 1, 6)

    while (nbottles gt '0'XULL) do begin
        print_bottle, nbottles
        nbottles -= 1
    endwhile

    print, (towels ne '') ? towels : 'Panic!'

    stop
    r->sub, q
    print, r->numerator(), r->denominator(), format='(I0, "/", I0)'

end
