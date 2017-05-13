module Routing exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (Parser, parseHash, map, s, string, (</>), top, oneOf)


type Route
    = ImagesRoute
    | LocationRoute LocationId
    | NotFoundRoute


type alias LocationId =
    String


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map ImagesRoute top
        , map LocationRoute (s "location" </> string)
        ]


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
