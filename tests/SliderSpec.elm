module SliderSpec exposing (..)

import Slider exposing (..)
import Expect
import Fuzz
import Random
import Test exposing (..)

suite : Test
suite =
    describe "1"
    [ describe "ranges"
        [ test "with empty list" <| \_ -> Expect.equal (ranges []) (0, 0)
        , test "with non empty list" <| \_ -> Expect.equal (ranges [2, 3, 4]) (0, 2)
        ]
    , describe "fromIndex"
        [ fuzz Fuzz.int "with empty list" <|
            \index -> Expect.equal (fromIndex [] index) ""
        , fuzz2 (Fuzz.list Fuzz.string) (Fuzz.intRange Random.minInt -1) "with negative index" <|
            \list index -> Expect.equal (fromIndex list index) ""
        , test "with positive index" <|
            \_ -> Expect.equal (fromIndex ["a", "b"] 1) "b"
        ]
    ]
