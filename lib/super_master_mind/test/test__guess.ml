open Super_master_mind

let%expect_test "verify" =
  let candidate = Code.create_exn [| Green; Blue; Orange; White; Red |] in
  let possible_solutions = Codes.all in
  let guess = Guess.compute ~possible_solutions ~candidate in
  let test guess =
    let result = Guess.verify guess ~possible_solutions in
    print_s [%sexp (result : unit Or_error.t)]
  in
  test guess;
  [%expect {| (Ok ()) |}];
  (* Unexpected values at the top level of [t]. *)
  test { guess with expected_bits_gained = 3.14 };
  [%expect
    {|
    (Error (
      "Unexpected values"
      " ((candidate (Green Blue Orange White Red))            ((candidate (Green Blue Orange White Red))         \n  (expected_bits_gained                                 (expected_bits_gained                             \n-  3.2315534058614328                                 +  3.14                                             \n  )                                                     )                                                 \n  (expected_bits_remaining 11.768446594138567)          (expected_bits_remaining 11.768446594138567)      \n                                        ...62 unchanged lines...                                        \n     (bits_gained 15) (probability 3.0517578125E-05)       (bits_gained 15) (probability 3.0517578125E-05)\n     (next_best_guesses Not_computed)))))                  (next_best_guesses Not_computed)))))           ")) |}];
  (* Mismatch in the length of by_cues cases. *)
  test
    { guess with
      by_cue = Nonempty_list.cons (Nonempty_list.hd guess.by_cue) guess.by_cue
    };
  [%expect {| (Error ("Unexpected by_cue length" "-20  +21")) |}];
  (* Mismatch in one of the by_cues. *)
  test
    { guess with
      by_cue =
        Nonempty_list.(
          { (hd guess.by_cue) with size_remaining = 7071 } :: tl guess.by_cue)
    };
  [%expect
    {|
    (Error (
      "Unexpected by_cue"
      " ((cue ((white 2) (black 0)))           ((cue ((white 2) (black 0)))        \n  (size_remaining                        (size_remaining                    \n-  7070                                +  7071                              \n  )                                      )                                  \n  (bits_remaining 12.787494499696761)    (bits_remaining 12.787494499696761)\n  (bits_gained 2.212505500303239)        (bits_gained 2.212505500303239)    \n  (probability 0.21575927734375)         (probability 0.21575927734375)     \n  (next_best_guesses Not_computed))      (next_best_guesses Not_computed))  ")) |}];
  ()
;;

