# inline comments
# another inline comment

# inline comment after empty line

  # inline comment after white-space

12 # EOL comment

/* multi-line
 * comment
 */

0

47

null

true

false

ab = q

42 == 24

12 + 3 / 2 * 1

a < 42 || b <= 10

b > 10 && 42 >= 12

"this is a string"

"antiquotation ${toString (x + 7)}"

"escaped chars \n \r \t \q \${q}"

''escaped chars ''\n ''\r ''\t ''\q ''' ''${q}''
++ ''raw chars " \n \r \t \q''

# Examples from https://nixos.org/nix/manual/#idm140737318143152

"--with-freetype2-library=${freetype}/lib"

"--with-freetype2-library=" + freetype + "/lib"

configureFlags = [
  "-system-zlib"
  "-system-libpng"
  "-system-libjpeg"
  (if threadSupport then "-thread" else "-no-thread")
] ++ stdenv.lib.optionals openglSupport [
  "-dlopen-opengl"
  "-L${mesa}/lib"
  "-I${mesa}/include"
  "-L${libXmu}/lib"
  "-I${libXmu}/include"
];

# indented string
indented = ''
  This is the first line.
  This is the second line.
    This is the third line.
'';

stdenv.mkDerivation {
  postInstall =
    ''
      mkdir $out/bin $out/etc
      cp foo $out/bin
      echo "Hello World" > $out/etc/foo.conf
      ${if enableBar then "cp bar $out/bin" else ""}
    '';
}

reference

_12 = "twelve"

__blah = _12

variableX = _12

variable-y = variableX # note that the '-' character may be part of the variable name

__variable__z_ = variable-y


# paths

/bin/sh

./builder.sh

../xyzzy/fnord.nix

~/foo

local/file

./. # current directory

/. # root directory

~ # not a path

. # not a path

/ # not a path

# uri

https://nixos.org/nixos/manual/index.html

git+https://nixos.org/nixos/manual/index.html

file:///tmp/nixos

# lists

[ 123 ./foo.nix "abc" (f { x = y; }) ]

[ 123 ./foo.nix "abc" f { x = y; } ]

# sets

{ x = 123;
  text = "Hello";
  y = f { bla = 456; };
}

{ a = "Foo"; b = "Bar"; }.a

{ a = "Foo"; b = "Bar"; }.c or "Xyzzy"

{ "foo ${bar}" = 123; "nix-1.0" = 456; }."foo ${bar}"

{ foo = 123; }.${bar} or 456

{ ${if foo then "bar" else null} = true; }

# recursive sets

rec {
  x = y;
  y = 123;
}.x

# let-expressions

let
  x = "foo";
  y = "bar";
in x + y

let x = 123; in
{ inherit x;
  y = 456;
}

# functions

pattern: body

let negate = x: !x;
    concat = x: y: x + y;
in if negate true then concat "foo" "bar" else ""

map (concat "foo") [ "bar" "bla" "abc" ]

{ x, y, z }: z + y + x

{ x, y, z, ... }: z + y + x

{ x, y ? "foo", z ? "bar" }: z + y + x

args@{ x, y, z, ... }: z + y + x + args.a

let concat = { x, y }: x + y;
in concat { x = "foo"; y = "bar"; }

let add = { __functor = self: x: x + self.x; };
    inc = add // { x = 1; };
in inc 1

# conditionals

if e1 then e2 else e3

# assertions

assert e1; e2

# with-expressions

with e1; e2

let as = { x = "foo"; y = "bar"; };
in with as; x + y

with (import ./definitions.nix); ...

# Operators
# https://nixos.org/nix/manual/#sec-language-operators

e . attrpath or def

e1 e2

e ? attrpath

e1 ++ e2

e1 + e2

! e

e1 // e2

e1 == e2

e1 != e2

e1 && e2

e1 || e2

e1 -> e2

with e1; e2

let as = { x = "foo"; y = "bar"; };
in with as; x + y

with (import ./definitions.nix); ...

{ stdenv, fetchurl, perl }: # 1

stdenv.mkDerivation { # 2
  name = "hello-2.1.1"; # 1: String
  # 2: Multiline string
  configureFlags  = "
  ";
  meta = {
    # 3: Indented string
    description = '' # part of the string
    A contrived example of a Nix expression, suitable for testing the lexer for
    Rouge.
    '';
  };
  builder = ./builder.sh; # 4
  src = fetchurl { # 5
    url = ftp://ftp.nluug.nl/pub/gnu/hello/hello-2.1.1.tar.gz;
    md5 = "70c9ccf9fac07f762c24f2df2290784d";
  };
  inherit perl; # 6
}
