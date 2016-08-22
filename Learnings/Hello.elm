module Hello exposing (..)

import Html exposing (text)

add : Int -> Int -> Int
add x y =
  x + y

main =
    text "Hello"
    result = add 1 2
    text result
