module Types exposing (..)
import Time exposing ( Time )
import Mouse

-- MyStuff

type alias Id = Int

type alias StartPos = Int

type alias Vec =
    ( Int, Int )

type alias Pill =
    { id : Int,
    pos : Vec,
    vel : Vec,
    radius : Int,
    color: String,
    time : Time
    }

type Msg
    = PositMsg Mouse.Position
    | Tick Time
    | StartTick Time
    | Counter Time
    | AddPill StartPos
    | NoOp String
    | Collision Id
    -- Note that Tick is of type (Time -> Msg)
    -- PositMsg is of type (Mouse.Position -> Msg)


type alias Model =
    { pills : List Pill,
    elapsedTime : Float,
    startTime : Time,
    counter : Int,
    ran : Int
    }
