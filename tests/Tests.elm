module Tests exposing (..)

import DateUtilsTests
import Test exposing (..)
import StringUtilsTests
import ViewTests


tests : List (List Test)
tests =
    [ StringUtilsTests.all
    , DateUtilsTests.all
    , ViewTests.all
    ]


all : Test
all =
    describe "Cyanometer archive test suite"
        (List.concat tests)
