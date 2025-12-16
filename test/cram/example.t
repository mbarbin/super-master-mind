  $ super-master-mind example --num-domains 4 --solution '["Green","Blue","Orange","White","Red"]'
  (1,
   { candidate = [| Black;  Blue;  Brown;  Green;  Orange |]
   ; expected_bits_gained = 3.23155340586
   ; expected_bits_remaining = 11.7684465941
   ; min_bits_gained = 2.2125055003
   ; max_bits_gained = 15.
   ; max_bits_remaining = 12.7874944997
   ; by_cue =
       [ { cue = { white = 2; black = 1 }
         ; size_remaining = 4680
         ; bits_remaining = 12.1922928145
         ; bits_gained = 2.80770718553
         ; probability = 0.142822265625
         ; next_best_guesses = Not_computed
         }
       ]
   })
  (2,
   { candidate = [| Black;  Blue;  Orange;  Orange;  Yellow |]
   ; expected_bits_gained = 3.29160880876
   ; expected_bits_remaining = 8.90068400571
   ; min_bits_gained = 2.33742443121
   ; max_bits_gained = 10.1922928145
   ; max_bits_remaining = 9.85486838326
   ; by_cue =
       [ { cue = { white = 0; black = 2 }
         ; size_remaining = 280
         ; bits_remaining = 8.12928301694
         ; bits_gained = 4.06300979753
         ; probability = 0.0598290598291
         ; next_best_guesses = Not_computed
         }
       ]
   })
  (3,
   { candidate = [| Black;  Green;  Orange;  Red;  White |]
   ; expected_bits_gained = 3.72490492845
   ; expected_bits_remaining = 4.40437808849
   ; min_bits_gained = 2.80735492206
   ; max_bits_gained = 8.12928301694
   ; max_bits_remaining = 5.32192809489
   ; by_cue =
       [ { cue = { white = 3; black = 1 }
         ; size_remaining = 19
         ; bits_remaining = 4.24792751344
         ; bits_gained = 3.8813555035
         ; probability = 0.0678571428571
         ; next_best_guesses = Not_computed
         }
       ]
   })
  (4,
   { candidate = [| Black;  Black;  Red;  Orange;  Green |]
   ; expected_bits_gained = 3.22109725006
   ; expected_bits_remaining = 1.02683026339
   ; min_bits_gained = 2.66296501272
   ; max_bits_gained = 4.24792751344
   ; max_bits_remaining = 1.58496250072
   ; by_cue =
       [ { cue = { white = 3; black = 0 }
         ; size_remaining = 1
         ; bits_remaining = 0.
         ; bits_gained = 4.24792751344
         ; probability = 0.0526315789474
         ; next_best_guesses = Not_computed
         }
       ]
   })
  (5,
   { candidate = [| Green;  Blue;  Orange;  White;  Red |]
   ; expected_bits_gained = 0.
   ; expected_bits_remaining = 0.
   ; min_bits_gained = 0.
   ; max_bits_gained = 0.
   ; max_bits_remaining = 0.
   ; by_cue =
       [ { cue = { white = 0; black = 5 }
         ; size_remaining = 1
         ; bits_remaining = 0.
         ; bits_gained = 0.
         ; probability = 1.
         ; next_best_guesses = Not_computed
         }
       ]
   })
