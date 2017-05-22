module ViewTests exposing (..)

import Date exposing (Date, Month(Dec), fromString, fromTime)
import Navigation exposing (Location)
import Routing
import Test exposing (..)
import Expect
import DateUtils exposing (..)
import Models
import View


yearRangeTests : List Test
yearRangeTests =
    [ test "View.yearRange: today is 2017" <|
        \() ->
            let
                location =
                    initLocation

                currentRoute =
                    Routing.parseLocation location

                -- hmm, initalModel shouldn't care abou locations etc?
                model_ =
                    Models.initialModel currentRoute "/some-fake-endpoint"

                model =
                    { model_ | today = twentySeventeenDate }

                result =
                    toString <| View.yearRange model
            in
                Expect.equal result "[2016,2017]"
    , test "View.yearRange: today is 2016" <|
        \() ->
            let
                location =
                    initLocation

                currentRoute =
                    Routing.parseLocation location

                model_ =
                    Models.initialModel currentRoute "/some-fake-endpoint"

                model =
                    { model_ | today = twentySixteenDate }

                result =
                    toString <| View.yearRange model
            in
                Expect.equal result "[2016]"
    ]


initLocation : Location
initLocation =
    { href = ""
    , host = ""
    , hostname = ""
    , protocol = ""
    , origin = ""
    , port_ = ""
    , pathname = ""
    , search = ""
    , hash = ""
    , username = ""
    , password = ""
    }


twentySeventeenDate : Date
twentySeventeenDate =
    case fromString "01 01 2017" of
        Ok date ->
            date

        _ ->
            fromTime 0


twentySixteenDate : Date
twentySixteenDate =
    case fromString "01 01 2016" of
        Ok date ->
            date

        _ ->
            fromTime 0


all =
    List.concat
        [ yearRangeTests
        ]