let%expect_test "no repetition" =
  let candidate = Code.create_exn [| Green; Blue; Orange; White; Red |] in
  let possible_solutions = Codes.all in
  let guess = Guess.compute ~possible_solutions ~candidate in
  print_s [%sexp (guess : Guess.t)];
  [%expect
    {|
    ((candidate (Green Blue Orange White Red))
     (expected_bits_gained    3.2315534058614328)
     (expected_bits_remaining 11.768446594138567)
     (min_bits_gained         2.212505500303239)
     (max_bits_gained         15)
     (max_bits_remaining      12.787494499696761)
     (by_cue (
       ((cue (
          (white 2)
          (black 0)))
        (size_remaining    7070)
        (bits_remaining    12.787494499696761)
        (bits_gained       2.212505500303239)
        (probability       0.21575927734375)
        (next_best_guesses Not_computed))
       ((cue (
          (white 3)
          (black 0)))
        (size_remaining    5610)
        (bits_remaining    12.453785055496155)
        (bits_gained       2.5462149445038449)
        (probability       0.17120361328125)
        (next_best_guesses Not_computed))
       ((cue (
          (white 1)
          (black 1)))
        (size_remaining    4880)
        (bits_remaining    12.252665432450248)
        (bits_gained       2.7473345675497516)
        (probability       0.14892578125)
        (next_best_guesses Not_computed))
       ((cue (
          (white 2)
          (black 1)))
        (size_remaining    4680)
        (bits_remaining    12.192292814470767)
        (bits_gained       2.8077071855292335)
        (probability       0.142822265625)
        (next_best_guesses Not_computed))
       ((cue (
          (white 1)
          (black 0)))
        (size_remaining    2625)
        (bits_remaining    11.358101707440847)
        (bits_gained       3.6418982925591532)
        (probability       0.080108642578125)
        (next_best_guesses Not_computed))
       ((cue (
          (white 1)
          (black 2)))
        (size_remaining    1650)
        (bits_remaining    10.688250309133178)
        (bits_gained       4.3117496908668222)
        (probability       0.05035400390625)
        (next_best_guesses Not_computed))
       ((cue (
          (white 0)
          (black 1)))
        (size_remaining    1280)
        (bits_remaining    10.321928094887362)
        (bits_gained       4.6780719051126383)
        (probability       0.0390625)
        (next_best_guesses Not_computed))
       ((cue (
          (white 0)
          (black 2)))
        (size_remaining    1250)
        (bits_remaining    10.287712379549449)
        (bits_gained       4.7122876204505513)
        (probability       0.03814697265625)
        (next_best_guesses Not_computed))
       ((cue (
          (white 4)
          (black 0)))
        (size_remaining    1215)
        (bits_remaining    10.246740598493144)
        (bits_gained       4.7532594015068561)
        (probability       0.037078857421875)
        (next_best_guesses Not_computed))
       ((cue (
          (white 3)
          (black 1)))
        (size_remaining    1120)
        (bits_remaining    10.129283016944967)
        (bits_gained       4.8707169830550328)
        (probability       0.0341796875)
        (next_best_guesses Not_computed))
       ((cue (
          (white 2)
          (black 2)))
        (size_remaining    510)
        (bits_remaining    8.9943534368588587)
        (bits_gained       6.0056465631411413)
        (probability       0.01556396484375)
        (next_best_guesses Not_computed))
       ((cue (
          (white 0)
          (black 3)))
        (size_remaining    360)
        (bits_remaining    8.4918530963296739)
        (bits_gained       6.5081469036703261)
        (probability       0.010986328125)
        (next_best_guesses Not_computed))
       ((cue (
          (white 0)
          (black 0)))
        (size_remaining    243)
        (bits_remaining    7.9248125036057813)
        (bits_gained       7.0751874963942187)
        (probability       0.007415771484375)
        (next_best_guesses Not_computed))
       ((cue (
          (white 1)
          (black 3)))
        (size_remaining    120)
        (bits_remaining    6.9068905956085187)
        (bits_gained       8.09310940439148)
        (probability       0.003662109375)
        (next_best_guesses Not_computed))
       ((cue (
          (white 4)
          (black 1)))
        (size_remaining    45)
        (bits_remaining    5.4918530963296748)
        (bits_gained       9.5081469036703261)
        (probability       0.001373291015625)
        (next_best_guesses Not_computed))
       ((cue (
          (white 5)
          (black 0)))
        (size_remaining    44)
        (bits_remaining    5.4594316186372973)
        (bits_gained       9.5405683813627036)
        (probability       0.0013427734375)
        (next_best_guesses Not_computed))
       ((cue (
          (white 0)
          (black 4)))
        (size_remaining    35)
        (bits_remaining    5.1292830169449664)
        (bits_gained       9.8707169830550328)
        (probability       0.001068115234375)
        (next_best_guesses Not_computed))
       ((cue (
          (white 3)
          (black 2)))
        (size_remaining    20)
        (bits_remaining    4.3219280948873626)
        (bits_gained       10.678071905112638)
        (probability       0.0006103515625)
        (next_best_guesses Not_computed))
       ((cue (
          (white 2)
          (black 3)))
        (size_remaining    10)
        (bits_remaining    3.3219280948873622)
        (bits_gained       11.678071905112638)
        (probability       0.00030517578125)
        (next_best_guesses Not_computed))
       ((cue (
          (white 0)
          (black 5)))
        (size_remaining    1)
        (bits_remaining    0)
        (bits_gained       15)
        (probability       3.0517578125E-05)
        (next_best_guesses Not_computed))))) |}];
  (* Due to the symmetry of the game, choosing different colors yields
     the same expected values. *)
  let guess2 =
    Guess.compute
      ~possible_solutions
      ~candidate:(Code.create_exn [| Black; Blue; Brown; Green; Orange |])
  in
  print_s [%sexp (Guess.equal guess { guess2 with candidate = guess.candidate } : bool)];
  [%expect {| true |}]
;;

