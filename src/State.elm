module State exposing (..)
import Mouse
import Task exposing ( Task )
import Time exposing ( Time, every, now, millisecond )
import Platform.Cmd exposing ( Cmd )
import Types exposing (..)

vecAdd : Vec -> Vec -> Vec
vecAdd ( x1, y1 ) ( x2, y2 ) =
    ( x1 + x2, y1 + y2 )

vecMult : Float -> Vec -> Vec
vecMult scale ( x1, y1 ) =
    ( round( scale * toFloat x1 ), round(scale * toFloat y1) )

initialPill : Pill
initialPill =
    { id = 0
    , pos = ( 0, 0 ) -- note position is defined left,down
    , vel = ( 50, 50 )
    , radius = 15
    , color = "red"
    , time = 0.0
    }

initialModel : Model
initialModel =
    { pills =   [ { initialPill | id = 0, color = "blue"}
                , { initialPill | id = 1 }
                ]
    , elapsedTime = 0.0, startTime = 0.0
    }

-- Time.now : Task x Time
-- Task err ok
-- Task.perform : (x -> msg) -> (a -> msg) -> Task x a -> Cmd msg
-- Note the first two arguments are usually type constructors
getStartTime : Cmd Msg
getStartTime =
        Task.perform NoOp StartTick Time.now

init : ( Model, Cmd Msg )
init =
    ( initialModel, getStartTime )

stepPill : Model -> Pill -> Pill -- we pass model to have access to the time
stepPill mdl pill =
    let
        tstep = ( mdl.elapsedTime - pill.time )
        newPos = vecAdd pill.pos <| vecMult tstep pill.vel
    in
        if newPos /= pill.pos -- to deal with rounding
            then { pill | pos = newPos, time = mdl.elapsedTime }
        else
            pill

mousePill : Pill -> Vec -> Pill
mousePill pill pos =
    { pill | pos = pos }

relPos : Vec -> Vec -> Vec
relPos (ox, oy) (x, y) =
    (x - ox, y - oy)

movePlayer : Vec -> Model -> Model
movePlayer position model =
            let
                newPills = List.map
                    (\ pill ->
                        if pill.id == 0
                            then mousePill pill
                                <|relPos (110, 10) position
                        else
                            pill
                    )
                    model.pills
            in
                { model | pills = newPills }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PositMsg position ->
            ( movePlayer ( position.x,  position.y ) model, Cmd.none )
        Tick time ->
            ( { model | pills = List.map
                                (\ pill ->
                                    if pill.id /= 0 then (stepPill model) pill
                                    else pill
                                )
                                model.pills
                  , elapsedTime = (Time.inSeconds time) - (model.startTime) }
            , Cmd.none )

        StartTick time ->
            ( { model | startTime = Time.inSeconds time }
            , Cmd.none )

        _ -> ( model, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ Mouse.moves PositMsg, every (10*millisecond) Tick ]
