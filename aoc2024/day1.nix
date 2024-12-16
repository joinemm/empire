let
  lib = import <nixpkgs/lib>;

  divWith = f: lib.sort (a: b: a < b) (map f nums);
  abs = x: if x < 0 then (-x) else x;
  sum = x: lib.foldl (a: b: a + b) 0 x;

  input = lib.removeSuffix "\n" (builtins.readFile ./input.txt);
  nums = map (x: map (x: lib.toInt x) (lib.splitString "   " x)) (lib.splitString "\n" input);
  left = divWith builtins.head;
  right = divWith lib.last;
  distances = lib.zipListsWith (a: b: abs (a - b)) left right;
  similar = map (n: (builtins.mul n (lib.count (x: x == n) right))) left;
in
{
  part1 = sum distances;
  part2 = sum similar;
}
