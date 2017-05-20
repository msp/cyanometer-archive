module Slideshow.Models exposing (..)


type alias Model =
    { play : Bool
    , state : Int
    , imageUrl : Maybe String
    , imageLoaded : Bool
    , message : String
    , rate : Int
    }


initialModel : Model
initialModel =
    { play = False
    , state = 1
    , imageUrl = Nothing
    , imageLoaded = False
    , message = "Nothing loaded yet"
    , rate = 1
    }
