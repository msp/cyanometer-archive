module Commands exposing (..)

import Constants
import Http
import Json.Decode as Decode exposing (field)
import Json.Decode.Extra exposing ((|:))
import Time
import Messages exposing (Msg(..))
import Models exposing (Image)
import Regex


listImages : String -> Cmd Msg
listImages endpoint =
    Http.request
        { method = "GET"
        , headers = []
        , url = imagesUrl endpoint
        , body = Http.emptyBody
        , expect =
            Http.expectJson imagesDecoder
        , timeout = Just <| Time.inMilliseconds Constants.networkTimeoutMS
        , withCredentials = False
        }
        |> Http.send OnListImages


imagesUrl : String -> String
imagesUrl endpoint =
    String.trim (Regex.replace Regex.All (Regex.regex "\"") (\_ -> "") endpoint) ++ "?count=" ++ Constants.imageCount


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