let%expect_test "color present 2 times" =
  let candidate = Code.create_exn [| Green; Green; Orange; White; Red |] in
  let possible_solutions = Codes.all in
  let guess = Guess.compute ~possible_solutions ~candidate in
  print_s [%sexp (guess : Guess.t)];
  [%expect
    {|
    ((candidate (Green Green Orange White Red))
     (expected_bits_gained    3.2383078370116554)
     (expected_bits_remaining 11.761692162988345)
     (min_bits_gained         2.2163878347439621)
     (max_bits_gained         15)
     (max_bits_remaining      12.783612165256038)
     (by_cue (
       ((cue (
          (white 2)
          (black 0)))
        (size_remaining    7051)
        (bits_remaining    12.783612165256038)
        (bits_gained       2.2163878347439621)
        (probability       0.215179443359375)
        (next_best_guesses Not_computed))
       ((cue (
          (white 1)
          (black 1)))
        (size_remaining    5432)
        (bits_remaining    12.407267764244732)
        (bits_gained       2.5927322357552676)
        (probability       0.165771484375)
        (next_best_guesses Not_computed))
       ((cue (
          (white 1)
          (black 0)))
        (size_remaining    5196)
        (bits_remaining    12.343185715447881)
        (bits_gained       2.6568142845521194)
        (probability       0.1585693359375)
        (next_best_guesses Not_computed))
       ((cue (
          (white 2)
          (black 1)))
        (size_remaining    3510)
        (bits_remaining    11.777255315191923)
        (bits_gained       3.2227446848080774)
        (probability       0.10711669921875)
        (next_best_guesses Not_computed))
       ((cue (
          (white 3)
          (black 0)))
        (size_remaining    3095)
        (bits_remaining    11.595723694101627)
        (bits_gained       3.4042763058983727)
        (probability       0.094451904296875)
        (next_best_guesses Not_computed))
       ((cue (
          (white 0)
          (black 1)))
        (size_remaining    2387)
        (bits_remaining    11.220982851081777)
        (bits_gained       3.7790171489182232)
        (probability       0.072845458984375)
        (next_best_guesses Not_computed))
       ((cue (
          (white 0)
          (black 2)))
        (size_remaining    1523)
        (bits_remaining    10.572700226487292)
        (bits_gained       4.4272997735127078)
        (probability       0.046478271484375)
        (next_best_guesses Not_computed))
       ((cue (
          (white 1)
          (black 2)))
        (size_remaining    1497)
        (bits_remaining    10.547858506058416)
        (bits_gained       4.4521414939415838)
        (probability       0.045684814453125)
        (next_best_guesses Not_computed))
       ((cue (
          (white 0)
          (black 0)))
        (size_remaining    1024)
        (bits_remaining    10)
        (bits_gained       5)
        (probability       0.03125)
        (next_best_guesses Not_computed))
       ((cue (
          (white 3)
          (black 1)))
        (size_remaining    652)
        (bits_remaining    9.3487281542310772)
        (bits_gained       5.6512718457689228)
        (probability       0.0198974609375)
        (next_best_guesses Not_computed))
       ((cue (
          (white 4)
          (black 0)))
        (size_remaining    429)
        (bits_remaining    8.7448338374995451)
        (bits_gained       6.2551661625004549)
        (probability       0.013092041015625)
        (next_best_guesses Not_computed))
       ((cue (
          (white 2)
          (black 2)))
        (size_remaining    396)
        (bits_remaining    8.62935662007961)
        (bits_gained       6.37064337992039)
        (probability       0.0120849609375)
        (next_best_guesses Not_computed))
       ((cue (
          (white 0)
          (black 3)))
        (size_remaining    373)
        (bits_remaining    8.5430318202552371)
        (bits_gained       6.4569681797447629)
        (probability       0.011383056640625)
        (next_best_guesses Not_computed))
       ((cue (
          (white 1)
          (black 3)))
        (size_remaining    108)
        (bits_remaining    6.7548875021634682)
        (bits_gained       8.2451124978365318)
        (probability       0.0032958984375)
        (next_best_guesses Not_computed))
       ((cue (
          (white 0)
          (black 4)))
        (size_remaining    35)
        (bits_remaining    5.1292830169449664)
        (bits_gained       9.8707169830550328)
        (probability       0.001068115234375)
        (next_best_guesses Not_computed))
       ((cue (
          (white 4)
          (black 1)))
        (size_remaining    24)
        (bits_remaining    4.5849625007211561)
        (bits_gained       10.415037499278844)
        (probability       0.000732421875)
        (next_best_guesses Not_computed))
       ((cue (
          (white 3)
          (black 2)))
        (size_remaining    14)
        (bits_remaining    3.8073549220576042)
        (bits_gained       11.192645077942396)
        (probability       0.00042724609375)
        (next_best_guesses Not_computed))
       ((cue (
          (white 5)
          (black 0)))
        (size_remaining    12)
        (bits_remaining    3.5849625007211561)
        (bits_gained       11.415037499278844)
        (probability       0.0003662109375)
        (next_best_guesses Not_computed))
       ((cue (
          (white 2)
          (black 3)))
        (size_remaining    9)
        (bits_remaining    3.1699250014423122)
        (bits_gained       11.830074998557688)
        (probability       0.000274658203125)
        (next_best_guesses Not_computed))
       ((cue (
          (white 0)
          (black 5)))
        (size_remaining    1)
        (bits_remaining    0)
        (bits_gained       15)
        (probability       3.0517578125E-05)
        (next_best_guesses Not_computed))))) |}];
  let guess2 =
    Guess.compute
      ~possible_solutions
      ~candidate:(Code.create_exn [| Orange; White; Red; Green; Green |])
  in
  print_s [%sexp (Guess.equal guess { guess2 with candidate = guess.candidate } : bool)];
  [%expect {| true |}]
