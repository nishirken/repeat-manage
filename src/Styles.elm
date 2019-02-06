module Styles exposing (..)

import Css exposing (..)
import Css.Global as GlobalCss
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href, src, type_, rel)
import Html.Styled.Events exposing (onClick)
import Css.Transitions as Transitions
import Css.Animations as Animations

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
centerSize = 200

stripe : List (Attribute msg) -> List (Html msg) -> Html msg
stripe =
  styled section
    [ position relative
    , width (px ((75 * 2) + (100 * 2) + (125 * 2) + 200))
    , minHeight (px 400)
    , margin2 (px 0) auto
    , fontWeight (int 800)
    , overflowX hidden
    ]

animationSpeed speed = if speed <= 500 then speed else 500

innerSlider : Int -> List (Attribute msg) -> List (Html msg) -> Html msg
innerSlider speed =
  styled div
    [ displayFlex
    , alignItems center
    , justifyContent center
    , animationName slideShow
    , animationDuration (ms (toFloat (animationSpeed speed)))
    , animationIterationCount infinite
    ]

slideShow =
  Animations.keyframes
  [(0, [Animations.transform [translateX (px (-100))]]), (100, [Animations.transform [translateX (px 0)]])]

calculate : Int -> a -> a -> a -> a -> a
calculate index fst snd third fourth =
  if index == 0 || index == (stripeSize - 1)
    then fst
    else if index == 1 || index == 5
      then snd
      else if index == 2 || index == 4
        then third
        else fourth

calculateFontSize index = px <| calculate index 30 60 90 130
calculateOpacity index = num <| calculate index 0.3 0.5 0.8 1.0
calculateSize index = px <| calculate index 75 100 125 200

symbol : Int -> List (Attribute msg) -> List (Html msg) -> Html msg
symbol index =
  styled div
    [ displayFlex
    , alignItems center
    , justifyContent center
    , minWidth (calculateSize index)
    , height (calculateSize index)
    , fontSize (calculateFontSize index)
    , opacity (calculateOpacity index)
    ]

centerBorder : List (Attribute msg) -> List (Html msg) -> Html msg
centerBorder = let inCenter = (calc (pct 50) minus (px (centerSize / 2))) in
  styled div
    [ position absolute
    , top inCenter
    , left inCenter
    , width (px centerSize)
    , height (px centerSize)
    , border3 (px 3) solid mainColor
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
      , marginTop (px 50)
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
