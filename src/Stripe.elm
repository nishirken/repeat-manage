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
import Random
import Array
import Const exposing (sliderSize)

type alias Model =
  { speed : Int
  , symbols : List String
  , viewSymbols : List String
  }

type Msg = RandomGenerated String | MakeRandom

main = Browser.element
  { init = init
  , update = update
  , view = toUnstyled << view
  , subscriptions = \_ -> Sub.none
  }

initialModel = Model 0 [] (List.map (\_ -> "") (List.range 0 (sliderSize - 1)))
initialCmd = delay 500 MakeRandom

init : () -> (Model, Cmd Msg)
init _ = (initialModel, initialCmd)

delay : Float -> Msg -> Cmd Msg
delay time msg =
  Task.perform (\_ -> msg) (Process.sleep time)

resetTemp : List String -> Model -> List String
resetTemp xs model = if List.length xs == 0 then model.symbols else xs

makeRandomSymbol : List String -> Cmd Msg
makeRandomSymbol originalSymbols =
  let maxIndex = (List.length originalSymbols) - 1
      arraySymbols = Array.fromList originalSymbols
      getByIndex i = case Array.get i arraySymbols of
        (Just x) -> RandomGenerated x
        Nothing -> RandomGenerated "" in
    Random.generate getByIndex (Random.int 0 maxIndex)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MakeRandom -> (model, makeRandomSymbol model.symbols)
    (RandomGenerated x) ->
      ({ model
      | viewSymbols = x :: (List.take (sliderSize - 1) model.viewSymbols)
      }, delay (toFloat model.speed) MakeRandom)

makeSymbol index s = (Styles.symbol index) [] [text s]

headWithDefault : List a -> a -> a
headWithDefault xs defaultValue =
  case List.head xs of
    (Just x) -> x
    Nothing -> defaultValue

view : Model -> Html Msg
view model =
  Styles.slider
    []
    [ (Styles.innerSlider model.speed)
        []
        ((List.indexedMap makeSymbol model.viewSymbols) ++ (List.indexedMap makeSymbol model.viewSymbols))
    , (Styles.centerBorder [] [])
    ]
