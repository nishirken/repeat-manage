module Styles exposing (..)

import Css exposing (..)
import Css.Global as GlobalCss
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href, src, type_, rel)
import Html.Styled.Events exposing (onClick)

reset =
  [ margin (px 0)
  , padding (px 0)
  , boxSizing borderBox
  ]

globalStyles = GlobalCss.global
  [ GlobalCss.everything reset
  , GlobalCss.body [
    displayFlex
    , height (pct 100)
    , color (hex "000")
    , backgroundColor (hex "ffdd72")
    , fontFamilies ["Sarabun"]
  ]
  , GlobalCss.html [
    height (pct 100)
  ]
  ]

root : List (Attribute msg) -> List (Html msg) -> Html msg
root =
  styled div
    [ displayFlex
    , flexDirection column
    , alignItems center
    , minWidth (px 1000) 
    , margin2 (px 0) auto
    ]

stripe : List (Attribute msg) -> List (Html msg) -> Html msg
stripe =
  styled section
    [ displayFlex
    , width (pct 100)
    , height (px 200)
    , margin3 (px 100) (px 0) (px 50)
    , padding2 (px 0) (px 200)
    ]

bottomSection : List (Attribute msg) -> List (Html msg) -> Html msg
bottomSection =
  styled section
    [ displayFlex
    , width (pct 100)
    ]

addSymbol : List (Attribute msg) -> List (Html msg) -> Html msg
addSymbol =
  styled aside
    [ displayFlex
    , flexDirection column
    , width (px 200)
    , opacity (int 2)
    ]
