module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)

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
  ( initialModel, Cmd.none )

initialModel : Model
initialModel =
  { game_state = "playing"
  , current_player = "X"
  , board = [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]
  }


-- MODEL

type alias Model =
  { game_state : String
  , current_player : String
  , board : Board
  }

type alias Board =
  List Int


-- UPDATE

type Msg
  = NoOp

update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
  case message of
    NoOp ->
      ( model, Cmd.none )

-- VIEW

view : Model -> Browser.Document Msg
view model =
  { title = "Elm Tic Tic Toe"
  , body =
      [ div [ class "game" ]
        [ div [ class "board"] <| renderBoard model.board ]
      ]
  }

renderBoard : Board -> List (Html Msg)
renderBoard board =
  board
    |> List.map renderCell

renderCell : Int -> Html Msg
renderCell cell =
  div [ class "cell" ] [ text (String.fromInt cell) ]


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

