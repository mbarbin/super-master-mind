open! Core
module Color = Color
module Cue = Cue
module Guess = Guess
module Kheap = Kheap
module Permutation = Permutation
module Permutations = Permutations

let main = Command.group ~summary:"super-master-mind solver" [ "example", Example.cmd ]