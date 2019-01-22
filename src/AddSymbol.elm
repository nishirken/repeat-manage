module AddSymbol exposing (..)

import Browser
import Html.Styled exposing (..)
import Html.Styled.Events exposing (onInput, onClick)
import Styles

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

view : Model -> Html Msg
view model =
  div [] [
    Styles.styledInput [onInput InputChanged] []
    , Styles.addButton [onClick (AddSymbol model.symbol)] [text "Add"]
  ]
