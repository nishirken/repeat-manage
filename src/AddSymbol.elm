module AddSymbol exposing (..)

import Browser
import Html exposing (..)
import Html.Events exposing (onInput, onClick)

main = Browser.sandbox
  { init = initialModel
  , update = update
  , view = view
  }

initialModel = Model ""

type alias Model = { symbol: String }

type Msg
  = AddSymbol String
  | InputChanged String

update : Msg -> Model -> Model
update msg model =
  case msg of
    (InputChanged x) -> { symbol = x }
    (AddSymbol _) -> model

view : Model -> Html Msg
view model =
  div [] [
    input [onInput InputChanged] []
    , button [onClick (AddSymbol model.symbol)] [text "Add"]
  ]
