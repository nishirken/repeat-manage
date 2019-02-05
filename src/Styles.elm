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

stripeSize = 7

stripe : List (Attribute msg) -> List (Html msg) -> Html msg
stripe =
  styled section
    [ displayFlex
    , alignItems center
    , justifyContent spaceBetween
    , width (pct 100)
    , minWidth (px 700)
    , minHeight (px 400)
    , margin3 (px 100) auto (px 50)
    , padding2 (px 0) (px 200)
    , fontWeight (int 800)
    ]

calculateSize index =
  if index == 0 || index == (stripeSize - 1)
    then 30
    else if index == 1 || index == 5
      then 50
      else if index == 2 || index == 4
        then 70
        else 160

calculateOpacity index = num <|
  if index == 0 || index == (stripeSize - 1)
    then 0.3
    else if index == 1 || index == 5
      then 0.5
      else if index == 2 || index == 4
        then 0.8
        else 1.0

calculateBorderColor index = if (remainderBy stripeSize 2) == (index - 1) then hex "000" else rgba 0 0 0 0

symbol : Int -> Int -> List (Attribute msg) -> List (Html msg) -> Html msg
symbol index speed =
  styled div
    [ displayFlex
    , alignItems center
    , fontSize (px (calculateSize index))
    , border3 (px 3) solid (calculateBorderColor index)
    , opacity (calculateOpacity index)
    , Transitions.transition [Transitions.opacity3 ((toFloat speed) / 2) 0 Transitions.easeInOut]
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
      , marginLeft auto
      , marginTop (px 150)
      ] opacityTransition)

styledInput : List (Attribute msg) -> List (Html msg) -> Html msg
styledInput =
  styled input
    [ width (px 100)
    , outline none
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
      [ margin2 (px 50) auto
      , fontSize (px 24)
      , textAlign center
      ] opacityTransition)

styledButton : List (Attribute msg) -> List (Html msg) -> Html msg
styledButton =
  styled button
    [ width (px 60)
    , padding2 (px 5) (px 15)
    , outline none
    , backgroundColor mainColor
    , borderWidth (px 0)
    , cursor pointer
    ]

buttonWrapper : List (Attribute msg) -> List (Html msg) -> Html msg
buttonWrapper =
  styled div
    [ displayFlex
    , justifyContent spaceBetween
    , width (px 160)
    , marginBottom (px 10)
    , boxSizing borderBox
    ]

listItemWrapper : List (Attribute msg) -> List (Html msg) -> Html msg
listItemWrapper =
  styled buttonWrapper
    [ paddingLeft (px 10) ]
