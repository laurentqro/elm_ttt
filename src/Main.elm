module Main exposing (..)

import Browser
import Html

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
  , board : List Int
  }


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
  , body = [ Html.div [] [ Html.text "Hello, world" ] ]
  }


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

