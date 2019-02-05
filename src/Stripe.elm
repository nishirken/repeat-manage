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

type Msg = NextSymbol

main = Browser.element
  { init = init
  , update = update
  , view = toUnstyled << view
  , subscriptions = \_ -> Sub.none
  }

initialModel = Model 0 [] [] ["", "", "", "", "", ""]
initialCmd = delay 500 NextSymbol

init : () -> (Model, Cmd Msg)
init _ = (initialModel, initialCmd)

delay : Float -> Msg -> Cmd Msg
delay time msg =
  Task.perform (\_ -> msg) (Process.sleep time)

infiniteSymbols : List String -> (String, List String)
infiniteSymbols xs = let rest = List.drop 1 xs in
  case List.head xs of
    (Just x) -> (x, rest)
    Nothing -> ("", rest)

resetTemp : List String -> Model -> List String
resetTemp xs model = if List.length xs == 0 then model.symbols else xs

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NextSymbol -> let (x, rest) = infiniteSymbols model.tempSymbols in
      ({ model
       | viewSymbols = x :: (take (Styles.stripeSize - 1) model.viewSymbols)
       , tempSymbols = resetTemp rest model
       }, delay (toFloat model.speed) NextSymbol)
 
makeSymbol speed index s = (Styles.symbol index speed) [] [text s]
headWithDefault : List a -> a -> a
headWithDefault xs defaultValue =
  case head xs of
    (Just x) -> x
    Nothing -> defaultValue

view : Model -> Html Msg
view model = let hiddenStub = makeSymbol model.speed 0 (headWithDefault model.viewSymbols "") in
  Styles.stripe
    []
    ((Styles.centerBorder [] [])
    :: [hiddenStub]
    ++ (List.indexedMap (makeSymbol model.speed) model.viewSymbols)
    ++ [hiddenStub])
