  $ super-master-mind opening-book verify

  $ super-master-mind opening-book verify --color-permutation 137

  $ super-master-mind opening-book dump | wc -l | awk '{print $1}'
  23597

  $ super-master-mind opening-book compute --use-small-game-dimensions --output-file test-opening-book.json

  $ cat test-opening-book.json
  {
    "candidate": 36,
    "expected_bits_gained": 2.742875055006866,
    "expected_bits_remaining": 3.257124944993134,
    "min_bits_gained": 2.0931094043914813,
    "max_bits_gained": 6.0,
    "max_bits_remaining": 3.9068905956085187,
    "by_cue": [
      {
        "cue": 6,
        "size_remaining": 15,
        "bits_remaining": 3.9068905956085187,
        "bits_gained": 2.0931094043914813,
        "probability": 0.234375,
        "next_best_guesses": [
          {
            "candidate": 57,
            "expected_bits_gained": 2.789898095464287,
            "expected_bits_remaining": 1.1169925001442316,
            "min_bits_gained": 1.9068905956085187,
            "max_bits_gained": 3.9068905956085187,
            "max_bits_remaining": 2.0,
            "by_cue": [
              {
                "cue": 5,
                "size_remaining": 4,
                "bits_remaining": 2.0,
                "bits_gained": 1.9068905956085187,
                "probability": 0.26666666666666666,
                "next_best_guesses": [
                  {
                    "candidate": 59,
                    "expected_bits_gained": 2.0,
                    "expected_bits_remaining": 0.0,
                    "min_bits_gained": 2.0,
                    "max_bits_gained": 2.0,
                    "max_bits_remaining": 0.0,
                    "by_cue": [
                      {
                        "cue": 1,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 2.0,
                        "probability": 0.25
                      },
                      {
                        "cue": 2,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 2.0,
                        "probability": 0.25
                      },
                      {
                        "cue": 4,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 2.0,
                        "probability": 0.25
                      },
                      {
                        "cue": 5,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 2.0,
                        "probability": 0.25
                      }
                    ]
                  }
                ]
              },
              {
                "cue": 1,
                "size_remaining": 3,
                "bits_remaining": 1.584962500721156,
                "bits_gained": 2.3219280948873626,
                "probability": 0.2,
                "next_best_guesses": [
                  {
                    "candidate": 53,
                    "expected_bits_gained": 1.5849625007211559,
                    "expected_bits_remaining": 2.220446049250313e-16,
                    "min_bits_gained": 1.584962500721156,
                    "max_bits_gained": 1.584962500721156,
                    "max_bits_remaining": 0.0,
                    "by_cue": [
                      {
                        "cue": 0,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 1.584962500721156,
                        "probability": 0.3333333333333333
                      },
                      {
                        "cue": 1,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 1.584962500721156,
                        "probability": 0.3333333333333333
                      },
                      {
                        "cue": 5,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 1.584962500721156,
                        "probability": 0.3333333333333333
                      }
                    ]
                  }
                ]
              },
              {
                "cue": 2,
                "size_remaining": 2,
                "bits_remaining": 1.0,
                "bits_gained": 2.9068905956085187,
                "probability": 0.13333333333333333,
                "next_best_guesses": [
                  {
                    "candidate": 63,
                    "expected_bits_gained": 1.0,
                    "expected_bits_remaining": 0.0,
                    "min_bits_gained": 1.0,
                    "max_bits_gained": 1.0,
                    "max_bits_remaining": 0.0,
                    "by_cue": [
                      {
                        "cue": 0,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 1.0,
                        "probability": 0.5
                      },
                      {
                        "cue": 1,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 1.0,
                        "probability": 0.5
                      }
                    ]
                  }
                ]
              },
              {
                "cue": 6,
                "size_remaining": 2,
                "bits_remaining": 1.0,
                "bits_gained": 2.9068905956085187,
                "probability": 0.13333333333333333,
                "next_best_guesses": [
                  {
                    "candidate": 62,
                    "expected_bits_gained": 1.0,
                    "expected_bits_remaining": 0.0,
                    "min_bits_gained": 1.0,
                    "max_bits_gained": 1.0,
                    "max_bits_remaining": 0.0,
                    "by_cue": [
                      {
                        "cue": 2,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 1.0,
                        "probability": 0.5
                      },
                      {
                        "cue": 4,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 1.0,
                        "probability": 0.5
                      }
                    ]
                  }
                ]
              },
              {
                "cue": 3,
                "size_remaining": 1,
                "bits_remaining": 0.0,
                "bits_gained": 3.9068905956085187,
                "probability": 0.06666666666666667,
                "next_best_guesses": []
              },
              {
                "cue": 4,
                "size_remaining": 1,
                "bits_remaining": 0.0,
                "bits_gained": 3.9068905956085187,
                "probability": 0.06666666666666667,
                "next_best_guesses": []
              },
              {
                "cue": 7,
                "size_remaining": 1,
                "bits_remaining": 0.0,
                "bits_gained": 3.9068905956085187,
                "probability": 0.06666666666666667,
                "next_best_guesses": []
              },
              {
                "cue": 8,
                "size_remaining": 1,
                "bits_remaining": 0.0,
                "bits_gained": 3.9068905956085187,
                "probability": 0.06666666666666667,
                "next_best_guesses": []
              }
            ]
          }
        ]
      },
      {
        "cue": 1,
        "size_remaining": 12,
        "bits_remaining": 3.584962500721156,
        "bits_gained": 2.415037499278844,
        "probability": 0.1875,
        "next_best_guesses": [
          {
            "candidate": 62,
            "expected_bits_gained": 2.5849625007211556,
            "expected_bits_remaining": 1.0000000000000004,
            "min_bits_gained": 1.584962500721156,
            "max_bits_gained": 3.584962500721156,
            "max_bits_remaining": 2.0,
            "by_cue": [
              {
                "cue": 1,
                "size_remaining": 4,
                "bits_remaining": 2.0,
                "bits_gained": 1.584962500721156,
                "probability": 0.3333333333333333,
                "next_best_guesses": [
                  {
                    "candidate": 55,
                    "expected_bits_gained": 2.0,
                    "expected_bits_remaining": 0.0,
                    "min_bits_gained": 2.0,
                    "max_bits_gained": 2.0,
                    "max_bits_remaining": 0.0,
                    "by_cue": [
                      {
                        "cue": 0,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 2.0,
                        "probability": 0.25
                      },
                      {
                        "cue": 1,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 2.0,
                        "probability": 0.25
                      },
                      {
                        "cue": 2,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 2.0,
                        "probability": 0.25
                      },
                      {
                        "cue": 4,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 2.0,
                        "probability": 0.25
                      }
                    ]
                  }
                ]
              },
              {
                "cue": 0,
                "size_remaining": 2,
                "bits_remaining": 1.0,
                "bits_gained": 2.584962500721156,
                "probability": 0.16666666666666666,
                "next_best_guesses": [
                  {
                    "candidate": 61,
                    "expected_bits_gained": 1.0,
                    "expected_bits_remaining": 0.0,
                    "min_bits_gained": 1.0,
                    "max_bits_gained": 1.0,
                    "max_bits_remaining": 0.0,
                    "by_cue": [
                      {
                        "cue": 0,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 1.0,
                        "probability": 0.5
                      },
                      {
                        "cue": 1,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 1.0,
                        "probability": 0.5
                      }
                    ]
                  }
                ]
              },
              {
                "cue": 2,
                "size_remaining": 2,
                "bits_remaining": 1.0,
                "bits_gained": 2.584962500721156,
                "probability": 0.16666666666666666,
                "next_best_guesses": [
                  {
                    "candidate": 63,
                    "expected_bits_gained": 1.0,
                    "expected_bits_remaining": 0.0,
                    "min_bits_gained": 1.0,
                    "max_bits_gained": 1.0,
                    "max_bits_remaining": 0.0,
                    "by_cue": [
                      {
                        "cue": 1,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 1.0,
                        "probability": 0.5
                      },
                      {
                        "cue": 2,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 1.0,
                        "probability": 0.5
                      }
                    ]
                  }
                ]
              },
              {
                "cue": 4,
                "size_remaining": 1,
                "bits_remaining": 0.0,
                "bits_gained": 3.584962500721156,
                "probability": 0.08333333333333333,
                "next_best_guesses": []
              },
              {
                "cue": 5,
                "size_remaining": 1,
                "bits_remaining": 0.0,
                "bits_gained": 3.584962500721156,
                "probability": 0.08333333333333333,
                "next_best_guesses": []
              },
              {
                "cue": 6,
                "size_remaining": 1,
                "bits_remaining": 0.0,
                "bits_gained": 3.584962500721156,
                "probability": 0.08333333333333333,
                "next_best_guesses": []
              },
              {
                "cue": 7,
                "size_remaining": 1,
                "bits_remaining": 0.0,
                "bits_gained": 3.584962500721156,
                "probability": 0.08333333333333333,
                "next_best_guesses": []
              }
            ]
          }
        ]
      },
      {
        "cue": 5,
        "size_remaining": 12,
        "bits_remaining": 3.584962500721156,
        "bits_gained": 2.415037499278844,
        "probability": 0.1875,
        "next_best_guesses": [
          {
            "candidate": 56,
            "expected_bits_gained": 2.6887218755408666,
            "expected_bits_remaining": 0.8962406251802895,
            "min_bits_gained": 2.0,
            "max_bits_gained": 3.584962500721156,
            "max_bits_remaining": 1.584962500721156,
            "by_cue": [
              {
                "cue": 6,
                "size_remaining": 3,
                "bits_remaining": 1.584962500721156,
                "bits_gained": 2.0,
                "probability": 0.25,
                "next_best_guesses": [
                  {
                    "candidate": 62,
                    "expected_bits_gained": 1.5849625007211559,
                    "expected_bits_remaining": 2.220446049250313e-16,
                    "min_bits_gained": 1.584962500721156,
                    "max_bits_gained": 1.584962500721156,
                    "max_bits_remaining": 0.0,
                    "by_cue": [
                      {
                        "cue": 1,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 1.584962500721156,
                        "probability": 0.3333333333333333
                      },
                      {
                        "cue": 4,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 1.584962500721156,
                        "probability": 0.3333333333333333
                      },
                      {
                        "cue": 5,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 1.584962500721156,
                        "probability": 0.3333333333333333
                      }
                    ]
                  }
                ]
              },
              {
                "cue": 1,
                "size_remaining": 2,
                "bits_remaining": 1.0,
                "bits_gained": 2.584962500721156,
                "probability": 0.16666666666666666,
                "next_best_guesses": [
                  {
                    "candidate": 62,
                    "expected_bits_gained": 1.0,
                    "expected_bits_remaining": 0.0,
                    "min_bits_gained": 1.0,
                    "max_bits_gained": 1.0,
                    "max_bits_remaining": 0.0,
                    "by_cue": [
                      {
                        "cue": 0,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 1.0,
                        "probability": 0.5
                      },
                      {
                        "cue": 4,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 1.0,
                        "probability": 0.5
                      }
                    ]
                  }
                ]
              },
              {
                "cue": 4,
                "size_remaining": 2,
                "bits_remaining": 1.0,
                "bits_gained": 2.584962500721156,
                "probability": 0.16666666666666666,
                "next_best_guesses": [
                  {
                    "candidate": 62,
                    "expected_bits_gained": 1.0,
                    "expected_bits_remaining": 0.0,
                    "min_bits_gained": 1.0,
                    "max_bits_gained": 1.0,
                    "max_bits_remaining": 0.0,
                    "by_cue": [
                      {
                        "cue": 0,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 1.0,
                        "probability": 0.5
                      },
                      {
                        "cue": 1,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 1.0,
                        "probability": 0.5
                      }
                    ]
                  }
                ]
              },
              {
                "cue": 5,
                "size_remaining": 2,
                "bits_remaining": 1.0,
                "bits_gained": 2.584962500721156,
                "probability": 0.16666666666666666,
                "next_best_guesses": [
                  {
                    "candidate": 62,
                    "expected_bits_gained": 1.0,
                    "expected_bits_remaining": 0.0,
                    "min_bits_gained": 1.0,
                    "max_bits_gained": 1.0,
                    "max_bits_remaining": 0.0,
                    "by_cue": [
                      {
                        "cue": 1,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 1.0,
                        "probability": 0.5
                      },
                      {
                        "cue": 2,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 1.0,
                        "probability": 0.5
                      }
                    ]
                  }
                ]
              },
              {
                "cue": 2,
                "size_remaining": 1,
                "bits_remaining": 0.0,
                "bits_gained": 3.584962500721156,
                "probability": 0.08333333333333333,
                "next_best_guesses": []
              },
              {
                "cue": 3,
                "size_remaining": 1,
                "bits_remaining": 0.0,
                "bits_gained": 3.584962500721156,
                "probability": 0.08333333333333333,
                "next_best_guesses": []
              },
              {
                "cue": 8,
                "size_remaining": 1,
                "bits_remaining": 0.0,
                "bits_gained": 3.584962500721156,
                "probability": 0.08333333333333333,
                "next_best_guesses": []
              }
            ]
          }
        ]
      },
      {
        "cue": 2,
        "size_remaining": 9,
        "bits_remaining": 3.169925001442312,
        "bits_gained": 2.830074998557688,
        "probability": 0.140625,
        "next_best_guesses": [
          {
            "candidate": 56,
            "expected_bits_gained": 2.503258334775645,
            "expected_bits_remaining": 0.666666666666667,
            "min_bits_gained": 2.169925001442312,
            "max_bits_gained": 3.169925001442312,
            "max_bits_remaining": 1.0,
            "by_cue": [
              {
                "cue": 1,
                "size_remaining": 2,
                "bits_remaining": 1.0,
                "bits_gained": 2.169925001442312,
                "probability": 0.2222222222222222,
                "next_best_guesses": [
                  {
                    "candidate": 53,
                    "expected_bits_gained": 1.0,
                    "expected_bits_remaining": 0.0,
                    "min_bits_gained": 1.0,
                    "max_bits_gained": 1.0,
                    "max_bits_remaining": 0.0,
                    "by_cue": [
                      {
                        "cue": 1,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 1.0,
                        "probability": 0.5
                      },
                      {
                        "cue": 5,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 1.0,
                        "probability": 0.5
                      }
                    ]
                  }
                ]
              },
              {
                "cue": 2,
                "size_remaining": 2,
                "bits_remaining": 1.0,
                "bits_gained": 2.169925001442312,
                "probability": 0.2222222222222222,
                "next_best_guesses": [
                  {
                    "candidate": 63,
                    "expected_bits_gained": 1.0,
                    "expected_bits_remaining": 0.0,
                    "min_bits_gained": 1.0,
                    "max_bits_gained": 1.0,
                    "max_bits_remaining": 0.0,
                    "by_cue": [
                      {
                        "cue": 0,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 1.0,
                        "probability": 0.5
                      },
                      {
                        "cue": 1,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 1.0,
                        "probability": 0.5
                      }
                    ]
                  }
                ]
              },
              {
                "cue": 4,
                "size_remaining": 2,
                "bits_remaining": 1.0,
                "bits_gained": 2.169925001442312,
                "probability": 0.2222222222222222,
                "next_best_guesses": [
                  {
                    "candidate": 62,
                    "expected_bits_gained": 1.0,
                    "expected_bits_remaining": 0.0,
                    "min_bits_gained": 1.0,
                    "max_bits_gained": 1.0,
                    "max_bits_remaining": 0.0,
                    "by_cue": [
                      {
                        "cue": 1,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 1.0,
                        "probability": 0.5
                      },
                      {
                        "cue": 4,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 1.0,
                        "probability": 0.5
                      }
                    ]
                  }
                ]
              },
              {
                "cue": 5,
                "size_remaining": 1,
                "bits_remaining": 0.0,
                "bits_gained": 3.169925001442312,
                "probability": 0.1111111111111111,
                "next_best_guesses": []
              },
              {
                "cue": 6,
                "size_remaining": 1,
                "bits_remaining": 0.0,
                "bits_gained": 3.169925001442312,
                "probability": 0.1111111111111111,
                "next_best_guesses": []
              },
              {
                "cue": 7,
                "size_remaining": 1,
                "bits_remaining": 0.0,
                "bits_gained": 3.169925001442312,
                "probability": 0.1111111111111111,
                "next_best_guesses": []
              }
            ]
          }
        ]
      },
      {
        "cue": 4,
        "size_remaining": 9,
        "bits_remaining": 3.169925001442312,
        "bits_gained": 2.830074998557688,
        "probability": 0.140625,
        "next_best_guesses": [
          {
            "candidate": 62,
            "expected_bits_gained": 2.419381945646371,
            "expected_bits_remaining": 0.7505430557959412,
            "min_bits_gained": 1.584962500721156,
            "max_bits_gained": 3.169925001442312,
            "max_bits_remaining": 1.584962500721156,
            "by_cue": [
              {
                "cue": 5,
                "size_remaining": 3,
                "bits_remaining": 1.584962500721156,
                "bits_gained": 1.584962500721156,
                "probability": 0.3333333333333333,
                "next_best_guesses": [
                  {
                    "candidate": 57,
                    "expected_bits_gained": 1.5849625007211559,
                    "expected_bits_remaining": 2.220446049250313e-16,
                    "min_bits_gained": 1.584962500721156,
                    "max_bits_gained": 1.584962500721156,
                    "max_bits_remaining": 0.0,
                    "by_cue": [
                      {
                        "cue": 1,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 1.584962500721156,
                        "probability": 0.3333333333333333
                      },
                      {
                        "cue": 4,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 1.584962500721156,
                        "probability": 0.3333333333333333
                      },
                      {
                        "cue": 6,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 1.584962500721156,
                        "probability": 0.3333333333333333
                      }
                    ]
                  }
                ]
              },
              {
                "cue": 2,
                "size_remaining": 2,
                "bits_remaining": 1.0,
                "bits_gained": 2.169925001442312,
                "probability": 0.2222222222222222,
                "next_best_guesses": [
                  {
                    "candidate": 63,
                    "expected_bits_gained": 1.0,
                    "expected_bits_remaining": 0.0,
                    "min_bits_gained": 1.0,
                    "max_bits_gained": 1.0,
                    "max_bits_remaining": 0.0,
                    "by_cue": [
                      {
                        "cue": 1,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 1.0,
                        "probability": 0.5
                      },
                      {
                        "cue": 2,
                        "size_remaining": 1,
                        "bits_remaining": 0.0,
                        "bits_gained": 1.0,
                        "probability": 0.5
                      }
                    ]
                  }
                ]
              },
              {
                "cue": 1,
                "size_remaining": 1,
                "bits_remaining": 0.0,
                "bits_gained": 3.169925001442312,
                "probability": 0.1111111111111111,
                "next_best_guesses": []
              },
              {
                "cue": 3,
                "size_remaining": 1,
                "bits_remaining": 0.0,
                "bits_gained": 3.169925001442312,
                "probability": 0.1111111111111111,
                "next_best_guesses": []
              },
              {
                "cue": 4,
                "size_remaining": 1,
                "bits_remaining": 0.0,
                "bits_gained": 3.169925001442312,
                "probability": 0.1111111111111111,
                "next_best_guesses": []
              },
              {
                "cue": 7,
                "size_remaining": 1,
                "bits_remaining": 0.0,
                "bits_gained": 3.169925001442312,
                "probability": 0.1111111111111111,
                "next_best_guesses": []
              }
            ]
          }
        ]
      },
      {
        "cue": 7,
        "size_remaining": 3,
        "bits_remaining": 1.584962500721156,
        "bits_gained": 4.415037499278844,
        "probability": 0.046875,
        "next_best_guesses": [
          {
            "candidate": 41,
            "expected_bits_gained": 1.5849625007211559,
            "expected_bits_remaining": 2.220446049250313e-16,
            "min_bits_gained": 1.584962500721156,
            "max_bits_gained": 1.584962500721156,
            "max_bits_remaining": 0.0,
            "by_cue": [
              {
                "cue": 2,
                "size_remaining": 1,
                "bits_remaining": 0.0,
                "bits_gained": 1.584962500721156,
                "probability": 0.3333333333333333,
                "next_best_guesses": []
              },
              {
                "cue": 5,
                "size_remaining": 1,
                "bits_remaining": 0.0,
                "bits_gained": 1.584962500721156,
                "probability": 0.3333333333333333,
                "next_best_guesses": []
              },
              {
                "cue": 6,
                "size_remaining": 1,
                "bits_remaining": 0.0,
                "bits_gained": 1.584962500721156,
                "probability": 0.3333333333333333,
                "next_best_guesses": []
              }
            ]
          }
        ]
      },
      {
        "cue": 8,
        "size_remaining": 2,
        "bits_remaining": 1.0,
        "bits_gained": 5.0,
        "probability": 0.03125,
        "next_best_guesses": [
          {
            "candidate": 62,
            "expected_bits_gained": 1.0,
            "expected_bits_remaining": 0.0,
            "min_bits_gained": 1.0,
            "max_bits_gained": 1.0,
            "max_bits_remaining": 0.0,
            "by_cue": [
              {
                "cue": 1,
                "size_remaining": 1,
                "bits_remaining": 0.0,
                "bits_gained": 1.0,
                "probability": 0.5,
                "next_best_guesses": []
              },
              {
                "cue": 4,
                "size_remaining": 1,
                "bits_remaining": 0.0,
                "bits_gained": 1.0,
                "probability": 0.5,
                "next_best_guesses": []
              }
            ]
          }
        ]
      },
      {
        "cue": 0,
        "size_remaining": 1,
        "bits_remaining": 0.0,
        "bits_gained": 6.0,
        "probability": 0.015625,
        "next_best_guesses": []
      },
      {
        "cue": 3,
        "size_remaining": 1,
        "bits_remaining": 0.0,
        "bits_gained": 6.0,
        "probability": 0.015625,
        "next_best_guesses": []
      }
    ]
  }
