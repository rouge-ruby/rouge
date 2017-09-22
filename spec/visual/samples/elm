-- PART 1.
-- Tests for Elm.Basics package. Operators that got imported by default. See http://package.elm-lang.org/packages/elm-lang/core/5.1.1/Basics

-- Equality
a == b
a /= b

-- Comparison
a < b
a > b
a <= b
a >= b

-- Booleans
a && b
a || b

-- Mathematics
a + b
a - b
a * b
a / b
a ^ b
a // b
a % b

-- Strings and Lists
"hello" ++ "world" == "helloworld"
[1,1,2] ++ [3,5,8] == [1,1,2,3,5,8]

-- Higher-Order Helpers
leftAligned <| monospace <| fromString "code"

ngon 5 30
  |> filled blue
  |> move (10,10)
  |> scale 2

not << isEven << sqrt

sqrt >> isEven >> not



-- PART 2.
-- elm-compiler test cases. See https://github.com/elm-lang/elm-compiler/tree/master/tests/test-files/good

-- LITERALS

-- Multiline
s = """
here's a quote: "
"""

-- Negatives
(-) x y = x

minus =
  3 - 4

minusNegative =
  3 - -4

negativeMinusNegative =
  -3 - -4

negativeInParens =
  (-2)

funcMinus =
  (-) 3 4

-- Numbers
int = 12345

exp1 = 4e9
exp2 = 3E7
exp3 = 2e-9
exp4 = 1E+3

float1 = 3.14
float2 = 0.67
float3 = 6.022e26
float4 = 0.23E4

hex1 = 0xFFFFFFFF
hex2 = 0x0040
hex3 = 0xbeef
hex4 = 0xBEEF
hex5 = 0x0123789


-- Quotes and Comments
doubleQuote = '\"'

singleQuote = '\''

{- this is an {- embeded comment -} -}
commentStart = "{-"

-- RECORDS

-- Access
point =
  { x = 3, y = 4 }

x1 =
  point.x

x2 =
  .x point

x3 =
  (point).x

x4 =
  (.x) point


apply f x = f x

x5 =
  apply .x point

-- Alias substitution
type alias Vec2Ext record =
    { record | x:Float, y:Float }


type alias Vec2 =
    Vec2Ext {}


extractVec : Vec2Ext a -> Vec2
extractVec v =
    { x = v.x, y = v.y }

-- Non Homogeneous Records
type alias Thing =
    { x : Float
    , y : Float
    }


bindFields : Thing -> Thing
bindFields thing =
  let
    x = thing.x
    y = thing.y
  in
    thing


-- SOUNDNESS

apply f = let g x = f x
          in  g

apply : (a -> b) -> a -> b
apply f = let g x = f x
          in  g

myId x = let y = x in y

myId : a -> a
myId x = let y = x in y

px : number -> String
px x =
  "test"

-- LISTS
nonEmptyList = [1,4,5]
emptyList = []

-- DECLARATIONS
type alias Width = Float
type alias Height = Float

-- CRASH
import Debug

test x =
    if x then
        2
    else
        Debug.crash "unexpected value"


-- CASES
foo x =
    case x of
        'A' ->
            "hello"

        _ ->
            "letter A was not seen"

type List a
    = Nil 
    | Cons a (List a)


zip : List a -> List b -> List (a, b)
zip list1 list2 =
    case (list1, list2) of
        (Nil, _) ->
            Nil

        (_, Nil) ->
            Nil

        (Cons x xs, Cons y ys) ->
            Cons (x, y) (zip xs ys)


-- PART 3.
-- Examples from the Elm syntax description. See http://elm-lang.org/docs/syntax

-- Comments

-- a single line comment
{- a multiline comment
   {- can be nested -}
-}

{--}
add x y = x + y
--}

-- Literals
-- Boolean
True  : Bool
False : Bool

42    : number  -- Int or Float depending on usage
3.14  : Float

'a'   : Char
"abc" : String

-- multi-line String
"""
This is useful for holding JSON or other
content that has "quotation marks".
"""

