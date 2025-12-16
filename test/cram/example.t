  $ super-master-mind example --num-domains 4 --solution '["Green","Blue","Orange","White","Red"]'
  (1,
   { candidate = [| Black;  Blue;  Brown;  Green;  Orange |]
   ; expected_bits_gained = 3.2315534058559967
   ; expected_bits_remaining = 11.768446594144002
   ; min_bits_gained = 2.2125055003000007
   ; max_bits_gained = 15
   ; max_bits_remaining = 12.7874944997
   ; by_cue =
       [ { cue = { white = 2; black = 1 }
         ; size_remaining = 4680
         ; bits_remaining = 12.1922928145
         ; bits_gained = 2.8077071855
         ; probability = 0.142822265625
         ; next_best_guesses = Not_computed
         }
       ]
   })
  (2,
   { candidate = [| Black;  Blue;  Orange;  Orange;  Yellow |]
   ; expected_bits_gained = 3.2916088087752562
   ; expected_bits_remaining = 8.9006840057247434
   ; min_bits_gained = 2.3374244312000005
   ; max_bits_gained = 10.1922928145
   ; max_bits_remaining = 9.8548683833
   ; by_cue =
       [ { cue = { white = 0; black = 2 }
         ; size_remaining = 280
         ; bits_remaining = 8.1292830169
         ; bits_gained = 4.0630097975999995
         ; probability = 0.059829059829059832
         ; next_best_guesses = Not_computed
         }
       ]
   })
  (3,
   { candidate = [| Black;  Green;  Orange;  Red;  White |]
   ; expected_bits_gained = 3.7249049284260707
   ; expected_bits_remaining = 4.40437808847393
   ; min_bits_gained = 2.8073549220000009
   ; max_bits_gained = 8.1292830169
   ; max_bits_remaining = 5.3219280949
   ; by_cue =
       [ { cue = { white = 3; black = 1 }
         ; size_remaining = 19
         ; bits_remaining = 4.2479275134
         ; bits_gained = 3.8813555035000009
         ; probability = 0.067857142857142852
         ; next_best_guesses = Not_computed
         }
       ]
   })
  (4,
   { candidate = [| Black;  Black;  Red;  Orange;  Green |]
   ; expected_bits_gained = 3.2210972500210522
   ; expected_bits_remaining = 1.0268302633789474
   ; min_bits_gained = 2.6629650126999995
   ; max_bits_gained = 4.2479275134
   ; max_bits_remaining = 1.5849625007
   ; by_cue =
       [ { cue = { white = 3; black = 0 }
         ; size_remaining = 1
         ; bits_remaining = 0
         ; bits_gained = 4.2479275134
         ; probability = 0.052631578947368418
         ; next_best_guesses = Not_computed
         }
       ]
   })
  (5,
   { candidate = [| Green;  Blue;  Orange;  White;  Red |]
   ; expected_bits_gained = 0
   ; expected_bits_remaining = 0
   ; min_bits_gained = 0
   ; max_bits_gained = 0
   ; max_bits_remaining = 0
   ; by_cue =
       [ { cue = { white = 0; black = 5 }
         ; size_remaining = 1
         ; bits_remaining = 0
         ; bits_gained = 0
         ; probability = 1
         ; next_best_guesses = Not_computed
         }
       ]
   })
