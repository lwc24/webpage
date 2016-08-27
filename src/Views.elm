module Views exposing (..)
--import Html exposing ( Html, form, div, button, h1, text, p, input, header, ul, li, i, footer)
--import Html.Events exposing ( onSubmit, onInput, onClick )
--import Html.Attributes exposing ( type', placeholder, value, class )
import Html exposing ( Html, div, p )
import Svg exposing ( svg, circle, text )
import Svg.Attributes exposing ( class, viewBox, width, cx, cy, r, fill  )

import Types exposing (..)


view : Model -> Html Msg
view model =
    div [ class "main" ]
        [ svg [ viewBox "0 0 400 400", width "400px" ]
            <| List.map
                (\pill ->
                    circle
                        [ cx <| toString <| fst pill.pos
                        , cy <| toString <| snd pill.pos
                        , r <| toString pill.radius
                        , fill <| pill.color
                        ]
                        []
                )
                model.pills
            ,   p [] [ text "Praise be to Keith"]
        ]
