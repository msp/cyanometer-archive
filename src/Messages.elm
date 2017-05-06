module Messages exposing (..)

import Date exposing (Date)
import Models exposing (Image, Location)
import Http
import Navigation


type Msg
    = OnLocationChange Navigation.Location
    | NoOp
    | OnListImages (Result Http.Error (List Image))
    | OnListLocations (Result Http.Error (List Models.Location))
    | DefaultToDate (Maybe Date)
    | UpdateToDateDay String
    | UpdateToDateMonth String
    | UpdateToDateYear String
    | UpdateFromDateDay String
    | UpdateFromDateMonth String
    | UpdateFromDateYear String
    | UpdateCurrentLocation String
    | UpdateImages
