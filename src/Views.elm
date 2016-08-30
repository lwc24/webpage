module Views exposing (..)
--import Html exposing ( Html, form, div, button, h1, text, p, input, header, ul, li, i, footer)
--import Html.Events exposing ( onSubmit, onInput, onClick )
--import Html.Attributes exposing ( type', placeholder, value, class )
import Html exposing ( Html, div, p, footer )
import String exposing ( append )
import Svg exposing ( svg, circle, text )
import Svg.Attributes exposing ( class, viewBox, width, cx, cy, r, fill  )

import Types exposing (..)


view : Model -> Html Msg
view model =
    if model.bStarted == True then
        div [ class "main" ]
            [ svg [ viewBox <| String.concat
                        [ String.append (toString (fst model.xlims)) " "
                        , String.append (toString (fst model.ylims)) " "
                        , String.append (toString (snd model.xlims)) " "
                        , String.append (toString (snd model.xlims)) " "
                        ]
                    , width <| String.append
                        (toString ((snd model.xlims)-(fst model.xlims)) ) "px"
                ]
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
            , p [] [text <| String.append "Score: " <| toString model.score ]
            , footer [] [text <| String.append "Level: " <| toString model.level ]
            ]
    else
        div [ class "main" ]
            [ svg [ viewBox "0 0 400 400", width "400px" ] []
            , p [] [ text <| String.append "Score: " <| toString model.score ]
            , footer [] [text <| "Click to begin"]
            ]
