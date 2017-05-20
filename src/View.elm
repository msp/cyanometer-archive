module View exposing (..)

import Date exposing (Date, fromString, fromTime)
import DateUtils exposing (daysInMonth, monthAsInt)
import Html exposing (..)
import Html.Attributes exposing (class, disabled, href, id, selected, src, target, value)
import Html.Events exposing (on, onClick, targetValue)
import ImageUtils
import Visualization.Shape as Shape exposing (defaultPieConfig, Arc)
import Visualization.Path as Path
import Array exposing (Array)
import Svg exposing (Svg, svg, g, path)
import Svg.Attributes exposing (d, dy, height, style, textAnchor, transform, viewBox, width)
import Constants exposing (..)
import Messages exposing (Msg(..))
import Models exposing (..)
import Routing exposing (Route(..))
import Spinner
import Json.Decode as Json
import Slideshow.Slideshow as Slideshow


view : Model -> Html Msg
view model =
    page model


page : Model -> Html Msg
page model =
    case model.route of
        ImagesRoute ->
            imagesView model

        LocationRoute locationId ->
            let
                newCurrentLocation =
                    case
                        List.filter (\l -> (l.id |> toString) == locationId) model.locations
                            |> List.head
                    of
                        Just location ->
                            location

                        Nothing ->
                            model.currentLocation

                updatedModel =
                    { model | currentLocation = newCurrentLocation }
            in
                imagesView updatedModel

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
        pageContent =
            case model.renderSlideshow of
                True ->
                    [ Slideshow.view model ]

                False ->
                    [ div [ class "archive-meta" ]
                        [ label [ class "" ] [ text ("Showing " ++ (toString (List.length model.images)) ++ " archive images at") ]
                        , renderLocations model
                        , renderDate model.fromDate model "from"
                        , renderDate model.toDate model "to"
                        ]
                    , div [ class "archive-content" ]
                        (List.concat
                            [ renderPie model ]
                        )
                    ]
    in
        div [ class "animated fadeIn" ]
            (List.concat
                [ pageContent
                ]
            )


renderPie : Model -> List (Html Msg)
renderPie model =
    let
        pieData =
            List.map (\n -> 1) (List.map .blueness_index model.images) |> Shape.pie { defaultPieConfig | outerRadius = (radius model) }

        infoMessage =
            case List.isEmpty model.images of
                True ->
                    p [ class "no-data-found" ] [ text "Sorry, no images found for your search. Please amend above and try again." ]

                False ->
                    span [] []
    in
        case model.loading of
            True ->
                [ Spinner.render ]

            False ->
                [ infoMessage
                , svg [ viewBox ("-2 -2 " ++ (toString model.width) ++ " " ++ (toString model.height)) ]
                    [ annular model pieData (List.map .blueness_index model.images)
                    ]
                , div [ id "thumbnails", class "" ]
                    [ div [ class "slideshow-button" ]
                        [ Slideshow.renderSlideshowButton model
                        ]
                    , div []
                        (List.map renderThumbnail model.images)
                    ]
                ]


debug : Model -> Html Msg
debug model =
    div []
        [ div [] [ text <| (toString <| model.width) ++ "/" ++ (toString <| model.height) ]
        ]


renderThumbnail : Image -> Html Msg
renderThumbnail image =
    let
        imageId =
            "image-" ++ (toString image.id)

        imageUrl =
            ImageUtils.thumbnailImage (image.s3_url)

        imageStyle =
            "backgroundImage: url('"
                ++ imageUrl
                ++ "')"
    in
        div [ id imageId, class "thumbnail" ]
            [ a [ href image.s3_url, target "_blank" ]
                [ img [ src imageUrl ] []
                , p [ class "meta" ] [ text <| Models.formattedDate image ]
                ]
            ]


renderLocationOption : Location -> Int -> Html Msg
renderLocationOption location current =
    let
        label =
            location.country ++ ", " ++ location.city ++ ", " ++ location.place

        isSelected =
            (location.id == current)
    in
        option [ value (toString <| location.id), selected isSelected ] [ text label ]


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
    List.range (Date.year <| Models.defaultDate) (Date.year <| model.toDate)


renderLocations : Model -> Html Msg
renderLocations model =
    select [ class "location", onChange UpdateCurrentLocation, disabled model.loading ] (List.map (\l -> renderLocationOption l model.currentLocation.id) model.locations)


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
            if tag == "to" then
                ( UpdateToDateDay, UpdateToDateMonth, UpdateToDateYear )
            else
                ( UpdateFromDateDay, UpdateFromDateMonth, UpdateFromDateYear )
    in
        div []
            [ label [ class "date-select" ] [ text tag ]
            , select [ class ("date " ++ toString tag), disabled model.loading, onChange dayTagger ] (List.map (\d -> renderDateOption d d currentDay) (List.range 1 lastDayInMonth))
            , select [ class ("date " ++ toString tag), disabled model.loading, onChange monthTagger ] (List.map (\m -> renderDateOption m m currentMonth) (List.range 1 12))
            , select [ class ("date " ++ toString tag), disabled model.loading, onChange yearTagger ] (List.map (\y -> renderDateOption y y currentYear) (yearRange model))
            ]


imageRow : Image -> Html Msg
imageRow image =
    li [ id (image.id |> toString), class "image gel-layout__item gel-11/12" ]
        [ a []
            [ span [] [ text ((toString image.id) ++ " : ") ]
            , span [] [ text (toString image.blueness_index) ]
            ]
        ]


radius : Model -> Float
radius model =
    min ((model.width |> toFloat) / 2) (model.height |> toFloat) / 2 - 10


dot : String
dot =
    Path.begin |> Path.moveTo 5 5 |> Path.arc 0 0 5 0 (2 * pi) False |> Path.toAttrString


annular : Model -> List Arc -> List String -> Svg msg
annular model arcs indicies_s =
    let
        indicies =
            List.map (\i -> Result.withDefault 0 (String.toInt i)) indicies_s

        makeSlice index datum =
            path [ d (Shape.arc { datum | innerRadius = (radius model) - 100 }), style ("fill:" ++ (Maybe.withDefault "#ccc" <| Array.get (Maybe.withDefault 1 <| Array.get index (Array.fromList indicies)) Constants.colors) ++ ";") ] []

        makeDot datum =
            path [ d dot, transform ("translate" ++ toString (Shape.centroid { datum | innerRadius = (radius model) - 60 })) ] []
    in
        g [ transform ("translate(" ++ toString (2 * (radius model) + 8) ++ "," ++ toString (radius model) ++ ")") ]
            [ g [] <| List.indexedMap makeSlice arcs
              -- , g [] <| List.map makeDot arcs
            ]


onChange : (String -> value) -> Attribute value
onChange tagger =
    on "change" (Json.map tagger targetValue)
