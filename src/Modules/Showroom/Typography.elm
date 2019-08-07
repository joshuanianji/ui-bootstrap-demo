module Modules.Showroom.Typography exposing (typography)

import Element
import Modules.Showroom.Types exposing (Msg(..), UiElement)
import UiFramework
import UiFramework.Types exposing (Role(..))
import UiFramework.Typography as Typography


typography : UiElement Msg
typography =
    UiFramework.uiRow
        [ Element.width Element.fill ]
        [ headings ]


text : String -> UiElement Msg
text str =
    UiFramework.uiText (\_ -> str)


headings : UiElement Msg
headings =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 16
        ]
        [ Typography.h1 [] (text "Heading 1")
        , Typography.h2 [] (text "Heading 2")
        , Typography.h3 [] (text "Heading 3")
        , Typography.h4 [] (text "Heading 4")
        , Typography.h5 [] (text "Heading 5")
        , Typography.h6 [] (text "Heading 6")
        , Typography.textLead [] (text "Lead Text")
        ]
