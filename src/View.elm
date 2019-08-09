module View exposing (viewApplication)

import Browser
import Element exposing (Element)
import Element.Background as Background
import Element.Font as Font
import FontAwesome.Solid
import FontAwesome.Styles
import Html exposing (Html)
import Page.Home as Home
import Page.NotFound as NotFound
import Page.Showroom as Showroom
import Router exposing (DropdownMenuState(..), Model, Msg(..), Page(..))
import Routes exposing (Route(..))
import SharedState exposing (SharedState, Theme(..))
import Themes.Darkly exposing (darklyThemeConfig)
import UiFramework exposing (toElement)
import UiFramework.Configuration exposing (defaultThemeConfig)
import UiFramework.Navbar as Navbar


viewApplication : (Msg -> msg) -> Model -> SharedState -> Browser.Document msg
viewApplication toMsg model sharedState =
    { title = tabBarTitle model
    , body = [ view toMsg model sharedState ]
    }



-- title of our app (shows in tab bar)


tabBarTitle : Model -> String
tabBarTitle model =
    case model.currentPage of
        HomePage _ ->
            "Home"

        ShowroomPage _ ->
            "Showroom"

        NotFoundPage _ ->
            "Not Found"


view : (Msg -> msg) -> Model -> SharedState -> Html msg
view toMsg model sharedState =
    let
        themeConfig =
            SharedState.getThemeConfig sharedState.theme
    in
    Element.column
        [ Element.width Element.fill
        , Element.height Element.fill
        , Background.color themeConfig.bodyBackground
        , Font.color <| themeConfig.fontColor themeConfig.bodyBackground
        , Element.paddingXY 0 50
        ]
        [ FontAwesome.Styles.css |> Element.html
        , content model sharedState
        ]
        |> Element.layout [ Element.inFront <| navbar model sharedState ]
        |> Html.map toMsg


navbar : Model -> SharedState -> Element Msg
navbar model sharedState =
    let
        navbarState =
            { toggleMenuState = model.toggleMenuState
            , dropdownState = model.dropdownMenuState
            }

        context =
            { device = sharedState.device
            , themeConfig = SharedState.getThemeConfig sharedState.theme
            , parentRole = Nothing
            , state = navbarState
            }

        brand =
            Element.row []
                [ Element.text "Navbar" ]

        homeItem =
            Navbar.linkItem (NavigateTo Home)
                |> Navbar.withMenuIcon FontAwesome.Solid.home
                |> Navbar.withMenuTitle "Home"

        showRoomItem =
            Navbar.linkItem (NavigateTo Showroom)
                |> Navbar.withMenuIcon FontAwesome.Solid.laptopCode
                |> Navbar.withMenuTitle "Showroom"

        themeSelect =
            Navbar.dropdown ToggleDropdown ThemeSelectOpen
                |> Navbar.withDropdownMenuItems
                    [ Navbar.dropdownMenuLinkItem (SelectTheme <| Default defaultThemeConfig)
                        |> Navbar.withDropdownMenuTitle "Default"
                    , Navbar.dropdownMenuLinkItem (SelectTheme <| Darkly darklyThemeConfig)
                        |> Navbar.withDropdownMenuTitle "Dark"
                    ]
                |> Navbar.DropdownItem
                |> Navbar.withMenuIcon FontAwesome.Solid.flag
                |> Navbar.withMenuTitle "Theme"
    in
    Navbar.default ToggleMenu
        |> Navbar.withBrand brand
        |> Navbar.withBackgroundColor (Element.rgb255 53 61 71)
        |> Navbar.withMenuItems
            [ homeItem
            , showRoomItem
            , themeSelect
            ]
        |> Navbar.view
        |> toElement context


content : Model -> SharedState -> Element Msg
content model sharedState =
    case model.currentPage of
        HomePage pageModel ->
            Home.view sharedState pageModel
                |> mapMsg HomeMsg

        ShowroomPage pageModel ->
            Showroom.view sharedState pageModel
                |> mapMsg ShowroomMsg

        NotFoundPage pageModel ->
            NotFound.view sharedState pageModel
                |> mapMsg NotFoundMsg


mapMsg : (subMsg -> Msg) -> Element subMsg -> Element Msg
mapMsg toMsg element =
    element
        |> Element.map toMsg
