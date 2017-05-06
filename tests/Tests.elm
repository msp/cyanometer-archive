module Tests exposing (..)

import DateUtilsTests
import Test exposing (..)
import StringUtilsTests


tests : List (List Test)
tests =
    [ StringUtilsTests.all
    , DateUtilsTests.all
    ]


all : Test
all =
    describe "Cyanometer archive test suite"
        (List.concat tests)
