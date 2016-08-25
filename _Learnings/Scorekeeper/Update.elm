module Update exposing (..)

import String
import Models exposing ( Id, Player, Play, Model, Msg(..) )

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Input strname ->
            ( { model | name = strname }, Cmd.none )

        Cancel ->
            ( { model | name = "", playerId = Nothing }, Cmd.none )

        Save ->
            if String.isEmpty <| toString model.name then
                ( model, Cmd.none )
            else
                ( save model, Cmd.none )

        Score player points ->
            ( score model player points, Cmd.none )

        Edit player ->
            ( {model | name = player.name, playerId = Just player.id }, Cmd.none )

        _ ->
            ( model, Cmd.none )

score : Model -> Player -> Int -> Model
score model scoredPlayer points =
    let
        newPlayers =
            List.map
                (\player ->
                    if player.id == scoredPlayer.id then
                        { player | points = player.points + points}
                    else
                        player
                )
                model.players

        newPlay =
            Play (List.length model.plays) scoredPlayer.id scoredPlayer.name points

        newPlays =
            newPlay :: model.plays

    in
        { model | plays = newPlays, players = newPlayers }


save : Model -> Model
save model =
    case model.playerId of
        Nothing -> -- insert mode
            add model
        Just id -> -- edit mode
            edit model id

add : Model -> Model
add model =
    let
        player = Player (List.length model.players) model.name 0
        newPlayers =
            player :: model.players
    in
        { model | players = newPlayers, name = "" }


edit : Model -> Id -> Model
edit model id =
    let
        newPlayers =
            List.map
                (\player ->
                    if player.id == id then
                        { player | name = model.name }
                    else
                        player
                )
                model.players
        newPlays =
            List.map
                (\play ->
                    if play.playerId == id then
                        { play | name = model.name }
                    else
                        play
                )
                model.plays
    in
        { model
            | players = newPlayers,
            plays = newPlays, name = "", playerId = Nothing
        }