;;

let%expect_test "color present 3 times" =
  let candidate = Code.create_exn [| Green; Green; Green; White; Red |] in
  let possible_solutions = Codes.all in
  let guess = Guess.compute ~possible_solutions ~candidate in
  print_s [%sexp (guess : Guess.t)];
  [%expect
    {|
    ((candidate (Green Green Green White Red))
     (expected_bits_gained    3.062869507906071)
     (expected_bits_remaining 11.937130492093928)
     (min_bits_gained         2.0414472845689886)
     (max_bits_gained         15)
     (max_bits_remaining      12.958552715431011)
     (by_cue (
       ((cue (
          (white 1)
          (black 0)))
        (size_remaining    7960)
        (bits_remaining    12.958552715431011)
        (bits_gained       2.0414472845689886)
        (probability       0.242919921875)
        (next_best_guesses Not_computed))
       ((cue (
          (white 1)
          (black 1)))
        (size_remaining    5436)
        (bits_remaining    12.408329740767391)
        (bits_gained       2.5916702592326093)
        (probability       0.1658935546875)
        (next_best_guesses Not_computed))
       ((cue (
          (white 2)
          (black 0)))
        (size_remaining    4890)
        (bits_remaining    12.255618749839597)
        (bits_gained       2.7443812501604032)
        (probability       0.14923095703125)
        (next_best_guesses Not_computed))
       ((cue (
          (white 0)
          (black 1)))
        (size_remaining    4467)
        (bits_remaining    12.125090539303256)
        (bits_gained       2.8749094606967436)
        (probability       0.136322021484375)
        (next_best_guesses Not_computed))
       ((cue (
          (white 0)
          (black 0)))
        (size_remaining    3125)
        (bits_remaining    11.609640474436812)
        (bits_gained       3.3903595255631878)
        (probability       0.095367431640625)
        (next_best_guesses Not_computed))
       ((cue (
          (white 0)
          (black 2)))
        (size_remaining    2014)
        (bits_remaining    10.975847968006784)
        (bits_gained       4.024152031993216)
        (probability       0.06146240234375)
        (next_best_guesses Not_computed))
       ((cue (
          (white 2)
          (black 1)))
        (size_remaining    1892)
        (bits_remaining    10.885696373339394)
        (bits_gained       4.1143036266606057)
        (probability       0.0577392578125)
        (next_best_guesses Not_computed))
       ((cue (
          (white 1)
          (black 2)))
        (size_remaining    1179)
        (bits_remaining    10.203348002979762)
        (bits_gained       4.7966519970202377)
        (probability       0.035980224609375)
        (next_best_guesses Not_computed))
       ((cue (
          (white 3)
          (black 0)))
        (size_remaining    796)
        (bits_remaining    9.63662462054365)
        (bits_gained       5.36337537945635)
        (probability       0.0242919921875)
        (next_best_guesses Not_computed))
       ((cue (
          (white 0)
          (black 3)))
        (size_remaining    399)
        (bits_remaining    8.640244936222345)
        (bits_gained       6.359755063777655)
        (probability       0.012176513671875)
        (next_best_guesses Not_computed))
       ((cue (
          (white 2)
          (black 2)))
        (size_remaining    231)
        (bits_remaining    7.8517490414160571)
        (bits_gained       7.1482509585839429)
        (probability       0.007049560546875)
        (next_best_guesses Not_computed))
       ((cue (
          (white 3)
          (black 1)))
        (size_remaining    204)
        (bits_remaining    7.6724253419714952)
        (bits_gained       7.3275746580285048)
        (probability       0.0062255859375)
        (next_best_guesses Not_computed))
       ((cue (
          (white 1)
          (black 3)))
        (size_remaining    84)
        (bits_remaining    6.3923174227787607)
        (bits_gained       8.60768257722124)
        (probability       0.0025634765625)
        (next_best_guesses Not_computed))
       ((cue (
          (white 4)
          (black 0)))
        (size_remaining    36)
        (bits_remaining    5.1699250014423122)
        (bits_gained       9.8300749985576878)
        (probability       0.0010986328125)
        (next_best_guesses Not_computed))
       ((cue (
          (white 0)
          (black 4)))
        (size_remaining    35)
        (bits_remaining    5.1292830169449664)
        (bits_gained       9.8707169830550328)
        (probability       0.001068115234375)
        (next_best_guesses Not_computed))
       ((cue (
          (white 2)
          (black 3)))
        (size_remaining    7)
        (bits_remaining    2.8073549220576042)
        (bits_gained       12.192645077942396)
        (probability       0.000213623046875)
        (next_best_guesses Not_computed))
       ((cue (
          (white 3)
          (black 2)))
        (size_remaining    6)
        (bits_remaining    2.5849625007211561)
        (bits_gained       12.415037499278844)
        (probability       0.00018310546875)
        (next_best_guesses Not_computed))
       ((cue (
          (white 4)
          (black 1)))
        (size_remaining    6)
        (bits_remaining    2.5849625007211561)
        (bits_gained       12.415037499278844)
        (probability       0.00018310546875)
        (next_best_guesses Not_computed))
       ((cue (
          (white 0)
          (black 5)))
        (size_remaining    1)
        (bits_remaining    0)
        (bits_gained       15)
        (probability       3.0517578125E-05)
        (next_best_guesses Not_computed))))) |}];
  let guess2 =
    Guess.compute
      ~possible_solutions
      ~candidate:(Code.create_exn [| White; Red; Green; Green; Green |])
  in
  print_s [%sexp (Guess.equal guess { guess2 with candidate = guess.candidate } : bool)];
  [%expect {| true |}]
