import Html
import Html.Styled exposing (..)
import Html.Styled.Events exposing (..)
import Html.Styled.Attributes exposing (class, href, rel)
import Browser
import Stripe
import AddSymbol
import SymbolsList
import Styles
import ChangeSpeed

type alias Model =
  { stripeModel : Stripe.Model
  , addSymbolModel : AddSymbol.Model
  , symbolsListModel : SymbolsList.Model
  , changeSpeedModel : ChangeSpeed.Model
  }

type Msg
  = StripeMsg Stripe.Msg
  | AddSymbolMsg AddSymbol.Msg
  | SymbolsListMsg SymbolsList.Msg
  | ChangeSpeedMsg ChangeSpeed.Msg

main = Browser.document
  { init = init
  , update = update
  , view = view
  , subscriptions = \_ -> Sub.none
  }

init : () -> (Model, Cmd Msg)
init _ = (
  { stripeModel = Stripe.initialModel
  , addSymbolModel = AddSymbol.initialModel
  , symbolsListModel = SymbolsList.initialModel
  , changeSpeedModel = ChangeSpeed.initialModel
  }, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  let { stripeModel, addSymbolModel, symbolsListModel, changeSpeedModel } = model in
    case msg of
      (StripeMsg subMsg) -> let (updatedModel, _) = Stripe.update subMsg stripeModel in
        ({ model | stripeModel = updatedModel }, Cmd.none)
      (AddSymbolMsg subMsg) -> let updatedModel = AddSymbol.update subMsg addSymbolModel in case subMsg of
        (AddSymbol.AddSymbol symbol) ->
          ({ model
          | symbolsListModel = { symbols = List.append symbolsListModel.symbols [symbol] }
          , addSymbolModel = updatedModel
          }, Cmd.none)
        (AddSymbol.InputChanged x) -> ({ model | addSymbolModel = updatedModel }, Cmd.none)
      (SymbolsListMsg subMsg) -> let updatedModel = SymbolsList.update subMsg symbolsListModel in case subMsg of
        (SymbolsList.DeleteSymbol symbol) ->
          ({ model | symbolsListModel = updatedModel }, Cmd.none)
      (ChangeSpeedMsg subMsg) -> let updatedModel = ChangeSpeed.update subMsg changeSpeedModel in
        ({ model | changeSpeedModel = updatedModel }, Cmd.none)

view : Model -> Browser.Document Msg
view { stripeModel, addSymbolModel, changeSpeedModel, symbolsListModel } =
  { title = "Repeat"
  , body = List.map Html.Styled.toUnstyled
    [ Styles.globalStyles
    , Styles.root []
      [ Html.Styled.map ChangeSpeedMsg (ChangeSpeed.view changeSpeedModel)
      , Html.Styled.map StripeMsg (Stripe.view { stripeModel | symbols = symbolsListModel.symbols })
      , Styles.bottomSection []
        [ Styles.asideList []
          [ Html.Styled.map AddSymbolMsg (AddSymbol.view addSymbolModel)
          , Html.Styled.map SymbolsListMsg (SymbolsList.view symbolsListModel)
          ]
        ]
      ]
    ]
  }
