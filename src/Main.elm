import Html
import Html.Styled exposing (..)
import Html.Styled.Events exposing (..)
import Html.Styled.Attributes exposing (class, href, rel)
import Browser
import Stripe as S
import AddSymbol
import SymbolsList
import Styles

type alias Model =
  { stripeModel : S.Model
  , symbols : List String
  , addSymbolModel : AddSymbol.Model
  , symbolsListModel : SymbolsList.Model
  }

type Msg
  = StripeMsg ()
  | AddSymbolMsg AddSymbol.Msg
  | SymbolsListMsg SymbolsList.Msg

main = Browser.document
  { init = init
  , update = update
  , view = view
  , subscriptions = \_ -> Sub.none
  }

init : () -> (Model, Cmd Msg)
init _ = (
  { stripeModel = S.initialModel
  , symbols = []
  , addSymbolModel = AddSymbol.initialModel
  , symbolsListModel = SymbolsList.initialModel
  }, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  let { stripeModel, addSymbolModel, symbolsListModel, symbols } = model in
    case msg of
      (StripeMsg subMsg) -> let updatedModel = S.update subMsg stripeModel in
        ({ model | stripeModel = updatedModel }, Cmd.none)
      (AddSymbolMsg subMsg) -> let updatedModel = AddSymbol.update subMsg addSymbolModel in case subMsg of
        (AddSymbol.AddSymbol symbol) ->
          ({ model
          | symbols = List.append symbols [symbol]
          , addSymbolModel = updatedModel
          }, Cmd.none)
        (AddSymbol.InputChanged x) -> ({ model | addSymbolModel = updatedModel }, Cmd.none)
      (SymbolsListMsg subMsg) -> let updatedModel = SymbolsList.update subMsg symbolsListModel in case subMsg of
        (SymbolsList.DeleteSymbol symbol) ->
          ({ model
          | symbols = List.filter (\s -> s /= symbol) symbols
          , symbolsListModel = updatedModel
          }, Cmd.none)

view : Model -> Browser.Document Msg
view { stripeModel, addSymbolModel, symbols } =
  { title = "Repeat"
  , body = List.append (List.map Html.Styled.toUnstyled
    [ Styles.globalStyles
    , Styles.fonts
    , Html.Styled.map StripeMsg (S.view { stripeModel | symbols = symbols })
    , Styles.root [] [
        Html.Styled.map AddSymbolMsg (AddSymbol.view addSymbolModel)
      , Html.Styled.map SymbolsListMsg (SymbolsList.view { symbols = symbols })
    ]
    ]) [Styles.fonts]
  }
