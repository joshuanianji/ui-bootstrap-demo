module Main exposing (main)

import Browser
import Browser.Events
import Element exposing (Device, Element)
import Element.Background as Background
import Element.Font as Font
import FontAwesome.Solid
import Html exposing (Html)
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


view : Model -> Html Msg
view model =
    Element.layout [] <|
        Element.column
            [ Element.width Element.fill
            , Element.height Element.fill
            , Background.color model.theme.bodyBackground
            , Font.color <| model.theme.fontColor model.theme.bodyBackground
            ]
            [ navbar model
            , content model
            ]


navbar : Model -> Element Msg
navbar model =
    let
        navbarState =
            { toggleMenuState = model.toggleMenuState
            , dropdownState = model.dropdownMenuState
            }

        context =
            { device = model.device
            , themeConfig = model.theme
            , parentRole = Nothing
            , state = navbarState
            }

        brand =
            Element.row []
                [ Element.text "Navbar" ]

        homeItem =
            Navbar.linkItem NoOp
                |> Navbar.withMenuIcon FontAwesome.Solid.home
                |> Navbar.withMenuTitle "Home"

        themeSelect =
            Navbar.dropdown ToggleDropdown ThemeSelectOpen
                |> Navbar.withDropdownMenuItems
                    [ Navbar.dropdownMenuLinkItem (SelectTheme defaultThemeConfig)
                        |> Navbar.withDropdownMenuTitle "Default"
                    , Navbar.dropdownMenuLinkItem (SelectTheme darklyThemeConfig)
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
            , themeSelect
            ]
        |> Navbar.view
        |> toElement context


content : Model -> Element Msg
content model =
    let
        context =
            { device = model.device
            , parentRole = Nothing
            , themeConfig = model.theme
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
            [ UiFramework.uiText
                (\_ ->
                    "Go ahead and change the themes between the two preset ones we have right now."
                )
            ]
        , UiFramework.uiParagraph []
            [ UiFramework.uiText (\_ -> "Containers and responsive margins are coming soon!") ]
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


type alias UiElement msg =
    WithContext Context msg


type alias Context =
    {}


type alias Model =
    { theme : ThemeConfig
    , device : Device
    , dropdownMenuState : DropdownMenuState
    , toggleMenuState : Bool
    }


type DropdownMenuState
    = AllClosed
    | ThemeSelectOpen


type alias Flags =
    WindowSize


type alias WindowSize =
    { width : Int
    , height : Int
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { theme = defaultThemeConfig
      , device = Element.classifyDevice flags
      , dropdownMenuState = AllClosed
      , toggleMenuState = False
      }
    , Cmd.none
    )


text : String -> UiElement Msg
text str =
    uiText (\_ -> str)


type Msg
    = NoOp
    | WindowSizeChange WindowSize
    | ToggleDropdown
    | ToggleMenu
    | SelectTheme ThemeConfig
    | ChangeTheme ThemeConfig


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        WindowSizeChange windowSize ->
            ( { model | device = Element.classifyDevice windowSize |> Debug.log "Device" }
            , Cmd.none
            )

        ToggleDropdown ->
            let
                dropdownMenuState =
                    if model.dropdownMenuState == ThemeSelectOpen then
                        AllClosed

                    else
                        ThemeSelectOpen
            in
            ( { model | dropdownMenuState = dropdownMenuState }
            , Cmd.none
            )

        ToggleMenu ->
            ( { model | toggleMenuState = not model.toggleMenuState }
            , Cmd.none
            )

        SelectTheme theme ->
            update
                (ChangeTheme theme)
                { model | dropdownMenuState = AllClosed }

        ChangeTheme theme ->
            ( { model | theme = theme }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Browser.Events.onResize
        (\x y ->
            WindowSizeChange (WindowSize x y)
        )


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