;;

let%expect_test "color present 4 times" =
  let candidate = Code.create_exn [| Green; Green; Green; White; Green |] in
  let possible_solutions = Codes.all in
  let guess = Guess.compute ~possible_solutions ~candidate in
  print_s [%sexp (guess : Guess.t)];
  [%expect
    {|
    ((candidate (Green Green Green White Green))
     (expected_bits_gained    2.6420396142285352)
     (expected_bits_remaining 12.357960385771465)
     (min_bits_gained         2.0476227480320155)
     (max_bits_gained         15)
     (max_bits_remaining      12.952377251967985)
     (by_cue (
       ((cue (
          (white 1)
          (black 0)))
        (size_remaining    7926)
        (bits_remaining    12.952377251967985)
        (bits_gained       2.0476227480320155)
        (probability       0.24188232421875)
        (next_best_guesses Not_computed))
       ((cue (
          (white 0)
          (black 0)))
        (size_remaining    7776)
        (bits_remaining    12.92481250360578)
        (bits_gained       2.0751874963942196)
        (probability       0.2373046875)
        (next_best_guesses Not_computed))
       ((cue (
          (white 0)
          (black 1)))
        (size_remaining    7585)
        (bits_remaining    12.888933465134397)
        (bits_gained       2.1110665348656035)
        (probability       0.231475830078125)
        (next_best_guesses Not_computed))
       ((cue (
          (white 1)
          (black 1)))
        (size_remaining    3912)
        (bits_remaining    11.933690654952233)
        (bits_gained       3.0663093450477668)
        (probability       0.119384765625)
        (next_best_guesses Not_computed))
       ((cue (
          (white 0)
          (black 2)))
        (size_remaining    2668)
        (bits_remaining    11.381542951184585)
        (bits_gained       3.6184570488154151)
        (probability       0.0814208984375)
        (next_best_guesses Not_computed))
       ((cue (
          (white 2)
          (black 0)))
        (size_remaining    1105)
        (bits_remaining    10.109830654278793)
        (bits_gained       4.8901693457212065)
        (probability       0.033721923828125)
        (next_best_guesses Not_computed))
       ((cue (
          (white 1)
          (black 2)))
        (size_remaining    684)
        (bits_remaining    9.4178525148858974)
        (bits_gained       5.5821474851141026)
        (probability       0.0208740234375)
        (next_best_guesses Not_computed))
       ((cue (
          (white 2)
          (black 1)))
        (size_remaining    508)
        (bits_remaining    8.9886846867721655)
        (bits_gained       6.0113153132278345)
        (probability       0.0155029296875)
        (next_best_guesses Not_computed))
       ((cue (
          (white 0)
          (black 3)))
        (size_remaining    438)
        (bits_remaining    8.7747870596011737)
        (bits_gained       6.2252129403988263)
        (probability       0.01336669921875)
        (next_best_guesses Not_computed))
       ((cue (
          (white 2)
          (black 2)))
        (size_remaining    78)
        (bits_remaining    6.2854022188622487)
        (bits_gained       8.7145977811377513)
        (probability       0.00238037109375)
        (next_best_guesses Not_computed))
       ((cue (
          (white 1)
          (black 3)))
        (size_remaining    48)
        (bits_remaining    5.5849625007211561)
        (bits_gained       9.4150374992788439)
        (probability       0.00146484375)
        (next_best_guesses Not_computed))
       ((cue (
          (white 0)
          (black 4)))
        (size_remaining    35)
        (bits_remaining    5.1292830169449664)
        (bits_gained       9.8707169830550328)
        (probability       0.001068115234375)
        (next_best_guesses Not_computed))
       ((cue (
          (white 2)
          (black 3)))
        (size_remaining    4)
        (bits_remaining    2)
        (bits_gained       13)
        (probability       0.0001220703125)
        (next_best_guesses Not_computed))
       ((cue (
          (white 0)
          (black 5)))
        (size_remaining    1)
        (bits_remaining    0)
        (bits_gained       15)
        (probability       3.0517578125E-05)
        (next_best_guesses Not_computed))))) |}];
  let guess2 =
    Guess.compute
      ~possible_solutions
      ~candidate:(Code.create_exn [| Red; Red; Green; Red; Red |])
  in
  print_s [%sexp (Guess.equal guess { guess2 with candidate = guess.candidate } : bool)];
  [%expect {| true |}]
