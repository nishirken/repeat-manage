module Common exposing (..)

sliderSize = 5

withLog : a -> a
withLog x = Debug.log (Debug.toString x) x

type alias StoredModel =
  { speed : Int
  , symbols : List String
  }

type GlobalMsg
  = AddSymbol String
  | DeleteSymbol String
  | ChangeSpeed Int
  | LocalStorageLoaded StoredModel
  | None
