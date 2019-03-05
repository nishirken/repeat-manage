module AddSymbol exposing (..)

import Browser
import Html.Styled exposing (..)
import Html.Styled.Events exposing (onInput, onClick)
import Styles
import Common

main = Browser.sandbox
  { init = initialModel
  , update = update
  , view = toUnstyled << view
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

outMsg : Msg -> Common.GlobalMsg
outMsg msg =
  case msg of
    (AddSymbol x) -> Common.AddSymbol x
    _ -> Common.None

view : Model -> Html Msg
view model =
  Styles.buttonWrapper [] [
    Styles.styledInput [onInput InputChanged] []
    , Styles.styledButton [onClick (AddSymbol model.symbol)] [text "Add"]
  ]
