module Stripe exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (attribute)
import Browser

type alias Model =
  { speed : Int
  , symbols : List String
  }

main = Browser.sandbox
  { init = initialModel
  , update = update
  , view = view
  }

initialModel = Model 0 []

update : () -> Model -> Model
update _ model = model

view : Model -> Html ()
view model =
  div [] (List.map (\s -> div [] [text s]) model.symbols)
