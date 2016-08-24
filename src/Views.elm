module Views exposing (..)
--import Html exposing ( Html, form, div, button, h1, text, p, input, header, ul, li, i, footer)
--import Html.Events exposing ( onSubmit, onInput, onClick )
--import Html.Attributes exposing ( type', placeholder, value, class )
import Html exposing ( Html, div, p )
import Svg exposing (..)
import Svg.Attributes exposing (..)

import Types exposing (..)
import State exposing ( initialPill )


view : Model -> Html Msg
view model =
    let
        pill1 =
            Maybe.withDefault initialPill (List.head model.pills)

        pill2_ =
            Maybe.withDefault [ initialPill ] (List.tail model.pills)

        pill2 =
            Maybe.withDefault initialPill (List.head pill2_)

        ( pill1x, pill1y ) =
            pill1.pos

        ( pill2x, pill2y ) =
            pill2.pos
    in
        div [ class "main" ] [ svg [ viewBox "0 0 500 500", width "500px" ]
                [ circle
                    [ cx <| toString pill1x
                    , cy <| toString pill1y
                    , r
                        (toString
                            (pill1.radius)
                        )
                    , fill "blue"
                    ]
                    []
                , circle
                    [ cx <| toString pill2x
                    , cy <| toString pill2y
                    , r
                        (toString
                            (pill2.radius)
                        )
                    , fill "red"
                    ]
                    []
                ]
            ,   p [] [ text "Praise be to Keith"]
            ]
