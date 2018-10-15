module Main exposing
    ( Model
    , Msg(..)
    , Player
    , gameDecoder
    , init
    , initialModel
    , main
    , playerDecoder
    , renderBoard
    , renderCell
    , subscriptions
    , update
    , view
    )

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode exposing (Decoder, field, int, list, oneOf, string)



-- MAIN


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- INIT


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, fetchGame )


initialModel : Model
initialModel =
    { player_x = Player "human" "x"
    , player_o = Player "human" "o"
    , game_state = "playing"
    , current_player = Player "human" "x"
    , board = []
    }



-- MODEL


gameDecoder : Decoder Model
gameDecoder =
    Decode.map5 Model
        (field "player_x" playerDecoder)
        (field "player_o" playerDecoder)
        (field "game_state" Decode.string)
        (field "current_player" playerDecoder)
        (field "board" (Decode.list string))


playerDecoder : Decoder Player
playerDecoder =
    Decode.map2 Player
        (field "type" Decode.string)
        (field "mark" Decode.string)


fetchGame : Cmd Msg
fetchGame =
    gameDecoder
        |> Http.get gameHost
        |> Http.send GameStateReceived


gameHost : String
gameHost =
    "http://localhost:4000/play/36093c34-d08b-11e8-a2c5-542696d2453b"


makeMove : String -> Cmd Msg
makeMove move =
    gameDecoder
        |> Http.get (gameHost ++ "/move/" ++ move)
        |> Http.send GameStateReceived


type alias Model =
    { player_x : Player
    , player_o : Player
    , game_state : String
    , current_player : Player
    , board : List String
    }


type alias Player =
    { tipe : String
    , mark : String
    }



-- UPDATE


type Msg
    = NoOp
    | GameStateReceived (Result Http.Error Model)
    | CellClicked String


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        GameStateReceived (Ok gameState) ->
            ( gameState, Cmd.none )

        GameStateReceived (Err err) ->
            let
                _ =
                    Debug.log "error " err
            in
            ( model, Cmd.none )

        CellClicked cell ->
            ( model, makeMove cell )

        NoOp ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Elm Tic Tic Toe"
    , body =
        [ div [ class "game" ]
            [ div [ class "board" ] <| renderBoard model.board ]
        ]
    }


renderBoard : List String -> List (Html Msg)
renderBoard board =
    board
        |> List.map renderCell


renderCell : String -> Html Msg
renderCell cell =
    div [ class "cell", onClick <| CellClicked cell ] [ text cell ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
