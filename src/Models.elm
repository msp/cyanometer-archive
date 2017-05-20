module Models exposing (..)

import Date exposing (Date, fromString, fromTime)
import Routing exposing (Route(LocationRoute))
import Slideshow.Models
import String exposing (toInt)
import Time exposing (Time)


type alias Endpoint =
    String


type alias Model =
    { loading : Bool
    , route : Routing.Route
    , endpoint : Endpoint
    , images : List Image
    , locations : List Location
    , currentLocation : Location
    , requestedLocationId : Maybe Int
    , fromDate : Date
    , toDate : Date
    , width : Int
    , height : Int
    , renderSlideshow : Bool
    , slideshow : Slideshow.Models.Model
    , currentTick : Time
    }


defaultDate : Date
defaultDate =
    case fromString "01 01 2016" of
        Ok date ->
            date

        _ ->
            fromTime 0


initialModel : Routing.Route -> Endpoint -> Model
initialModel route endpoint =
    let
        newRequestedLocationId =
            case route of
                LocationRoute locationId ->
                    Just (Result.withDefault -1 (String.toInt locationId))

                _ ->
                    Nothing
    in
        { loading = True
        , route = route
        , endpoint = endpoint
        , images = []
        , locations = []
        , currentLocation = newLocation
        , requestedLocationId = newRequestedLocationId
        , fromDate = defaultDate
        , toDate = defaultDate
        , width = 0
        , height = 0
        , renderSlideshow = False
        , slideshow = Slideshow.Models.initialModel
        , currentTick = 0
        }


type alias Image =
    { id : Int
    , s3_url : String
    , taken_at : String
    , blueness_index : String
    }


type alias Location =
    { id : Int
    , place : String
    , country : String
    , city : String
    }


newImage : Image
newImage =
    { id = -1
    , s3_url = ""
    , taken_at = ""
    , blueness_index = ""
    }


newLocation : Location
newLocation =
    { id = -1
    , place = ""
    , country = ""
    , city = ""
    }
