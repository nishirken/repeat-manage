module Styles exposing (..)

import Css exposing (..)
import Css.Global as GlobalCss
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href, src, type_)
import Html.Styled.Events exposing (onClick)

fonts = node "script"
  [ type_ "text/javascript" ]
  [ text """
    window.onLoad(() => {
      const link = document.createElement('link');
      link.rel = 'stylesheet';
      link.href = 'https://fonts.googleapis.com/css?family=Sarabun:400,800';
      document.querySelector('head').appendChild(link);
    });
  """]

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
  ]
  , GlobalCss.html [
    height (pct 100)
  ]
  ]

root : List (Attribute msg) -> List (Html msg) -> Html msg
root =
  styled div
    [ minWidth (px 1000) 
    , margin2 (px 100) auto
    , color (rgb 250 250 250)
    ]

stripe : List (Attribute msg) -> List (Html msg) -> Html msg
stripe =
  styled section
    [ displayFlex
    , width (pct 100)
    , height (px 100)
    , fontFamilies ["Sarabun"]
    ]
