module Messages exposing (..)

import Navigation exposing (Location)
import Models exposing (Image)
import Http


type Msg
    = OnLocationChange Location
    | NoOp
    | OnListImages (Result Http.Error (List Image))
