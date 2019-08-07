module Modules.Showroom.View exposing (view)

import Element exposing (DeviceClass(..), Element)
import Element.Font as Font
import Modules.Showroom.Types exposing (Model, Msg(..), UiElement, Context)
import SharedState exposing (SharedState, Theme(..))
import UiFramework exposing (toElement, uiText)
import UiFramework.Button as Button
import UiFramework.Container as Container exposing (Container)
import UiFramework.Typography as Typography
import Modules.Showroom.Buttons
import Modules.Showroom.Badges
import Modules.Showroom.Alerts
import Modules.Showroom.Table



text : String -> UiElement Msg
text str =
    uiText (\_ -> str)


view : SharedState -> Model -> Element Msg
view sharedState model =
    let
        context =
            { device = sharedState.device
            , parentRole = Nothing
            , theme = sharedState.theme
            , themeConfig = SharedState.getThemeConfig sharedState.theme
            }
    in
    Container.default
        |> Container.withChild content
        |> Container.view
        |> toElement context


content : UiElement Msg
content =
    UiFramework.uiColumn
        [ Element.paddingXY 0 64
        , Element.width Element.fill
        , Element.spacing 64
        ]
        [ title
        , buttons
        , badges
        , alerts
        , table
        ]



-- i.e. the theme name and a small description below


title : UiElement Msg
title =
    UiFramework.flatMap
        (\context ->
            let
                align =
                    case context.device.class of
                        Phone ->
                            Element.centerX

                        _ ->
                            Element.alignLeft
            in
            UiFramework.uiColumn
                [ Element.spacing 16
                , Element.width Element.fill
                ]
                [ Typography.display4 [ align ] titleText
                , Typography.textLead [ align ] subTitleText
                ]
        )

titleText : UiElement Msg 
titleText =
    UiFramework.uiText
        (\context ->
            case context.theme of 
                Default _ ->
                    "Default"
                
                Darkly _ ->
                    "Darkly"
                )

subTitleText : UiElement Msg 
subTitleText =
    UiFramework.uiText
        (\context ->
            case context.theme of 
                Default _ ->
                    "Basic Bootstrap"
                
                Darkly _ ->
                    "Night Mode"
                )

buttons : UiElement Msg
buttons =
    section "Buttons" Modules.Showroom.Buttons.buttons

badges : UiElement Msg 
badges =
    section "Badges" Modules.Showroom.Badges.badges

alerts : UiElement Msg 
alerts =
    section "Alert" Modules.Showroom.Alerts.alerts


table : UiElement Msg 
table =
    section "Table" Modules.Showroom.Table.table


section : String -> UiElement Msg -> UiElement Msg 
section sectionTitle sectionContent =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 16
        ]
        [ Typography.h1 [
         Element.paddingXY 0 32] (text sectionTitle)
        , sectionContent
        ]
