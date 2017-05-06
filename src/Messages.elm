module Messages exposing (..)

import Date exposing (Date)
import Navigation exposing (Location)
import Models exposing (Image)
import Http


type Msg
    = OnLocationChange Location
    | NoOp
    | OnListImages (Result Http.Error (List Image))
    | SetToDate (Maybe Date)
