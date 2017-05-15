module Main exposing (..)

import Navigation
import Messages exposing (Msg(..))
import Models exposing (Model, Endpoint, initialModel)
import View exposing (view)
import Update exposing (update)
import Commands exposing (defaultToDate, listImages, listLocations)
import Routing exposing (Route)
import Navigation exposing (Location)
import Window exposing (..)


init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    let
        currentRoute =
            Routing.parseLocation location

        firstModel =
            initialModel currentRoute flags.endpoint
    in
        ( firstModel, listLocations firstModel )


subscriptions : Model -> Sub Msg
subscriptions model =
    Window.resizes (\{ height, width } -> ResizeWindow width height)


type alias Flags =
    { endpoint : Endpoint
    }



-- MAIN


main : Program Flags Model Msg
main =
    Navigation.programWithFlags OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
