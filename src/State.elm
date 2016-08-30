module State exposing (..)
import Mouse
import Random exposing ( generate, int )
import Task exposing ( Task )
import Time exposing ( Time, every, now, millisecond )
import Platform.Cmd exposing ( Cmd )
import Types exposing (..)

vecAdd : Vec -> Vec -> Vec
vecAdd ( x1, y1 ) ( x2, y2 ) =
    ( x1 + x2, y1 + y2 )

vecDist : Vec -> Vec -> Float
vecDist ( x1i, y1i ) ( x2i, y2i ) =
    let
        x1 = toFloat x1i
        x2 = toFloat x2i
        y1 = toFloat y1i
        y2 = toFloat y2i
    in  sqrt ( (x1-x2)*(x1-x2) + (y1-y2)*(y1-y2) )

vecMult : Float -> Vec -> Vec
vecMult scalar ( x1, y1 ) =
    ( round( scalar * toFloat x1 ), round(scalar * toFloat y1) )

initialPill : Pill
initialPill =
    { id = 0
    , pos = ( 0, 0 ) -- note position is defined left,down
    , vel = ( 0, 50 )
    , radius = 15
    , color = "red"
    , modTime = 0.0
    , aliveTime = 0.0
    , birthTime = 0.0
    }

initialModel : Model
initialModel =
    { bStarted = False
    , elapsedTime = 0.0
    , startTime = 0.0
    , counter = 0
    , level = 1
    , score = 0
    , xlims = (0, 400)
    , ylims = (0, 400)
    , pills =  [ { initialPill | id = 0, color = "blue"} ]
    }

-- Time.now : Task x Time
-- Task err ok
-- Task.perform : (x -> msg) -> (a -> msg) -> Task x a -> Cmd msg
-- Note the first two arguments are usually type constructors


relPos : Vec -> Vec -> Vec
relPos (ox, oy) (x, y) =
    (x - ox, y - oy)

movePlayer : Vec -> Model -> Model
movePlayer position model =
            let
                mousePos = relPos (110, 10) position
                movedPills = List.map
                    (\ pill ->
                        if pill.id == 0 then
                            { pill | pos = mousePos }
                        else pill
                    )
                    model.pills
            in
                { model | pills = movedPills }

stepPill : Time -> Pill -> Pill -- we pass model to have access to the time
stepPill tstep pill =
    let
        newPos = vecAdd pill.pos
            <| vecMult tstep
            <| vecMult ( 5.5 - 1.0*pill.aliveTime ) pill.vel
    in
        if newPos /= pill.pos -- to deal with rounding
            then { pill | pos = newPos
                , modTime = pill.modTime + tstep
                , aliveTime = pill.modTime + tstep - pill.birthTime
            }
        else pill

stepGame : Time -> Model -> ( Model, Cmd Msg )
stepGame time model =
    let
        player = Maybe.withDefault initialPill <| List.head model.pills
        playPos = player.pos
        collPills = List.filter
            (\ pill ->
                if pill.id /= 0 &&
                    (vecDist pill.pos playPos) < toFloat pill.radius*2
                    then False
                else
                    True
            )
            model.pills
        newScore =
            if collPills /= model.pills then model.score + 1
            else model.score
        movedPills = List.map
            (\ pill ->
                if pill.id /= 0 then
                     stepPill ( model.elapsedTime - pill.modTime ) pill
                else pill
            )
            collPills
        filteredPills = List.filter
            (\ pill ->
                if ( snd pill.pos ) > 420  &&  pill.id /= 0  then False
                else True
            )
            movedPills
        command =
            if filteredPills /= movedPills then
                Task.perform NoOp EndGame ( Task.succeed "Game Ended" )
                -- Task.perform (x -> msg) (a -> msg) Task.Task x a
                --Task.succeed a -> Task.Task x a
            else Cmd.none
    in
        (
            { model |
                pills = filteredPills
                , elapsedTime = (Time.inSeconds time) - (model.startTime)
                , score = newScore
            }
        , command
        )

countGame : Time -> Model -> (Model, Cmd Msg)
countGame time model =
    let
        command =
            if model.counter /= 0 && model.counter % (10 - model.level) == 0
                then generate AddPill
                    <| Random.int (fst model.xlims) (snd model.xlims)
            else Cmd.none
        newLevel =
            if model.counter /= 0 &&
                (model.counter % (20*model.level + 20) ) == 0 &&
                model.level < 9
                    then (model.level + 1)
            else model.level
        newCounter =
            if model.level /= newLevel then 0
            else model.counter + 1
    in
        ( { model
            | counter = newCounter
            , level = newLevel
            }
        , command
        )

-- REQUIRED APP FUNCTIONS

init : ( Model, Cmd Msg )
init = ( initialModel, Task.perform NoOp StartTick Time.now )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StartTick time ->
            ( initialModel, Cmd.none )

        StartClick pos ->
            ( { initialModel | bStarted = True, score = 0 }, Cmd.none )

        EndGame text ->
            ( { initialModel | score = model.score }, Cmd.none )

        PositMsg position ->
            ( movePlayer ( position.x,  position.y ) model, Cmd.none )

        Tick time ->
            stepGame time model

        Counter time ->
            countGame time model

        AddPill ranNum ->
            ( { model |
                    pills = (\ pills ->
                        List.append pills
                            <| [ { initialPill | id = (List.length pills)
                                , birthTime = model.elapsedTime
                                , modTime = model.elapsedTime
                                , pos = ( ranNum, 0 )
                                }
                            ]
                    )
                    model.pills
                }
            , Cmd.none
            )


        _ -> ( model, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
    if model.bStarted == False then
        Sub.batch [ Mouse.clicks StartClick ]
    else
        Sub.batch [ Mouse.moves PositMsg,
            every (20*millisecond) Tick,
            every (100*millisecond) Counter
        ]
