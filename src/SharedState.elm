module SharedState exposing (SharedState, SharedStateUpdate(..), init, update)

import Browser.Navigation
import Element exposing (Device)
import UiFramework.Configuration exposing (ThemeConfig, defaultThemeConfig)


type alias SharedState =
    { navKey : Browser.Navigation.Key -- used by other pages to navigate (through Browser.Navigation.pushUrl)
    , device : Device
    , theme : ThemeConfig
    }


type SharedStateUpdate
    = UpdateDevice Device
    | UpdateTheme ThemeConfig
    | NoUpdate


init : Device -> Browser.Navigation.Key -> SharedState
init device key =
    { navKey = key
    , device = device
    , theme = defaultThemeConfig
    }


update : SharedState -> SharedStateUpdate -> SharedState
update sharedState updateMsg =
    case updateMsg of
        UpdateDevice device ->
            { sharedState | device = device }

        UpdateTheme theme ->
            { sharedState | theme = theme }

        NoUpdate ->
            sharedState
