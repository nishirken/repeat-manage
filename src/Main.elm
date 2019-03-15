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
import Common exposing (GlobalMsg (..), StoredModel)

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

updateInnerMsg : Msg -> Model -> (Model, Cmd Msg)
updateInnerMsg msg model =
  let
    { sliderModel, addSymbolModel, symbolsListModel, changeSpeedModel } = model in
    case msg of
      (SliderMsg subMsg) ->
        let (updatedModel, updatedCmd) = Slider.update subMsg sliderModel in
          ({ model | sliderModel = updatedModel }, Cmd.map SliderMsg updatedCmd)
      (AddSymbolMsg subMsg) ->
        let updatedModel = AddSymbol.update subMsg addSymbolModel in
          ({ model | addSymbolModel = updatedModel }, Cmd.none)
      (SymbolsListMsg subMsg) ->
        let updatedModel = SymbolsList.update subMsg symbolsListModel in
          ({ model | symbolsListModel = updatedModel }, Cmd.none)
      (ChangeSpeedMsg subMsg) ->
        let updatedModel = ChangeSpeed.update subMsg changeSpeedModel in
          ({ model | changeSpeedModel = updatedModel }, Cmd.none)

updateOutModel : GlobalMsg -> Model -> Model
updateOutModel globalMsg model =
  { model
  | sliderModel = Slider.updateOutMsg globalMsg model.sliderModel
  , symbolsListModel = SymbolsList.updateOutMsg globalMsg model.symbolsListModel
  }

updateOutCmd : GlobalMsg -> Model -> Cmd Msg
updateOutCmd msg { sliderModel, symbolsListModel, changeSpeedModel } =
  let writeToLocalStorage = LocalStorage.writeModel (StoredModel changeSpeedModel.speed symbolsListModel.symbols) in
    case msg of
      (AddSymbol _) -> writeToLocalStorage
      (DeleteSymbol x) -> Cmd.batch [writeToLocalStorage, Cmd.map SliderMsg (Slider.updateOutCmd (DeleteSymbol x) sliderModel)]
      (ChangeSpeed _) -> writeToLocalStorage
      _ -> Cmd.none

updateOutMsg : Msg -> Model -> (Model, Cmd Msg)
updateOutMsg msg model =
  case msg of
    (SymbolsListMsg subMsg) ->
      let
        msg_ = SymbolsList.outMsg subMsg
        model_ = updateOutModel msg_ model in
      (model_, updateOutCmd msg_ model_)
    (AddSymbolMsg subMsg) ->
      let
        msg_ = AddSymbol.outMsg subMsg
        model_ = updateOutModel msg_ model in
      (model_, updateOutCmd msg_ model_)
    (ChangeSpeedMsg subMsg) ->
      let
        msg_ = ChangeSpeed.outMsg subMsg model.changeSpeedModel
        model_ = updateOutModel msg_ model in
      (model_, updateOutCmd msg_ model_)
    _ -> (model, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  let
    (innerModel, innerCmd) = updateInnerMsg msg model
    (outModel, outCmd) = updateOutMsg msg innerModel in
      (outModel, Cmd.batch [outCmd, innerCmd])

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
