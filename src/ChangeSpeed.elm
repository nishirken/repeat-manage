module ChangeSpeed exposing (..)

import Browser
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (type_)
import Html.Styled.Events exposing (onInput)

main = Browser.sandbox
  { init = initialModel
  , update = update
  , view = toUnstyled << view
  }

type alias Model =
  { speed : Int }

type Msg = Change Int

initialModel = Model 0

update : Msg -> Model -> Model
update msg model =
  case msg of
    (Change x) -> { speed = x }

onInputChange : String -> Int -> Msg
onInputChange value currentValue = let intVal = String.toInt value in
  case intVal of
    (Just x) -> Change x
    Nothing -> Change currentValue

view : Model -> Html Msg
view model =
  div [] [
    input [type_ "number", (onInput (\x -> onInputChange x model.speed))] []
    , div [] [(String.fromInt >> text) model.speed]
  ]
