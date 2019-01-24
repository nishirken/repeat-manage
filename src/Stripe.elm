module Stripe exposing (..)

import Html.Styled exposing (..)
import Html.Styled.Events exposing (onClick)
import Html.Styled.Attributes exposing (attribute)
import Browser
import Styles

type alias Model =
  { speed : Int
  , symbols : List String
  , viewSymbols : List String
  }

type Msg = NextSymbol

main = Browser.element
  { init = init
  , update = update
  , view = toUnstyled << view
  , subscriptions = \_ -> Sub.none
  }

initialModel = Model 0 [] []

init : () -> (Model, Cmd Msg)
init _ = (initialModel, Cmd.none)

delay : Time.Time -> Msg -> Cmd Msg
delay time msg =
  Process.sleep time
  |> Task.perform (\_ -> msg)

endlessList : List String -> List String
endlessList symbols = case List.head symbols of
  (Just x) -> case List.tail symbols of
    (Just xs) -> List.append xs [x]
    Nothing -> symbols
  Nothing -> symbols

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  ({ model | viewSymbols = endlessList model.viewSymbols }, delay model.speed NextSymbol)

view : Model -> Html Msg
view model =
  Styles.stripe [] (List.map (\s -> div [] [text s]) model.symbols)
