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

type Msg = NextSymbol String

main = Browser.element
  { init = init
  , update = update
  , view = toUnstyled << view
  , subscriptions = \_ -> Sub.none
  }

initialModel = Model 0 []

init : () -> (Model, Cmd Msg)
init _ = (initialModel, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update _ model = (model, Cmd.none)

view : Model -> Html Msg
view model =
  Styles.stripe [] (List.map (\s -> div [] [text s]) model.symbols)
