module Routing exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (Parser, parseHash, map, s, string, (</>), top, oneOf)


type Route
    = ImagesRoute
    | NotFoundRoute


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map ImagesRoute top
        ]


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
