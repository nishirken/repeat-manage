module SymbolsList exposing (..)

import Browser
import Html.Styled exposing (..)
import Html.Styled.Events exposing (onClick)
import Styles

main = Browser.sandbox
  { init = initialModel
  , update = update
  , view = toUnstyled << view
  }

type alias Model = { symbols : List String }

type Msg = DeleteSymbol String

initialModel = Model []

update : Msg -> Model -> Model
update msg model = case msg of
  (DeleteSymbol symbol) -> { symbols = List.filter (\s -> s /= symbol) model.symbols }

symbolView : String -> Html Msg
symbolView symbol =
  Styles.listItemWrapper [] [
    text symbol
    , Styles.styledButton [onClick (DeleteSymbol symbol)] [text "delete"]
  ]

view : Model -> Html Msg
view { symbols } =
  div [] (List.map symbolView symbols)
