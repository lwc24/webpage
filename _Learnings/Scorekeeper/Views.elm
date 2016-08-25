module Views exposing (..)
import Html exposing ( Html, form, div, button, h1, text, p, input, header, ul, li, i, footer)
import Html.Events exposing ( onSubmit, onInput, onClick )
import Html.Attributes exposing ( type', placeholder, value, class )
import Models exposing ( Model, Msg(..), Player  )

view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Score Keeper!" ]
        , playerSection model
        , playerForm model
        , p [] [ text <| toString model ]
        ]

playerSection : Model -> Html Msg
playerSection model =
    div []
        [ playerListHeader
        , playerList model
        , pointTotal model
        ]

playerListHeader : Html Msg
playerListHeader =
    header []
        [ div [] [ text "Name" ]
        , div [] [ text "Points" ]
        ]

playerList : Model -> Html Msg
playerList model =
--     ul [] ( List.map player model.players )
    model.players   |> List.sortBy .name
                    |> List.map player
                    |> ul []


player : Player -> Html Msg
player player =
    li []
        [ button
            [ type' "button"
            , onClick (Edit player) ]
            [ text "Edit" ]
        , div [] [ text player.name ]
        , button
            [ type' "button"
            , onClick (Score player 2)
            ]
            [ text "2 pts"]
        , button
            [ type' "button"
            , onClick (Score player 3)
            ]
            [ text "3 pts"]
        , div [] [ text (toString player.points) ]
        ]

pointTotal : Model -> Html Msg
pointTotal model =
    let
        total =
            List.map .points model.plays
            |> List.sum
    in
        footer []
            [ div [] [ text "Total: " ]
            , div [] [ text (toString total)]
            ]


playerForm : Model -> Html Msg
playerForm model =
    form [ onSubmit Save ]
        [ input
            [ type' "text"
            , placeholder "Add/Edit Player..."
            , onInput Input
            , value model.name
            ]
            []
        , button [ type' "submit" ] [ text "Save" ]
        , button [ type' "button", onClick Cancel ] [ text "Cancel" ]
        ]
