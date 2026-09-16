  $ dune exec super-master-mind -- maker --solution 'Green,Blue,Orange,White,Red' <<EOF
  > not a code
  > Black,Invalid_color,Black,Black,Black
  > Black,Black,Black,Black,Black,Black,Black,Black,Black,Black,Black
  > Black,Blue,Brown,Green,Orange
  > Black,Blue,Orange,Orange,Yellow
  > Black,Green,Orange,Red,White
  > Black,Black,Red,Orange,Green
  > Green,Blue,Orange,White,Red
  Please enter your guess: Invalid color "not a code".
  Please enter your guess: Invalid color "Invalid_color".
  Please enter your guess: Invalid code size: expected 5 colors, got 11.
  Please enter your guess: (1, [| Black;  Blue;  Brown;  Green;  Orange |])
  #black (correctly placed)  : 1
  #white (incorrectly placed): 2
  Please enter your guess: (2, [| Black;  Blue;  Orange;  Orange;  Yellow |])
  #black (correctly placed)  : 2
  #white (incorrectly placed): 0
  Please enter your guess: (3, [| Black;  Green;  Orange;  Red;  White |])
  #black (correctly placed)  : 1
  #white (incorrectly placed): 3
  Please enter your guess: (4, [| Black;  Black;  Red;  Orange;  Green |])
  #black (correctly placed)  : 0
  #white (incorrectly placed): 3
  Please enter your guess: (5, [| Green;  Blue;  Orange;  White;  Red |])
  #black (correctly placed)  : 5
  #white (incorrectly placed): 0
