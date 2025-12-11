(*_********************************************************************************)
(*_  super-master-mind: A solver for the super master mind game                   *)
(*_  SPDX-FileCopyrightText: 2021-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

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

val main : unit Command.t
