port module Ports exposing (..)


type alias ScrollType =
    { id : String
    , className : String
    }


port sendAlertToJs : String -> Cmd msg


port sendConfirmToJs : String -> Cmd msg


port receiveConfirmFromJs : (String -> msg) -> Sub msg


port scrollThingIntoView : ScrollType -> Cmd msg


port scrollSourceIntoView : ScrollType -> Cmd msg


port scrollPageTop : String -> Cmd msg
