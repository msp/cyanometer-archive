module Update exposing (..)

import Messages exposing (Msg(..))
import Models exposing (Model)
import Ports exposing (..)
import Routing exposing (parseLocation)
import Http


update : Messages.Msg -> Model -> ( Model, Cmd Messages.Msg )
update msg model =
    -- case Debug.log "========= MAIN ========= update" msg of
    case msg of
        OnListImages (Ok newImages) ->
            ( { model
                | images = newImages
                , loading = False
              }
            , Cmd.none
            )

        OnListImages (Err error) ->
            parseHttpError error model

        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location

                cmd =
                    if location.hash == "#images" then
                        -- allow browser back button to do it's thing in FF
                        Cmd.none
                    else
                        scrollPageTop "ignored"
            in
                ( { model | route = newRoute }, cmd )

        NoOp ->
            ( model, Cmd.none )


parseHttpError : Http.Error -> Model -> ( Model, Cmd Msg )
parseHttpError error model =
    let
        errorMessage errorType =
            "That's a "
                ++ errorType
                ++ " :( \n\nOh no! We seem to be having trouble collecting Image data from our server. "
                ++ "If you're sure you have an internet connection then maybe something is up our end. "
                ++ "\n\nPlease contact the Cyanometer team."
    in
        case error of
            Http.NetworkError ->
                ( model, (sendAlertToJs (errorMessage "Http.NetworkError")) )

            Http.Timeout ->
                ( model, (sendAlertToJs (errorMessage "Http.Timeout")) )

            Http.BadUrl error ->
                ( model, (sendAlertToJs (errorMessage "Http.BadUrl")) )

            Http.BadStatus error ->
                ( model, (sendAlertToJs (errorMessage "Http.BadStatus, error: " ++ toString error)) )

            Http.BadPayload msg error ->
                ( model, (sendAlertToJs (errorMessage "Http.BadPayload: \n\n" ++ msg ++ "\n\nerror: " ++ toString error)) )
