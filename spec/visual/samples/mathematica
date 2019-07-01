(* :Title: Collatz Visualization *)
(* :Author: halirutan *)
(* :Mathematica Version: 10+ *)

CollatzSequence::usage = "CollatzSequence[list] creates a Collatz sequence.";
CollatzSequence[list_] := Module[{memory, tmp, chain, result = Internal`Bag[]},
  memory[1] = False;
  memory[n_] := (memory[n] = False; True);

  Do[
   chain = Internal`Bag[];
   tmp = l;
   While[memory[tmp],
    Internal`StuffBag[chain, tmp];
    tmp = If[EvenQ[tmp], tmp/2, 3 tmp + 1];
    ];
   Internal`StuffBag[chain, tmp];
   Internal`StuffBag[result, chain],
   {l, list}];
  Internal`BagPart[#, All] & /@ Internal`BagPart[result, All]
];

Graph[
 Flatten[(Rule @@@ Partition[#, 2, 1]) & /@
   CollatzSequence[Range[50000]]],
 PerformanceGoal -> "Speed",
 GraphLayout -> {"PackingLayout" -> "ClosestPacking"},
 VertexStyle -> Opacity[0.2, RGBColor[44/51, 10/51, 47/255]],
 EdgeStyle -> RGBColor[38/255, 139/255, 14/17]]
