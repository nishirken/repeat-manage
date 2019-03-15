module ChangeSpeed exposing (..)

import Browser
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (type_, value)
import Html.Styled.Events exposing (onInput, onBlur)
import Styles
import Common

main = Browser.sandbox
  { init = initialModel
  , update = update
  , view = toUnstyled << view
  }

type alias Model =
  { speed : Int }

type Msg = Change Int | Blur

defaultSpeed = 3000
initialModel = Model defaultSpeed

outMsg : Msg -> Model -> Common.GlobalMsg
outMsg msg model =
  case msg of
    Blur -> Common.ChangeSpeed model.speed
    _ -> Common.None

update : Msg -> Model -> Model
update msg model =
  case msg of
    (Change x) -> { speed = x }
    _ -> model

onInputChange : String -> Int -> Msg
onInputChange value currentValue = let intVal = String.toInt value in
  case intVal of
    (Just x) -> Change x
    Nothing -> Change currentValue

view : Model -> Html Msg
view model =
  div [] [
    Styles.speedInput
      [ type_ "text"
      , (onInput (\x -> onInputChange x model.speed))
      , (onBlur Blur)
      , value (String.fromInt model.speed)
      ]
      []
  ]
