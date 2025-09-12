(*********************************************************************************)
(*  super-master-mind: A solver for the super master mind game                   *)
(*  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

module Code = Code
module Codes = Codes
module Color = Color
module Color_permutation = Color_permutation
module Cue = Cue
module Example = Example
module Game_dimensions = Game_dimensions
module Guess = Guess
module Kheap = Kheap
module Opening_book = Opening_book
module Task_pool = Task_pool

let main =
  Command.group
    ~summary:"A solver for the super-master-mind game."
    [ "example", Example.cmd
    ; "maker", Maker.cmd
    ; "opening-book", Opening_book.cmd
    ; "solver", Solver.cmd
    ]
;;
