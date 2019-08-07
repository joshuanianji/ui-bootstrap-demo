module Modules.Showroom.Buttons exposing (buttons)


import Modules.Showroom.Types exposing (Msg(..), UiElement)
import UiFramework 
import Element
import UiFramework.Button as Button
import UiFramework.Types exposing (Role(..))


buttons : UiElement Msg
buttons = 
    UiFramework.uiColumn
        [Element.width Element.fill
        , Element.spacing 32
        ]
        [ coloursAndDisplays
        , sizes]

coloursAndDisplays : UiElement Msg 
coloursAndDisplays =
    UiFramework.uiColumn
            [ Element.width Element.fill
            , Element.spacing 16
            ]
            [
            UiFramework.uiRow
                [ Element.spacing 4 ]
                (List.map
                    (\( role, name ) ->
                        Button.default
                            |> Button.withLabel name
                            |> Button.withRole role
                            |> Button.view
                    )
                    buttonRoles
                )
            , UiFramework.uiRow
                [ Element.spacing 4 ]
                (List.map
                    (\( role, name ) ->
                        Button.default
                            |> Button.withLabel name
                            |> Button.withRole role
                            |> Button.withDisabled
                            |> Button.view
                    )
                    buttonRoles
                )
            , UiFramework.uiRow
                [ Element.spacing 4 ]
                (List.map
                    (\( role, name ) ->
                        Button.default
                            |> Button.withLabel name
                            |> Button.withRole role
                            |> Button.withOutlined
                            |> Button.view
                    )
                    buttonRoles
                )]


sizes : UiElement Msg 
sizes =
    UiFramework.uiRow 
        [Element.spacing 8]
        [ Button.default
            |> Button.withLabel "Large Button"
            |> Button.withLarge 
            |> Button.view
        ,  Button.default
            |> Button.withLabel "Default Button"
            |> Button.withLarge 
            |> Button.view
        , Button.default
            |> Button.withLabel "Small Button"
            |> Button.withLarge 
            |> Button.view
        ]


buttonRoles : List ( Role, String )
buttonRoles =
    [ ( Primary, "Primary" )
    , ( Secondary, "Secondary" )
    , ( Success, "Success" )
    , ( Info, "Info" )
    , ( Warning, "Warning" )
    , ( Danger, "Danger" )
    , ( Light, "Light" )
    , ( Dark, "Dark" )
    ]