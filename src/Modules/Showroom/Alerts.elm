module Modules.Showroom.Alerts exposing (alerts)

import Element
import Modules.Showroom.Types exposing (Msg(..), UiElement)
import UiFramework
import UiFramework.Alert as Alert
import UiFramework.Types exposing (Role(..))
import UiFramework.Typography as Typography


text : String -> UiElement Msg
text str =
    UiFramework.uiText (\_ -> str)


alerts : UiElement Msg
alerts =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 16
        ]
        [ warning
        , danger
        , success
        , info
        , primary
        , secondary
        ]


warning : UiElement Msg
warning =
    Alert.default
        |> Alert.withRole Warning
        |> Alert.withChild
            (UiFramework.uiColumn
                [ Element.width Element.fill
                , Element.spacing 8
                ]
                [ Typography.h4 [] <| text "Whoa bro!"
                , UiFramework.uiParagraph []
                    [ text "Watch out - you got warning." ]
                ]
            )
        |> Alert.view


danger : UiElement Msg
danger =
    Alert.default
        |> Alert.withRole Danger
        |> Alert.withChild
            (UiFramework.uiColumn
                [ Element.width Element.fill
                , Element.spacing 8
                ]
                [ Typography.h4 [] <| text "Uh Oh!"
                , UiFramework.uiParagraph []
                    [ text "Change a few things and try again." ]
                ]
            )
        |> Alert.view


success : UiElement Msg
success =
    Alert.default
        |> Alert.withRole Success
        |> Alert.withChild
            (UiFramework.uiColumn
                [ Element.width Element.fill
                , Element.spacing 8
                ]
                [ Typography.h4 [] <| text "Yee Haw!"
                , UiFramework.uiParagraph []
                    [ text "You did it!" ]
                ]
            )
        |> Alert.view


info : UiElement Msg
info =
    Alert.default
        |> Alert.withRole Info
        |> Alert.withChild
            (UiFramework.uiColumn
                [ Element.width Element.fill
                , Element.spacing 8
                ]
                [ Typography.h4 [] <| text "Heads up!"
                , UiFramework.uiParagraph []
                    [ text "This alert is an attention whore." ]
                ]
            )
        |> Alert.view


primary : UiElement Msg
primary =
    Alert.default
        |> Alert.withRole Primary
        |> Alert.withChild
            (UiFramework.uiColumn
                [ Element.width Element.fill
                , Element.spacing 8
                ]
                [ Typography.h4 [] <| text "Hmmm..."
                , UiFramework.uiParagraph []
                    [ text "The \"primary\" and the \"info\" roles look pretty similar, colour-wise." ]
                ]
            )
        |> Alert.view


secondary : UiElement Msg
secondary =
    Alert.default
        |> Alert.withRole Secondary
        |> Alert.withChild
            (UiFramework.uiColumn
                [ Element.width Element.fill
                , Element.spacing 8
                ]
                [ Typography.h4 [] <| text "Aww man"
                , UiFramework.uiParagraph []
                    [ text "Being the \"secondary\" role, this alert has a major inferiority complex." ]
                ]
            )
        |> Alert.view
