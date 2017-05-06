module View exposing (..)

import Date
import Html exposing (..)
import Html.Attributes exposing (class, id, href)
import Visualization.Shape as Shape exposing (defaultPieConfig, Arc)
import Visualization.Path as Path
import Array exposing (Array)
import Svg exposing (Svg, svg, g, path)
import Svg.Attributes exposing (transform, d, style, dy, width, height, textAnchor)
import Constants exposing (..)
import Messages exposing (Msg(..))
import Models exposing (..)
import Routing exposing (Route(..))
import Spinner


view : Model -> Html Msg
view model =
    page model


page : Model -> Html Msg
page model =
    case model.route of
        ImagesRoute ->
            case model.loading of
                True ->
                    Spinner.render

                False ->
                    imagesView model

        NotFoundRoute ->
            notFoundView model


notFoundView : Model -> Html msg
notFoundView model =
    h2 []
        [ Html.text ("Sorry, unable to find that view!")
        ]


imagesView : Model -> Html Msg
imagesView model =
    let
        pieData =
            List.map (\n -> 1) (List.map .blueness_index model.images) |> Shape.pie { defaultPieConfig | outerRadius = radius }
    in
        div [ class "animated fadeIn" ]
            [ h1 [ class "" ] [ text ("Latest images: " ++ Constants.imageCount) ]
            , svg [ width (toString screenWidth ++ "px"), height (toString screenHeight ++ "px") ]
                [ annular pieData (List.map .blueness_index model.images)
                ]
              -- , ul [ class "gel-layout" ] (List.map imageRow (List.sortBy .taken_at model.images))
            , div [] [ text <| "(Optional) date at program launch was " ++ dateString model ]
            ]


dateString : Model -> String
dateString model =
    case model.toDate of
        Nothing ->
            "No to date here"

        Just date ->
            "the date is "
                ++ (toString <| Date.dayOfWeek date)
                ++ " "
                ++ (toString <| Date.day date)
                ++ " "
                ++ (toString <| Date.month date)
                ++ " "
                ++ (toString <| Date.year date)


imageRow : Image -> Html Msg
imageRow image =
    li [ id (image.id |> toString), class "image gel-layout__item gel-11/12" ]
        [ a []
            [ span [] [ text ((toString image.id) ++ " : ") ]
            , span [] [ text (toString image.blueness_index) ]
            ]
        ]


radius : Float
radius =
    min (screenWidth / 2) screenHeight / 2 - 10


dot : String
dot =
    Path.begin |> Path.moveTo 5 5 |> Path.arc 0 0 5 0 (2 * pi) False |> Path.toAttrString


annular : List Arc -> List String -> Svg msg
annular arcs indicies_s =
    let
        indicies =
            List.map (\i -> Result.withDefault 0 (String.toInt i)) indicies_s

        makeSlice index datum =
            path [ d (Shape.arc { datum | innerRadius = radius - 80 }), style ("fill:" ++ (Maybe.withDefault "#ccc" <| Array.get (Maybe.withDefault 1 <| Array.get index (Array.fromList indicies)) Constants.colors) ++ ";") ] []

        makeDot datum =
            path [ d dot, transform ("translate" ++ toString (Shape.centroid { datum | innerRadius = radius - 60 })) ] []
    in
        g [ transform ("translate(" ++ toString (3 * radius + 20) ++ "," ++ toString radius ++ ")") ]
            [ g [] <| List.indexedMap makeSlice arcs
              -- , g [] <| List.map makeDot arcs
            ]
