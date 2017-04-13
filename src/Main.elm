module Main exposing (..)

import Navigation
import Messages exposing (Msg(..))
import Models exposing (Model, Endpoint, initialModel)
import View exposing (view)
import Update exposing (update)
import Commands exposing (listImages)
import Routing exposing (Route)
import Navigation exposing (Location)
import Ports exposing (receiveConfirmFromJs)


init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    let
        currentRoute =
            Routing.parseLocation location
    in
        ( (initialModel currentRoute flags.endpoint), (listImages flags.endpoint) )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


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