;;

let%expect_test "color present 5 times" =
  let candidate = Code.create_exn [| Green; Green; Green; Green; Green |] in
  let possible_solutions = Codes.all in
  let guess = Guess.compute ~possible_solutions ~candidate in
  print_s [%sexp (guess : Guess.t)];
  [%expect
    {|
    ((candidate (Green Green Green Green Green))
     (expected_bits_gained    1.4672737420477167)
     (expected_bits_remaining 13.532726257952284)
     (min_bits_gained         0.96322538971197957)
     (max_bits_gained         15)
     (max_bits_remaining      14.03677461028802)
     (by_cue (
       ((cue (
          (white 0)
          (black 0)))
        (size_remaining    16807)
        (bits_remaining    14.03677461028802)
        (bits_gained       0.96322538971197957)
        (probability       0.512908935546875)
        (next_best_guesses Not_computed))
       ((cue (
          (white 0)
          (black 1)))
        (size_remaining    12005)
        (bits_remaining    13.551347783117778)
        (bits_gained       1.4486522168822216)
        (probability       0.366363525390625)
        (next_best_guesses Not_computed))
       ((cue (
          (white 0)
          (black 2)))
        (size_remaining    3430)
        (bits_remaining    11.743992861060175)
        (bits_gained       3.2560071389398253)
        (probability       0.10467529296875)
        (next_best_guesses Not_computed))
       ((cue (
          (white 0)
          (black 3)))
        (size_remaining    490)
        (bits_remaining    8.936637939002571)
        (bits_gained       6.063362060997429)
        (probability       0.01495361328125)
        (next_best_guesses Not_computed))
       ((cue (
          (white 0)
          (black 4)))
        (size_remaining    35)
        (bits_remaining    5.1292830169449664)
        (bits_gained       9.8707169830550328)
        (probability       0.001068115234375)
        (next_best_guesses Not_computed))
       ((cue (
          (white 0)
          (black 5)))
        (size_remaining    1)
        (bits_remaining    0)
        (bits_gained       15)
        (probability       3.0517578125E-05)
        (next_best_guesses Not_computed))))) |}];
  let guess2 =
    Guess.compute
      ~possible_solutions
      ~candidate:(Code.create_exn [| Red; Red; Red; Red; Red |])
  in
  print_s [%sexp (Guess.equal guess { guess2 with candidate = guess.candidate } : bool)];
  [%expect {| true |}]
;;
