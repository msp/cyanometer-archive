module StringUtils exposing (..)

import Char
import Regex


extractOriginalQueryFrom : String -> String
extractOriginalQueryFrom input =
    let
        matches =
            Regex.find Regex.All (Regex.regex "'(.*?)'") input

        submatches =
            List.map .submatches matches

        submatch =
            case List.head submatches of
                Just l ->
                    l

                Nothing ->
                    []

        match =
            case List.head submatch of
                Just s ->
                    s

                Nothing ->
                    Just input

        query =
            case match of
                Just q ->
                    q

                Nothing ->
                    input
    in
        query


truncate : String -> Int -> String
truncate input maxLength =
    if String.length input > maxLength then
        (String.slice 0 maxLength input) ++ "..."
    else
        input


nameToId : String -> String
nameToId input =
    Regex.replace Regex.All (Regex.regex "[ ,!#\"$%&'()\\*\\+\\.\\:\\;_]") (\_ -> "-") input
        |> String.toLower
        |> String.cons '-'
        |> String.cons 't'


capitalize : String -> String
capitalize s =
    case String.uncons s of
        Just ( c, ss ) ->
            String.cons (Char.toUpper c) ss

        Nothing ->
            s
