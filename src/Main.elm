import Html exposing (..)
import Browser

type alias Model =
  { currentSymbol : String
  , symbols : List String
  }

type alias Msg =
  ChangeSymbol String
  | AddSymbol String
  | RemoveSymbol String

main = Browser.document
  { init = () -> (Model "" [], Cmd.none)
  , update = updatew
  , view = view
  , subscriptions = \_ -> Sub.none
  }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    (ChangeSymbol symbol) -> ({ model | currentSymbol = symbol }, Cmd.none)
    (AddSymbol symbol) -> ({ model | symbols = (List.append model.symbols [symbol]) })
    (Remove symbol) -> ({ model | symbols = ((List.reverse >> List.tail >> List.reverse) model.symbols) })

view : Model -> Browser.Document Msg
view model =
  { title = "Repeat"
  , body =
    [ div [] [text model.currentSymbol]
    , button [onClick (AddSymbol "2323")] [text "Add"]
    , button [onClick (RemoveSymbol "2323")] [text "Remove"]
    ]
  }
