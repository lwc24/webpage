module Main exposing (..)

import Html exposing (Html, div, button, text)
import Html.App
import Mouse
import Time exposing (Time, now)
import Svg exposing (..)
import Svg.Attributes exposing (..)


-- MyStuff


type alias Vec =
    ( Int, Int )


vecAdd : Vec -> Vec -> Vec
vecAdd ( x1, y1 ) ( x2, y2 ) =
    ( x1 + x2, y1 + y2 )


type alias Pill =
    { pos : Vec, vel : Vec, radius : Int }


initialPill : Pill
initialPill =
    { pos = ( 0, 0 )
    , vel = ( 0, 0 )
    , radius = 15
    }



-- Model and Msg


type Msg
    = PositMsg Mouse.Position


type alias Model =
    { pills : List Pill, time : Time }


initialModel =
    { pills = [ initialPill, initialPill ], time = now }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )



-- VIEW


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
        svg [ viewBox "0 0 500 500", width "500px" ]
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



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PositMsg position ->
            let
                pill =
                    Maybe.withDefault initialPill (List.head model.pills)

                newmodel =
                    { model
                        | pills =
                            [ { pill
                                | pos =
                                    ( position.x
                                    , position.y
                                    )
                              }
                            ]
                    }
            in
                ( newmodel, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ Mouse.moves PositMsg ]



-- MAIN


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
