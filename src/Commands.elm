module Commands exposing (..)

import Constants
import Date
import DateUtils exposing (monthAsInt)
import Http
import Json.Decode as Decode exposing (field)
import Json.Decode.Extra exposing ((|:))
import Time
import Messages exposing (Msg(..))
import Models exposing (Image, Model)
import Regex
import Task


defaultToDate : Cmd Msg
defaultToDate =
    Task.perform (Just >> DefaultToDate) Date.now


listImages : Model -> Cmd Msg
listImages model =
    Http.request
        { method = "GET"
        , headers = []
        , url = imagesUrl model
        , body = Http.emptyBody
        , expect =
            Http.expectJson imagesDecoder
        , timeout = Just <| Time.inMilliseconds Constants.networkTimeoutMS
        , withCredentials = False
        }
        |> Http.send OnListImages


imagesUrl : Model -> String
imagesUrl model =
    String.trim (Regex.replace Regex.All (Regex.regex "\"") (\_ -> "") model.endpoint)
        ++ "?count="
        ++ Constants.imageCount
        ++ "&sday="
        ++ toString (Date.day model.fromDate)
        ++ "&smonth="
        ++ toString (monthAsInt <| Date.month model.fromDate)
        ++ "&syear="
        ++ toString (Date.year model.fromDate)
        ++ "&day="
        ++ toString (Date.day model.toDate)
        ++ "&month="
        ++ toString (monthAsInt <| Date.month model.toDate)
        ++ "&year="
        ++ toString (Date.year model.toDate)


imagesDecoder : Decode.Decoder (List Image)
imagesDecoder =
    Decode.list imageDecoder


imageDecoder : Decode.Decoder Image
imageDecoder =
    Decode.succeed
        Image
        |: (field "id" Decode.int)
        |: (field "s3_url" Decode.string)
        |: (field "taken_at" Decode.string)
        |: (field "blueness_index" Decode.string)
