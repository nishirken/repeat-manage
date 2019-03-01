module Slider exposing (..)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Events exposing (onClick)
import Html.Styled.Attributes exposing (attribute, css, id)
import Browser
import Styles
import Process
import Task
import List exposing (take, reverse, head)
import Random
import Array
import Const exposing (sliderSize)
import Utils
import DOM

type alias Model =
  { speed : Int
  , symbols : List String
  , viewSymbols : List String
  , randomSymbol : String
  }

type Msg
  = RandomGenerated String
  | InitialRandomListGenerated (List String)
  | MakeRandom
  | MakeInitialList

main = Browser.element
  { init = init
  , update = update
  , view = toUnstyled << view
  , subscriptions = \_ -> Sub.none
  }

type alias SliderMsg =
  { id : String
  , speed : Int
  , randomSymbol : String
  }

innerSliderId = "slider"

initialModel = Model 0 [] (List.map (\_ -> "") (List.range 0 ((sliderSize * 2) - 1))) ""
initialCmd = delay 500 MakeInitialList

init : () -> (Model, Cmd Msg)
init _ = (initialModel, initialCmd)

delay : Float -> Msg -> Cmd Msg
delay time msg =
  Task.perform (\_ -> msg) (Process.sleep time)

resetTemp : List String -> Model -> List String
resetTemp xs model = if List.length xs == 0 then model.symbols else xs

ranges : List a -> (Int, Int)
ranges xs = (0, (List.length xs) - 1)

fromIndex : List String -> Int -> String
fromIndex xs i = case Array.get i (Array.fromList xs) of
  (Just x) -> x
  Nothing -> ""

randomIndex : List a -> Random.Generator Int
randomIndex xs = let (fst, snd) = ranges xs in Random.int fst snd

makeRandomSymbol : List String -> Int -> Cmd Msg
makeRandomSymbol originalSymbols speed =
  if List.length originalSymbols < sliderSize
    then delay 0 MakeInitialList
    else Random.generate (\i -> RandomGenerated (fromIndex originalSymbols i)) (randomIndex originalSymbols)

makeInitialRandomList : List String -> Int -> Cmd Msg
makeInitialRandomList originalSymbols speed =
  let (fst, snd) = ranges originalSymbols in
    if List.length originalSymbols == 0
      then delay (toFloat speed) MakeInitialList
      else let generatedList = Random.list sliderSize (randomIndex originalSymbols) in
        Random.generate
          (\xs -> InitialRandomListGenerated (List.map (\index -> fromIndex originalSymbols index) xs))
          generatedList

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MakeInitialList -> (model, makeInitialRandomList model.symbols model.speed)
    MakeRandom -> (model, makeRandomSymbol model.symbols model.speed)
    (RandomGenerated x) ->
      ({ model | viewSymbols = x :: (List.take ((List.length model.viewSymbols) - 1) model.viewSymbols) }
      , delay (toFloat model.speed) MakeRandom)
    (InitialRandomListGenerated xs) -> ({ model | viewSymbols = xs }, delay (toFloat model.speed) MakeRandom)

makeSymbol : Int -> String -> Html msg
makeSymbol index s = Styles.symbol index [] [text s]

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
        [id innerSliderId]
        (List.indexedMap makeSymbol model.viewSymbols)
    , (Styles.centerBorder [] [])
    ]
