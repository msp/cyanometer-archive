module Models exposing (..)

import Date exposing (Date, fromString, fromTime)
import Routing


type alias Endpoint =
    String


type alias Model =
    { loading : Bool
    , route : Routing.Route
    , endpoint : Endpoint
    , images : List Image
    , fromDate : Date
    , toDate : Date
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
    { loading = True
    , route = route
    , endpoint = endpoint
    , images = []
    , fromDate = defaultDate
    , toDate = defaultDate
    }


type alias Image =
    { id : Int
    , s3_url : String
    , taken_at : String
    , blueness_index : String
    }


newImage : Image
newImage =
    { id = -1
    , s3_url = ""
    , taken_at = ""
    , blueness_index = ""
    }
