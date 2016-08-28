module State exposing (..)
import Mouse
import Random exposing ( generate, int )
import Task exposing ( Task )
import Time exposing ( Time, every, now, millisecond, second )
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
vecMult scale ( x1, y1 ) =
    ( round( scale * toFloat x1 ), round(scale * toFloat y1) )

initialPill : Pill
initialPill =
    { id = 0
    , pos = ( 0, 0 ) -- note position is defined left,down
    , vel = ( 0, 50 )
    , radius = 15
    , color = "red"
    , time = 0.0
    }

initialModel : Model
initialModel =
    { pills =   [ { initialPill | id = 0, color = "blue"} ]
    , elapsedTime = 0.0, startTime = 0.0
    , counter = 0
    , ran = 0
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


mousePill : Pill -> Vec -> Pill
mousePill pill pos =
    { pill | pos = pos }

relPos : Vec -> Vec -> Vec
relPos (ox, oy) (x, y) =
    (x - ox, y - oy)
stepPill : Time -> Pill -> Pill -- we pass model to have access to the time
stepPill tstep pill =
    let
        newPos = vecAdd pill.pos <| vecMult (tstep*(pill.time*0.3)) pill.vel
    in
        if newPos /= pill.pos -- to deal with rounding
            then { pill | pos = newPos, time = pill.time + tstep }
        else
            pill

movePlayer : Vec -> Model -> Model
movePlayer position model =
            let
                movedPills = List.map
                    (\ pill ->
                        if pill.id == 0
                            then mousePill pill
                                <|relPos (110, 10) position
                        else
                            pill
                    )
                    model.pills
                playerPos = relPos (110, 10) position
                collPills = List.filter
                    (\ pill ->
                        if pill.id /= 0 &&
                            (vecDist pill.pos playerPos) < toFloat pill.radius*2
                            then False
                        else
                            True
                    )
                    movedPills
            in
                { model | pills = collPills }

movePills : Time -> Model -> Model
movePills time model =
    let
        movedPills = List.map
            (\ pill ->
                if pill.id /= 0 then
                     stepPill ( model.elapsedTime - pill.time ) pill
                else pill
            )
            model.pills
        filteredPills = List.filter
            (\ pill ->
                if ( snd pill.pos ) > 420  &&  pill.id /= 0  then False
                else True
            )
            movedPills
    in
        { model |
            pills = filteredPills
            , elapsedTime = (Time.inSeconds time) - (model.startTime)
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PositMsg position ->
            ( movePlayer ( position.x,  position.y ) model, Cmd.none )

        Tick time ->
            ( movePills time model, Cmd.none )

        StartTick time ->
            ( { model | startTime = Time.inSeconds time }
            , Cmd.none )

        Counter time ->
            ( { model | counter = model.counter + 1 }
                , generate AddPill (int 0 400)
            )

        AddPill result ->
            ( { model |
                    pills = (\ pills ->
                        List.append pills
                            <| [ { initialPill | id = (List.length pills)
                                , time = model.elapsedTime
                                , pos = ( result, 0 )
                                }
                            ]
                    )
                    model.pills
                , ran = result
                }
            , Cmd.none
            )

        _ -> ( model, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ Mouse.moves PositMsg,
        every (10*millisecond) Tick,
        every (second) Counter
    ]
