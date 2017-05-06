module Update exposing (..)

import Commands exposing (listImages)
import Date
import DateUtils exposing (monthAsInt)
import Messages exposing (Msg(..))
import Models exposing (Model)
import Ports exposing (..)
import Routing exposing (parseLocation)
import Http
import String exposing (toInt)


update : Messages.Msg -> Model -> ( Model, Cmd Messages.Msg )
update msg model =
    case Debug.log "========= MAIN ========= update" msg of
        --    case msg of
        UpdateImages ->
            ( model, listImages model )

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

        DefaultToDate date ->
            case date of
                Just date ->
                    let
                        updatedModel =
                            { model | toDate = date, loading = True }
                    in
                        ( updatedModel
                        , listImages updatedModel
                        )

                Nothing ->
                    ( model, Cmd.none )

        UpdateFromDateDay d ->
            case (toInt d) of
                Ok day ->
                    let
                        updatedModel =
                            { model
                                | fromDate = DateUtils.assemble day (monthAsInt <| Date.month model.fromDate) (Date.year model.fromDate)
                                , loading = True
                            }
                    in
                        ( updatedModel
                        , listImages updatedModel
                        )

                _ ->
                    ( model, Cmd.none )

        UpdateFromDateMonth m ->
            case (toInt m) of
                Ok month ->
                    let
                        updatedModel =
                            { model
                                | fromDate = DateUtils.assemble (Date.day model.fromDate) month (Date.year model.fromDate)
                                , loading = True
                            }
                    in
                        ( updatedModel
                        , listImages updatedModel
                        )

                _ ->
                    ( model, Cmd.none )

        UpdateFromDateYear y ->
            case (toInt y) of
                Ok year ->
                    let
                        updatedModel =
                            { model
                                | fromDate = DateUtils.assemble (Date.day model.fromDate) (monthAsInt <| Date.month model.fromDate) year
                                , loading = True
                            }
                    in
                        ( updatedModel
                        , listImages updatedModel
                        )

                _ ->
                    ( model, Cmd.none )

        UpdateToDateDay d ->
            case (toInt d) of
                Ok day ->
                    let
                        updatedModel =
                            { model
                                | toDate =
                                    DateUtils.assemble day (monthAsInt <| Date.month model.toDate) (Date.year model.toDate)
                                , loading = True
                            }
                    in
                        ( updatedModel
                        , listImages updatedModel
                        )

                _ ->
                    ( model, Cmd.none )

        UpdateToDateMonth m ->
            case (toInt m) of
                Ok month ->
                    let
                        updatedModel =
                            { model
                                | toDate = DateUtils.assemble (Date.day model.toDate) month (Date.year model.toDate)
                                , loading = True
                            }
                    in
                        ( updatedModel
                        , listImages updatedModel
                        )

                _ ->
                    ( model, Cmd.none )

        UpdateToDateYear y ->
            case (toInt y) of
                Ok year ->
                    let
                        updatedModel =
                            { model
                                | toDate = DateUtils.assemble (Date.day model.toDate) (monthAsInt <| Date.month model.fromDate) year
                                , loading = True
                            }
                    in
                        ( updatedModel
                        , listImages updatedModel
                        )

                _ ->
                    ( model, Cmd.none )

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
