module Slideshow.Slideshow exposing (..)

import Html exposing (Html, br, button, div, img, input, p, span, text)
import Html.Attributes as HTA exposing (class, classList, id, src, title, type_, value)
import Html.Events exposing (on, onClick, onInput)
import Messages exposing (Msg(Begin, End, ImageLoaded, Next, Play, Prev, ShowSlideshow, Stop, UpdateRate))
import Models exposing (Model)
import Json.Decode as JD
import Spinner


------------------------------------ UPDATE ------------------------------------


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        numSlides =
            List.length model.images

        currentState =
            model.slideshow.state

        currentSlideshow =
            model.slideshow

        updatedSlideshow =
            { currentSlideshow
                | state = (calculateNewState msg numSlides currentState)
                , imageLoaded = False
            }
    in
        ( { model | slideshow = updatedSlideshow }, Cmd.none )


calculateNewState : Msg -> Int -> Int -> Int
calculateNewState msg numSlides currentState =
    case msg of
        Begin ->
            1

        End ->
            numSlides

        Next ->
            case ((currentState + 1) <= numSlides) of
                True ->
                    currentState + 1

                False ->
                    1

        Prev ->
            case ((currentState - 1) >= 1) of
                True ->
                    currentState - 1

                False ->
                    numSlides

        _ ->
            currentState



------------------------------------ VIEW ------------------------------------


view : Model -> Html Msg
view model =
    let
        numSlides =
            List.length model.images

        currentState =
            model.slideshow.state

        currentImage =
            case List.take model.slideshow.state model.images |> List.drop (model.slideshow.state - 1) |> List.head of
                Just image ->
                    image

                Nothing ->
                    Models.newImage

        nextImageIndex =
            calculateNewState Next numSlides currentState

        nextImage =
            case List.take nextImageIndex model.images |> List.drop (nextImageIndex - 1) |> List.head of
                Just image ->
                    image

                Nothing ->
                    Models.newImage

        slide =
            --img [ src currentImage.s3_url, onLoadSrc ImageLoaded, classList [ ( "hidden", (model.imageLoaded == False) ) ] ] []
            img [ src currentImage.s3_url, onLoadSrc ImageLoaded, class "animated fadeInLeft" ] []

        nextSlide =
            img [ src nextImage.s3_url, class "hidden" ] []

        loading =
            case model.slideshow.imageLoaded of
                False ->
                    Spinner.render

                True ->
                    text ""

        playedCounter =
            (toString model.slideshow.state) ++ "/" ++ (toString <| List.length model.images)

        location =
            model.currentLocation

        locationString =
            location.country ++ ", " ++ location.city

        meta =
            div [ class "meta" ]
                [ p []
                    [ span [] [ text <| locationString ]
                    , br [] []
                    , span [] [ text <| Models.formattedDate currentImage ]
                    ]
                ]

        transport =
            let
                ( msg, hint ) =
                    case model.slideshow.play of
                        True ->
                            ( Stop, "stop" )

                        False ->
                            ( Play, "play" )
            in
                button [ class "play-stop", onClick msg, title hint ] [ text playedCounter ]

        rate =
            input
                [ type_ "range"
                , class "rate"
                , HTA.min "1"
                , HTA.max "3"
                , value (toString model.slideshow.rate)
                , onInput UpdateRate
                ]
                [ text <| toString model.slideshow.rate ]
    in
        div [ class "slideshow" ]
            [ div [ class "transport" ]
                [ rate
                , button [ onClick Begin, title "begin" ] [ text "<<" ]
                , button [ onClick Prev, title "prev" ] [ text "<" ]
                , transport
                , button [ onClick Next, title "next" ] [ text ">" ]
                , button [ onClick End, title "end" ] [ text ">>" ]
                , renderSlideshowButton model
                ]
            , div [ class "images" ]
                [ -- , loading
                  slide
                , nextSlide
                ]
            , meta
            ]


renderSlideshowButton : Model -> Html Msg
renderSlideshowButton model =
    let
        ( slideshowButtonText, playState, hint ) =
            case model.renderSlideshow of
                True ->
                    ( "x", False, "close" )

                False ->
                    ( "Time-lapse", True, "start a time-lapse of sky images" )
    in
        button [ id "slideshow-button", title hint, onClick <| ShowSlideshow playState ] [ text slideshowButtonText ]


onLoadSrc : (String -> msg) -> Html.Attribute msg
onLoadSrc tagger =
    on "load" (JD.map tagger targetSrc)


targetSrc : JD.Decoder String
targetSrc =
    JD.at [ "target", "src" ] JD.string
