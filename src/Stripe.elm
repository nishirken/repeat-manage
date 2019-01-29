module Stripe exposing (..)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Events exposing (onClick)
import Html.Styled.Attributes exposing (attribute, css)
import Browser
import Styles
import Process
import Task
import List exposing (take, reverse, head)
import Time

type alias Model =
  { speed : Int
  , symbols : List String
  , tempSymbols : List String
  , viewSymbols : List String
  }

type Msg = NextSymbol String

main = Browser.element
  { init = init
  , update = update
  , view = toUnstyled << view
  , subscriptions = subscriptions
  }

initialModel = Model 0 [] [] []

init : () -> (Model, Cmd Msg)
init _ = (initialModel, Cmd.none)

subscriptions model = case (reverse >> head) model.symbols of
  (Just x) -> Time.every 1000 (\_ -> NextSymbol x)
  Nothing -> Sub.none

delay : Float -> Msg -> Cmd Msg
delay time msg =
  Task.perform (\_ -> msg) (Process.sleep time)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    (NextSymbol x) ->
      ({ model
      | viewSymbols = x :: model.viewSymbols
      }, Cmd.none)

view : Model -> Html Msg
view model =
  Styles.stripe
    [ css
      [ transform (translateX (px 50)) ]
    ]
    ((List.map (\s -> div [] [text s]) model.viewSymbols) ++ [button [] [text "start"]])
