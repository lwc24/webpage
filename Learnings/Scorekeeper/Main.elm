module Main exposing (..)
import Html.App
import Views exposing ( view )
import Update exposing ( update, subscriptions )
import Models exposing ( Model, init )


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
