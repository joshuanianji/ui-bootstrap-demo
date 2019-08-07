module Modules.Showroom.Badges exposing (badges)

import Modules.Showroom.Types exposing (Msg(..), UiElement)
import UiFramework
import Element
import UiFramework.Badge as Badge
import UiFramework.Types exposing (Role(..))


badges : UiElement Msg
badges = 
    UiFramework.uiColumn
            [ Element.width Element.fill
            , Element.spacing 16
            ]
            [
            UiFramework.uiRow
                [ Element.spacing 4 ]
                (List.map
                    (\( role, name ) -> 
                        Badge.simple role name)
                    badgeRoles
                )
            , UiFramework.uiRow
                [ Element.spacing 4 ]
                (List.map
                    (\( role, name ) ->
                        Badge.default
                            |> Badge.withRole role 
                            |> Badge.withLabel name 
                            |> Badge.withPill
                            |> Badge.view
                    )
                    badgeRoles
                )]

badgeRoles : List ( Role, String )
badgeRoles =
    [ ( Primary, "Primary" )
    , ( Secondary, "Secondary" )
    , ( Success, "Success" )
    , ( Info, "Info" )
    , ( Warning, "Warning" )
    , ( Danger, "Danger" )
    , ( Light, "Light" )
    , ( Dark, "Dark" )
    ]