module Main exposing (..)

import Html.App
import Views exposing (view)
import State exposing (init, update,subscriptions)

main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
