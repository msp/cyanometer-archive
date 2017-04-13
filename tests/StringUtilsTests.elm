module StringUtilsTests exposing (..)

import Test exposing (..)
import Expect
import StringUtils exposing (..)


extractOriginalQueryFromTests : List Test
extractOriginalQueryFromTests =
    [ test "StringUtils.extractOriginalQueryFrom: basic extraction" <|
        \() ->
            let
                newThing =
                    "Add 'Steve' as a keyword"

                expectedQuery =
                    "Steve"

                result =
                    extractOriginalQueryFrom newThing
            in
                Expect.equal result expectedQuery
    , test "StringUtils.extractOriginalQueryFrom: funky quotes" <|
        \() ->
            let
                newThing =
                    "Add 'Stev\"e' as a keyword"

                expectedQuery =
                    "Stev\"e"

                result =
                    extractOriginalQueryFrom newThing
            in
                Expect.equal result expectedQuery
    , test "StringUtils.extractOriginalQueryFrom: funky chars" <|
        \() ->
            let
                newThing =
                    "Add 'Steve @#$%^&*' as a keyword"

                expectedQuery =
                    "Steve @#$%^&*"

                result =
                    extractOriginalQueryFrom newThing
            in
                Expect.equal result expectedQuery
    , test "StringUtils.extractOriginalQueryFrom: no match on qutes returns input" <|
        \() ->
            let
                newThing =
                    "this string has no quotes"

                expectedQuery =
                    "this string has no quotes"

                result =
                    extractOriginalQueryFrom newThing
            in
                Expect.equal result expectedQuery
    ]


nameToIdTests : List Test
nameToIdTests =
    [ test "StringUtils.nameToId" <|
        \() ->
            let
                result =
                    nameToId "a b,c!d#e$f%g&h'i(j)k*l+m.n;o_p-\"-Q"
            in
                Expect.equal result
                    "t-a-b-c-d-e-f-g-h-i-j-k-l-m-n-o-p---q"
    , test "StringUtils.nameToId: css ids cannot start with number" <|
        \() ->
            let
                result =
                    nameToId "1991 Nepal census"
            in
                Expect.equal result
                    "t-1991-nepal-census"
    ]


all =
    List.concat
        [ extractOriginalQueryFromTests
        , nameToIdTests
        ]