True && not (True || False)
(2 + 4) * (4^2 - 9)
"abc" ++ "def"

-- Lists
[1,2,3,4]
1 :: [2,3,4]
1 :: 2 :: 3 :: 4 :: []

-- Conditionals
if powerLevel > 9000 then "OVER 9000!!!" else "meh"

if key == 40 then
    n + 1

else if key == 38 then
    n - 1

else
    n


case maybe of
  Just xs -> xs
  Nothing -> []

case xs of
  hd::tl -> Just (hd,tl)
  []     -> Nothing

case n of
  0 -> 1
  1 -> 1
  _ -> fib (n-1) + fib (n-2)

-- Union Types
type List = Empty | Node Int List

-- Records
point =                         -- create a record
  { x = 3, y = 4 }

point.x                         -- access field

List.map .x [point,{x=0,y=0}]   -- field access function

{ point | x = 6 }               -- update a field

{ point |                       -- update many fields
    x = point.x + 1,
    y = point.y + 1
}

dist {x,y} =                    -- pattern matching on fields
  sqrt (x^2 + y^2)

type alias Location =           -- type aliases for records
  { line : Int
  , column : Int
  }

-- Functions
square n =
  n^2

hypotenuse a b =
  sqrt (square a + square b)

distance (a,b) (x,y) =
  hypotenuse (a-x) (b-y)

square =
  \n -> n^2

squares =
  List.map (\n -> n^2) (List.range 1 100)

-- Infix Operators
(?) : Maybe a -> a -> a
(?) maybe default =
  Maybe.withDefault default maybe

infixr 9 ?

viewNames1 names =
  String.join ", " (List.sort names)

viewNames2 names =
  names
    |> List.sort
    |> String.join ", "

-- (arg |> func) is the same as (func arg)
-- Just keep repeating that transformation!

-- Let Expressions
let
  twentyFour =
    3 * 8

  sixteen =
    4 ^ 2
in
  twentyFour + sixteen

let
  ( three, four ) =
    ( 3, 4 )

  hypotenuse a b =
    sqrt (a^2 + b^2)
in
  hypotenuse three four

let
  name : String
  name =
    "Hermann"

  increment : Int -> Int
  increment n =
    n + 1
in
  increment 10

-- Applying Functions
-- alias for appending lists and two lists
append xs ys = xs ++ ys
xs = [1,2,3]
ys = [4,5,6]

-- All of the following expressions are equivalent:
a1 = append xs ys
a2 = xs ++ ys

b2 = (++) xs ys

c1 = (append xs) ys
c2 = ((++) xs) ys

23 + 19    : number
2.0 + 1    : Float

6 * 7      : number
10 * 4.2   : Float

100 // 2  : Int
1 / 2     : Float

(,) 1 2              == (1,2)
(,,,) 1 True 'a' []  == (1,True,'a',[])

-- Modules
module MyModule exposing (..)

-- qualified imports
import List                    -- List.map, List.foldl
import List as L               -- L.map, L.foldl

-- open imports
import List exposing (..)               -- map, foldl, concat, ...
import List exposing ( map, foldl )     -- map, foldl

import Maybe exposing ( Maybe )         -- Maybe
import Maybe exposing ( Maybe(..) )     -- Maybe, Just, Nothing
import Maybe exposing ( Maybe(Just) )   -- Maybe, Just

-- Type Annotations
answer : Int
answer =
  42

factorial : Int -> Int
factorial n =
  List.product (List.range 1 n)

distance : { x : Float, y : Float } -> Float
distance {x,y} =
  sqrt (x^2 + y^2)

-- Type Aliases
type alias Name = String
type alias Age = Int

info : (Name,Age)
info =
  ("Steve", 28)

type alias Point = { x:Float, y:Float }

origin : Point
origin =
  { x = 0, y = 0 }

-- JavaScript Interop
-- incoming values
port prices : (Float -> msg) -> Sub msg

-- outgoing values
port time : Float -> Cmd msg
