module Utils exposing (..)

withLog : a -> a
withLog x = Debug.log (Debug.toString x) x
