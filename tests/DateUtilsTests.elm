module DateUtilsTests exposing (..)

import Date
import Test exposing (..)
import Expect
import DateUtils exposing (..)


assembleTests : List Test
assembleTests =
    [ test "DateUtils.assemble 7 4" <|
        \() ->
            let
                result =
                    toString <| assemble 7 4 2017
            in
                Expect.equal result "<Fri Apr 07 2017 00:00:00 GMT+0100 (BST)>"
    , test "DateUtils.assemble 4 7" <|
        \() ->
            let
                result =
                    toString <| assemble 4 7 2017
            in
                Expect.equal result "<Tue Jul 04 2017 00:00:00 GMT+0100 (BST)>"
    , test "DateUtils.assemble 7 4 monthAsInt" <|
        \() ->
            let
                result =
                    toString <| assemble 7 (monthAsInt <| Date.Apr) (2017)
            in
                Expect.equal result "<Fri Apr 07 2017 00:00:00 GMT+0100 (BST)>"
    ]


all =
    List.concat
        [ assembleTests
        ]
