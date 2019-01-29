module Stripe exposing (..)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Events exposing (onClick)
import Html.Styled.Attributes exposing (attribute, css)
import Browser
import Styles
import Process
import Task
import List exposing (take, append)

type alias Model =
  { speed : Int
  , symbols : List String
  , tempSymbols : List String
  , viewSymbols : List String
  }

type Msg = NextSymbol

main = Browser.element
  { init = init
  , update = update
  , view = toUnstyled << view
  , subscriptions = \_ -> Sub.none
  }

initialModel = Model 0 [] [] []

init : () -> (Model, Cmd Msg)
init _ = (initialModel, delay 2000 NextSymbol)

delay : Float -> Msg -> Cmd Msg
delay time msg =
  Task.perform (\_ -> msg) (Process.sleep time)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  ({ model
  | viewSymbols = append (take 1 model.symbols) model.viewSymbols
  }, delay (toFloat model.speed) NextSymbol)

view : Model -> Html Msg
view model =
  Styles.stripe
    [ css
      [ transform (translateX (px 50))]
    ]
    (List.append (List.map (\s -> div [] [text s]) model.viewSymbols) [button [onClick NextSymbol] [text "start"]])
