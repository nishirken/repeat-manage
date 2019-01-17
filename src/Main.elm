import Html exposing (..)
import Html.Events exposing (..)
import Browser

type alias Model =
  { currentSymbol : String
  , symbols : List String
  }

type Msg
  = ChangeSymbol String
  | AddSymbol String
  | RemoveSymbol String

main = Browser.document
  { init = init
  , update = update
  , view = view
  , subscriptions = \_ -> Sub.none
  }

init : () -> (Model, Cmd Msg)
init _ = (Model "" [], Cmd.none)

pop : List a -> List a
pop xs = case (List.reverse >> List.tail) xs of
  (Just t) -> List.reverse t
  Nothing -> []

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    (ChangeSymbol symbol) -> ({ model | currentSymbol = symbol }, Cmd.none)
    (AddSymbol symbol) -> ({ model | symbols = (List.append model.symbols [symbol]) }, Cmd.none)
    (RemoveSymbol symbol) ->
      ({ model | symbols = pop model.symbols }, Cmd.none)

view : Model -> Browser.Document Msg
view model =
  { title = "Repeat"
  , body =
    [ div [] [text model.currentSymbol]
    , div [] (map model.symbols (\s -> div [] [text s]))
    , button [onClick (AddSymbol "2323")] [text "Add"]
    , button [onClick (RemoveSymbol "2323")] [text "Remove"]
    ]
  }
