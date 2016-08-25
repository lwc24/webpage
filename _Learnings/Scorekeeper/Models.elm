module Models exposing (..)

type Msg
    = Edit Player
    | Score Player Int
    | Input String
    | Save
    | Cancel
    | DeletePlay Play

type alias Id = Int

type alias Player =
    { id : Id
    , name : String
    , points : Int
    }

type alias Play =
    { id : Id
    , playerId : Id
    , name : String
    , points : Int
    }

type alias Model =
    { players : List Player
    , name : String
    , playerId : Maybe Id
    , plays : List Play
    }

initModel : Model
initModel =
    { players = []
    , name = ""
    , playerId = Nothing
    , plays = []
    }


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )
