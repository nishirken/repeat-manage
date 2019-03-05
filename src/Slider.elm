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
import Common exposing (GlobalMsg (..), sliderSize)
import DOM

type alias Model =
  { speed : Int
  , symbols : List String
  , viewSymbols : List String
  , randomSymbol : String
  }

type Msg
  = RandomGenerated String
  | FullListGenerated (List String)
  | PartOfListGenerated (List String)
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

initialModel = Model 0 [] (List.map (\_ -> "") (List.range 0 (sliderSize - 1))) ""
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

makeRandomSymbol : List String -> Cmd Msg
makeRandomSymbol originalSymbols =
  Random.generate (\i -> RandomGenerated (fromIndex originalSymbols i)) (randomIndex originalSymbols)

makeRandomList : List String -> ((List String) -> Msg) -> Int -> Cmd Msg
makeRandomList originalSymbols msg howMuch =
  let generatedList = Random.list howMuch (randomIndex originalSymbols) in
    Random.generate
      (\xs -> msg (List.map (\index -> fromIndex originalSymbols index) xs))
      generatedList

updateOutMsg : GlobalMsg -> Model -> Model
updateOutMsg globalMsg model = case globalMsg of
  (DeleteSymbol x) -> let clearList = List.filter (\s -> s /= x) in
    { model
    | symbols = clearList model.symbols
    , viewSymbols = clearList model.viewSymbols
    }
  (AddSymbol x) ->
    { model
    | symbols = x :: model.symbols
    }
  (ChangeSpeed x) -> { model | speed = x }
  _ -> model

updateOutCmd : GlobalMsg -> Model -> Cmd Msg
updateOutCmd msg model =
  case msg of
    (DeleteSymbol x) -> makeRandomList model.symbols PartOfListGenerated (sliderSize - (List.length model.viewSymbols))
    _ -> Cmd.none

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = let delayRandomCmd = delay (toFloat model.speed) MakeRandom in
  case msg of
    MakeInitialList -> (model, Cmd.batch [makeRandomList model.symbols FullListGenerated sliderSize])
    MakeRandom -> (model, makeRandomSymbol model.symbols)
    (RandomGenerated x) ->
      ({ model | viewSymbols = x :: (List.take ((List.length model.viewSymbols) - 1) model.viewSymbols) }
      , delayRandomCmd)
    (FullListGenerated xs) -> ({ model | viewSymbols = xs }, delayRandomCmd)
    (PartOfListGenerated xs) -> ({ model | viewSymbols = xs ++ model.viewSymbols }, delayRandomCmd)

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
