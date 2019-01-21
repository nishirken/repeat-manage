module Stripe exposing (..)

import Html.Styled exposing (..)
import Html.Styled.Events exposing (onClick)
import Html.Styled.Attributes exposing (attribute)
import Browser
import Styles

type alias Model =
  { speed : Int
  , symbols : List String
  }

main = Browser.sandbox
  { init = initialModel
  , update = update
  , view = toUnstyled << view
  }

initialModel = Model 0 []

update : () -> Model -> Model
update _ model = model

view : Model -> Html ()
view model =
  Styles.stripe [] (List.map (\s -> div [] [text s]) model.symbols)
