module Models exposing (..)

import Routing


type alias Endpoint =
    String


type alias Model =
    { loading : Bool
    , route : Routing.Route
    , endpoint : Endpoint
    , images : List Image
    }


initialModel : Routing.Route -> Endpoint -> Model
initialModel route endpoint =
    { loading = True
    , route = route
    , endpoint = endpoint
    , images = []
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
