import Html
import Html.Styled exposing (..)
import Html.Styled.Events exposing (..)
import Html.Styled.Attributes exposing (class, href, rel)
import Browser
import Slider
import AddSymbol
import SymbolsList
import Styles
import ChangeSpeed
import LocalStorage
import Json.Encode as JE
import Utils exposing (..)

type alias Model =
  { sliderModel : Slider.Model
  , addSymbolModel : AddSymbol.Model
  , symbolsListModel : SymbolsList.Model
  , changeSpeedModel : ChangeSpeed.Model
  }

type Msg
  = SliderMsg Slider.Msg
  | AddSymbolMsg AddSymbol.Msg
  | SymbolsListMsg SymbolsList.Msg
  | ChangeSpeedMsg ChangeSpeed.Msg
  | LocalStorageMsg LocalStorage.Msg

main = Browser.document
  { init = init
  , update = update
  , view = view
  , subscriptions = \_ -> Sub.none
  }

type alias Flags =
  { storageState : String }

init : Flags -> (Model, Cmd Msg)
init { storageState } = let { speed, symbols } = (LocalStorage.decodeModel storageState) in (
  { sliderModel = let m = Slider.initialModel in { m | speed = speed, symbols = symbols }
  , addSymbolModel = AddSymbol.initialModel
  , symbolsListModel = let m = SymbolsList.initialModel in { m | symbols = symbols }
  , changeSpeedModel = let m = ChangeSpeed.initialModel in { m | speed = speed }
  }, Cmd.map SliderMsg Slider.initialCmd)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  let
    { sliderModel, addSymbolModel, symbolsListModel, changeSpeedModel } = model
    writeToLocalStorage speed symbols = LocalStorage.writeModel (LocalStorage.StoredModel speed symbols)
    in case msg of
      (SliderMsg subMsg) -> let (updatedModel, updatedCmd) = Slider.update subMsg sliderModel in
        ({ model | sliderModel = updatedModel }, Cmd.map SliderMsg updatedCmd)
      (AddSymbolMsg subMsg) -> let updatedModel = AddSymbol.update subMsg addSymbolModel in case subMsg of
        (AddSymbol.AddSymbol symbol) -> let newSymbols = symbolsListModel.symbols ++ [symbol] in
          ({ model
          | symbolsListModel = { symbols = newSymbols }
          , addSymbolModel = updatedModel
          , sliderModel = { sliderModel | symbols = newSymbols }
          }, writeToLocalStorage changeSpeedModel.speed newSymbols)
        (AddSymbol.InputChanged x) -> ({ model | addSymbolModel = updatedModel }, Cmd.none)
      (SymbolsListMsg subMsg) -> let updatedModel = SymbolsList.update subMsg symbolsListModel in case subMsg of
        (SymbolsList.DeleteSymbol symbol) ->
          ({ model
          | symbolsListModel = updatedModel
          , sliderModel =
            { sliderModel
            | symbols = updatedModel.symbols
            , viewSymbols = List.filter (\x -> x /= symbol) sliderModel.viewSymbols
            }
          }, writeToLocalStorage changeSpeedModel.speed updatedModel.symbols)
      (ChangeSpeedMsg subMsg) -> let updatedModel = ChangeSpeed.update subMsg changeSpeedModel in
        ({ model
        | changeSpeedModel = updatedModel
        , sliderModel = { sliderModel | speed = updatedModel.speed }
        }, writeToLocalStorage updatedModel.speed symbolsListModel.symbols)
      (LocalStorageMsg subMsg) -> case subMsg of
        (LocalStorage.Loaded { speed, symbols }) ->
          ({ model
          | changeSpeedModel = { changeSpeedModel | speed = speed }
          , sliderModel = { sliderModel | symbols = symbols }
          , symbolsListModel = { symbolsListModel | symbols = symbols }
          }, Cmd.none)

view : Model -> Browser.Document Msg
view { sliderModel, addSymbolModel, changeSpeedModel, symbolsListModel } =
  { title = "Repeat"
  , body = List.map Html.Styled.toUnstyled
    [ Styles.globalStyles
    , Styles.root []
      [ Html.Styled.map ChangeSpeedMsg (ChangeSpeed.view changeSpeedModel)
      , Html.Styled.map SliderMsg (Slider.view sliderModel)
      , Styles.asideList []
          [ Html.Styled.map AddSymbolMsg (AddSymbol.view addSymbolModel)
          , Html.Styled.map SymbolsListMsg (SymbolsList.view symbolsListModel)
          ]
      ]
    ]
  }
