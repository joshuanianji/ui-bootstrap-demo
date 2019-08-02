module Modules.Home.View exposing (view)

import Element exposing (Element)
import Element.Background as Background
import Element.Font as Font
import FontAwesome.Solid
import Modules.Home.Types exposing (Model, Msg(..))
import SharedState exposing (SharedState)
import Themes.Darkly exposing (darklyThemeConfig)
import UiFramework exposing (UiContextual, WithContext, toElement, uiText)
import UiFramework.Alert as Alert
import UiFramework.Button as Button
import UiFramework.Colors as Colors
import UiFramework.Configuration exposing (ThemeConfig, defaultThemeConfig)
import UiFramework.Container as Container
import UiFramework.Navbar as Navbar
import UiFramework.Types as Types
import UiFramework.Typography as Typography


type alias UiElement msg =
    WithContext Context msg


type alias Context =
    {}


text : String -> UiElement Msg
text str =
    uiText (\_ -> str)


view : SharedState -> Model -> Element Msg
view sharedState model =
    let
        context =
            { device = sharedState.device
            , parentRole = Nothing
            , themeConfig = sharedState.theme
            }
    in
    toElement context <|
        jumbotron


jumbotron : UiElement Msg
jumbotron =
    Container.jumbotron
        |> Container.withChild
            (UiFramework.uiColumn
                [ Element.width Element.fill
                , Element.height Element.fill
                , Element.spacing 16
                ]
                [ title
                , lead
                , description
                , button
                ]
            )
        |> Container.view


title : UiElement Msg
title =
    Typography.display2 [ Element.paddingXY 0 30 ] <|
        text "Hello, world!"


lead : UiElement Msg
lead =
    UiFramework.uiParagraph []
        [ Typography.textLead [] <|
            text "This is a very simple demo template. Here we have a navigation bar with a dropdown, as well as a jumbotron."
        ]


description : UiElement Msg
description =
    UiFramework.uiColumn [ Element.spacing 8 ]
        [ UiFramework.uiParagraph []
            [ text
                "Go ahead and change the themes between the two preset ones we have right now."
            ]
        , UiFramework.uiParagraph []
            [ text "We'll have to fix the button soon haha it looks a bit funky." ]
        ]


button : UiElement Msg
button =
    Button.default
        |> Button.withMessage Nothing
        |> Button.withLabel "Learn more »"
        |> Button.withLarge
        |> Button.view


alert : UiElement Msg
alert =
    Alert.simple Types.Warning <|
        text "This is an alert!"
