module SymbolsList exposing (..)

import Browser
import Html exposing (..)
import Html.Events exposing (onClick)

main = Browser.sandbox
  { init = initialModel
  , update = update
  , view = view
  }

type alias Model = { symbols : List String }

type Msg = DeleteSymbol String

initialModel = Model []

update : Msg -> Model -> Model
update _ model = model

symbolView : String -> Html Msg
symbolView symbol =
  li [] [
    text symbol
    , button [onClick (DeleteSymbol symbol)] [text "delete"]
  ]

view : Model -> Html Msg
view { symbols } =
  ul [] (List.map symbolView symbols)
