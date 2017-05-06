module Models exposing (..)

import Date exposing (Date)
import Routing


type alias Endpoint =
    String


type alias Model =
    { loading : Bool
    , route : Routing.Route
    , endpoint : Endpoint
    , images : List Image
    , fromDate : Maybe Date
    , toDate : Maybe Date
    }


initialModel : Routing.Route -> Endpoint -> Model
initialModel route endpoint =
    { loading = True
    , route = route
    , endpoint = endpoint
    , images = []
    , fromDate = Nothing
    , toDate = Nothing
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
