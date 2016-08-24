module Types exposing (..)
import Time exposing ( Time )
import Mouse

-- MyStuff

type alias Vec =
    ( Int, Int )

type alias Pill =
    { id : Int, pos : Vec, vel : Vec, radius : Int, time : Time }

type Msg
    = PositMsg Mouse.Position
    | Tick Time
    | StartTick Time
    | NoOp String
    -- Note that Tick is of type (Time -> Msg)
    -- PositMsg is of type (Mouse.Position -> Msg)


type alias Model =
    { pills : List Pill, elapsedTime : Float, startTime : Time }
