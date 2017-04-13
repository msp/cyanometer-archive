module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, id, href)
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
        [ text ("Sorry, unable to find that view!")
        ]


imagesView : Model -> Html Msg
imagesView model =
    div [ class "animated fadeIn" ]
        [ h1 [ class "" ] [ text "Images" ]
        , ul [ class "gel-layout" ] (List.map imageRow (List.sortBy .taken_at model.images))
        ]


imageRow : Image -> Html Msg
imageRow image =
    li [ id (image.id |> toString), class "image gel-layout__item gel-11/12" ]
        [ a []
            [ span [] [ text ((toString image.id) ++ " ") ]
              -- , span [] [ text image.s3_url ]
            ]
        ]
