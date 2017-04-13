module Tests exposing (..)

import Test exposing (..)
import StringUtilsTests


tests : List (List Test)
tests =
    [ StringUtilsTests.all
    ]


all : Test
all =
    describe "Cyanometer archive test suite"
        (List.concat tests)
