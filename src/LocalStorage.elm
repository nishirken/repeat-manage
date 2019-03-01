port module LocalStorage exposing (..)

import ChangeSpeed exposing (defaultSpeed)
import Task
import Json.Encode as JE
import Json.Decode as JD

type alias StoredModel =
  { speed : Int
  , symbols : List String
  }

type Msg = Loaded StoredModel

port setStorage : JE.Value -> Cmd msg

encodedModel : StoredModel -> JE.Value
encodedModel { speed, symbols } = JE.object
  [ ("speed", JE.int speed)
  , ("symbols", JE.list JE.string symbols)
  ]

writeModel : StoredModel -> Cmd msg
writeModel model = setStorage (encodedModel model)

modelDecoder : JD.Decoder StoredModel
modelDecoder =
  JD.map2 StoredModel
    (JD.field "speed" JD.int)
    (JD.field "symbols" (JD.list JD.string))

decodeModel : String -> StoredModel
decodeModel value = case JD.decodeString modelDecoder value of
  (Ok x) -> x
  (Err _) -> defaultModel

key = "repeatManage"

defaultModel : StoredModel
defaultModel = StoredModel defaultSpeed []
