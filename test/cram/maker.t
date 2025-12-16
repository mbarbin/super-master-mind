  $ dune exec super-master-mind -- maker --solution '["Green","Blue","Orange","White","Red"]' <<EOF
  > invalid json
  > ["Black","Invalid_color","Black","Black","Black"]
  > ["Black","Black","Black","Black","Black","Black","Black","Black","Black","Black","Black"]
  > ["Black","Blue","Brown","Green","Orange"]
  > ["Black","Blue","Orange","Orange","Yellow"]
  > ["Black","Green","Orange","Red","White"]
  > ["Black","Black","Red","Orange","Green"]
  > ["Green","Blue","Orange","White","Red"]
  Please enter your guess: Json.Parse_error("Line 1, bytes 0-12:\nInvalid token 'invalid json'")
  Please enter your guess: Json.Invalid_json("Invalid color for [Color.Hum.t].", "Invalid_color")
  Please enter your guess: ("Invalid code size.",
   { code =
       [| Black
       ;  Black
       ;  Black
       ;  Black
       ;  Black
       ;  Black
       ;  Black
       ;  Black
       ;  Black
       ;  Black
       ;  Black
       |]
   ; code_size = 11
   ; expected_size = 5
   })
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
