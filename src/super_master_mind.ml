open! Core
open! Import
module Code = Code
module Codes = Codes
module Color = Color
module Color_permutation = Color_permutation
module Cue = Cue
module Example = Example
module Guess = Guess
module Kheap = Kheap
module Opening_book = Opening_book

let main =
  Command.group
    ~summary:"super-master-mind solver"
    [ "example", Example.cmd
    ; "maker", Maker.cmd
    ; "opening-book", Opening_book.cmd
    ; "solver", Solver.cmd
    ]
;;
