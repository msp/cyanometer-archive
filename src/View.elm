module View exposing (..)

import Date exposing (Date, fromString, fromTime)
import DateUtils exposing (daysInMonth, monthAsInt)
import Html exposing (..)
import Html.Attributes exposing (class, href, id, selected, value)
import Html.Events exposing (on, onClick, targetValue)
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
import Json.Decode as Json


view : Model -> Html Msg
view model =
    page model


page : Model -> Html Msg
page model =
    case model.route of
        ImagesRoute ->
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
    div [ class "animated fadeIn" ]
        [ h1 [ class "" ] [ text ("Showing " ++ (toString (List.length model.images)) ++ " archive images between:") ]
          --        , debug model
        , renderDate model.fromDate model "from-date"
        , renderDate model.toDate model "to-date"
        , renderPie model
          -- , ul [ class "gel-layout" ] (List.map imageRow (List.sortBy .taken_at model.images))
        ]


renderPie : Model -> Html Msg
renderPie model =
    let
        pieData =
            List.map (\n -> 1) (List.map .blueness_index model.images) |> Shape.pie { defaultPieConfig | outerRadius = radius }
    in
        case model.loading of
            True ->
                Spinner.render

            False ->
                svg [ width (toString screenWidth ++ "px"), height (toString screenHeight ++ "px") ]
                    [ annular pieData (List.map .blueness_index model.images)
                    ]


debug : Model -> Html Msg
debug model =
    div []
        [ div [] [ text <| toString <| model.fromDate ]
        , div [] [ text <| toString <| model.toDate ]
        ]


renderDateOption : Int -> Int -> Int -> Html Msg
renderDateOption val label current =
    let
        isSelected =
            (val == current)

        className =
            case isSelected of
                True ->
                    "selected"

                False ->
                    ""
    in
        option [ value (toString <| val), selected isSelected, class className ] [ text (toString <| label) ]


yearRange : Model -> List Int
yearRange model =
    List.range (Date.year <| model.fromDate) (Date.year <| model.toDate)


renderDate : Date -> Model -> String -> Html Msg
renderDate date model tag =
    let
        currentDay =
            Date.day date

        currentMonth =
            monthAsInt <| Date.month date

        currentYear =
            Date.year date

        lastDayInMonth =
            daysInMonth date

        ( dayTagger, monthTagger, yearTagger ) =
            if tag == "to-date" then
                ( UpdateToDateDay, UpdateToDateMonth, UpdateToDateYear )
            else
                ( UpdateFromDateDay, UpdateFromDateMonth, UpdateFromDateYear )
    in
        div []
            [ select [ class <| toString tag, onChange dayTagger ] (List.map (\d -> renderDateOption d d currentDay) (List.range 1 lastDayInMonth))
            , select [ class <| toString tag, onChange monthTagger ] (List.map (\m -> renderDateOption m m currentMonth) (List.range 1 12))
            , select [ class <| toString tag, onChange yearTagger ] (List.map (\y -> renderDateOption y y currentYear) (yearRange model))
            ]


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


onChange tagger =
    on "change" (Json.map tagger targetValue)
