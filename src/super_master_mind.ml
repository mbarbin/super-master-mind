open! Core
open! Import
module Color = Color
module Cue = Cue
module Example = Example
module Guess = Guess
module Kheap = Kheap
module Opening_book = Opening_book
module Permutation = Permutation
module Permutations = Permutations

let main =
  Command.group
    ~summary:"super-master-mind solver"
    [ "example", Example.cmd; "opening-book", Opening_book.cmd ]
;;
