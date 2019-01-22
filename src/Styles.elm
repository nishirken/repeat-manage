module Styles exposing (..)

import Css exposing (..)
import Css.Global as GlobalCss
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href, src, type_, rel)
import Html.Styled.Events exposing (onClick)
import Css.Transitions as Transitions

mainFont = "Sarabun"
bgColor = hex "ffd54f"
mainColor = hex "ff5722"
sndColor = hex "ffecb3"

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
    , backgroundColor bgColor
    , fontFamilies [mainFont]
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
    , justifyContent spaceAround
    , width (pct 100)
    , maxWidth (px 700)
    ]

opacityTransition =
  [ opacity (num 0.6)
  , Transitions.transition
    [ Transitions.opacity 500 ]
    , hover [ opacity (num 1) ]
  ]

asideList : List (Attribute msg) -> List (Html msg) -> Html msg
asideList =
  styled aside
    (List.append
      [ displayFlex
      , flexDirection column
      , width (px 200)
      , height (pct 100)
      ] opacityTransition)

styledInput : List (Attribute msg) -> List (Html msg) -> Html msg
styledInput =
  styled input
    [ outline none
    , border3 (px 1) solid mainColor
    , padding2 (px 5) (px 12)
    , backgroundColor sndColor
    , fontFamilies [mainFont]
    , fontSize (px 16)
    ]

speedInput : List (Attribute msg) -> List (Html msg) -> Html msg
speedInput =
  styled styledInput
    (List.append
      [ width (px 150)
      , margin2 (px 50) auto
      , fontSize (px 24)
      , textAlign center
      ] opacityTransition)

addButton : List (Attribute msg) -> List (Html msg) -> Html msg
addButton =
  styled button
    [ padding2 (px 5) (px 15)
    , outline none
    , backgroundColor mainColor
    , borderWidth (px 0)
    , cursor pointer
    ]
