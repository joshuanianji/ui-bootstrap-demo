module Modules.Showroom.View exposing (view)

import Element exposing (DeviceClass(..), Element)
import Element.Font as Font
import Modules.Showroom.Types exposing (Model, Msg(..), UiElement, Context)
import SharedState exposing (SharedState)
import UiFramework exposing (toElement, uiText)
import UiFramework.Button as Button
import UiFramework.Container as Container exposing (Container)
import UiFramework.Typography as Typography
import Modules.Showroom.Buttons
import Modules.Showroom.Badges
import Modules.Showroom.Alerts




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
        ]



-- i.e. the theme name


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
                [ Typography.display4 [ align ] (text "nah")
                , Typography.textLead [ align ] (text "This title doesn't change as of yet")
                ]
        )


buttons : UiElement Msg
buttons =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 16
        ]
        [ Typography.h1 [] (text "Buttons")
        , Modules.Showroom.Buttons.buttons
        ]

badges : UiElement Msg 
badges =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 16
        ]
        [ Typography.h1 [] (text "Badges")
        , Modules.Showroom.Badges.badges
        ]

alerts : UiElement Msg 
alerts =
    UiFramework.uiColumn
    [ Element.width Element.fill
        , Element.spacing 16
        ]
        [ Typography.h1 [] (text "Alert")
        , 
        Modules.Showroom.Alerts.alerts
        ]