module Page.Showroom exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Navigation
import Element exposing (DeviceClass(..), Element)
import Element.Font as Font
import Routes exposing (Route)
import SharedState exposing (SharedState, SharedStateUpdate(..), Theme(..))
import UiFramework exposing (UiContextual, WithContext, toElement)
import UiFramework.Alert as Alert
import UiFramework.Badge as Badge
import UiFramework.Button as Button
import UiFramework.Container as Container
import UiFramework.Navbar as Navbar exposing (NavbarState)
import UiFramework.Pagination as Pagination exposing (Item(..), PaginationState)
import UiFramework.Table as Table
import UiFramework.Types exposing (Role(..))
import UiFramework.Typography as Typography



-- UIFRAMEWORK TYPE


type alias UiElement msg =
    WithContext Context msg


{-| the ui Bootstrap defines three default fields, as defined in the source code (in UiFramwork.Internal)

they are:

  - device : Device
  - themeConfig : ThemeConfig
  - parentRole : Maybe Role

We need to define a Theme type so we will explicitly know what out theme is, so we can change the title as necessary.

-}
type alias Context =
    { theme : Theme
    }



-- MODEL


type alias Model =
    { paginationState : PaginationState
    , navbarState : NavbarState DropdownState
    }


type DropdownState
    = LmaoIDontHaveDropdowns


init : ( Model, Cmd Msg )
init =
    ( { paginationState = paginationState
      , navbarState = navbarState
      }
    , Cmd.none
    )


paginationState =
    { currentSliceNumber = 0 -- starts from 0
    , numberOfSlices = 10
    }


navbarState =
    { toggleMenuState = False
    , dropdownState = LmaoIDontHaveDropdowns
    }



-- VIEW


text : String -> UiElement Msg
text str =
    UiFramework.uiText (\_ -> str)


view : SharedState -> Model -> Element Msg
view sharedState model =
    let
        context =
            { device = sharedState.device
            , parentRole = Nothing
            , themeConfig = SharedState.getThemeConfig sharedState.theme
            , theme = sharedState.theme
            }
    in
    Container.default
        |> Container.withChild
            (UiFramework.uiColumn
                [ Element.paddingXY 0 64
                , Element.width Element.fill
                , Element.spacing 64
                ]
                [ title
                , navbars model.navbarState
                , buttons
                , typography
                , badges
                , alerts
                , table
                , pagination model.paginationState
                ]
            )
        |> Container.view
        |> toElement context



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

                ( titleText, subTitleText ) =
                    case context.theme of
                        Default _ ->
                            ( "Default", "Basic Bootstrap" )

                        Darkly _ ->
                            ( "Darkly", "Night Mode" )
            in
            UiFramework.uiColumn
                [ Element.spacing 16
                , Element.width Element.fill
                ]
                [ Typography.display4 [ align ] <| text titleText
                , Typography.textLead [ align ] <| text subTitleText
                ]
        )



--i know this is only 1 navbar but when we get a "dark" and "light" theme going it'll be lit


navbars : NavbarState DropdownState -> UiElement Msg
navbars state =
    section "Navbars" <|
        let
            brand =
                Element.row []
                    [ Element.text "Navbar" ]

            homeItem =
                Navbar.linkItem NoOp
                    |> Navbar.withMenuTitle "Home"

            item1 =
                Navbar.linkItem NoOp
                    |> Navbar.withMenuTitle "Item 1"

            item2 =
                Navbar.linkItem NoOp
                    |> Navbar.withMenuTitle "Item 2"

            template backgroundColorRole =
                Navbar.default NoOp
                    |> Navbar.withBackground backgroundColorRole
                    |> Navbar.withBrand brand
                    |> Navbar.withMenuItems
                        [ homeItem
                        , item1
                        , item2
                        ]
                    |> Navbar.view state
        in
        UiFramework.uiColumn
            [ Element.width Element.fill
            , Element.spacing 16
            ]
            [ template Primary
            , template Dark
            , template Light
            ]


buttons : UiElement Msg
buttons =
    section "Buttons" <|
        UiFramework.uiColumn
            [ Element.width Element.fill
            , Element.spacing 32
            ]
            [ -- the different colours and displays
              UiFramework.uiColumn
                [ Element.width Element.fill
                , Element.spacing 16
                ]
                [ UiFramework.uiWrappedRow
                    [ Element.spacing 4 ]
                    (List.map
                        (\( role, name ) ->
                            Button.default
                                |> Button.withLabel name
                                |> Button.withRole role
                                |> Button.view
                        )
                        rolesAndNames
                    )
                , UiFramework.uiWrappedRow
                    [ Element.spacing 4 ]
                    (List.map
                        (\( role, name ) ->
                            Button.default
                                |> Button.withLabel name
                                |> Button.withRole role
                                |> Button.withDisabled
                                |> Button.view
                        )
                        rolesAndNames
                    )
                , UiFramework.uiWrappedRow
                    [ Element.spacing 4 ]
                    (List.map
                        (\( role, name ) ->
                            Button.default
                                |> Button.withLabel name
                                |> Button.withRole role
                                |> Button.withOutlined
                                |> Button.view
                        )
                        rolesAndNames
                    )
                ]

            -- different sizes
            , UiFramework.uiWrappedRow
                [ Element.spacing 8 ]
                [ Button.default
                    |> Button.withLabel "Large Button"
                    |> Button.withLarge
                    |> Button.view
                , Button.default
                    |> Button.withLabel "Default Button"
                    |> Button.view
                , Button.default
                    |> Button.withLabel "Small Button"
                    |> Button.withSmall
                    |> Button.view
                ]
            ]


badges : UiElement Msg
badges =
    section "Badges" <|
        UiFramework.uiColumn
            [ Element.width Element.fill
            , Element.spacing 16
            ]
            [ -- simple badges
              UiFramework.uiWrappedRow
                [ Element.spacing 4 ]
                (List.map
                    (\( role, name ) ->
                        Badge.simple role name
                    )
                    rolesAndNames
                )

            -- pill badges
            , UiFramework.uiWrappedRow
                [ Element.spacing 4 ]
                (List.map
                    (\( role, name ) ->
                        Badge.default
                            |> Badge.withRole role
                            |> Badge.withLabel name
                            |> Badge.withPill
                            |> Badge.view
                    )
                    rolesAndNames
                )
            ]


alerts : UiElement Msg
alerts =
    section "Alert" <|
        let
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
        in
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


table : UiElement Msg
table =
    section "Table" <|
        let
            tableColumn =
                [ { head = text "Role"
                  , viewData = \data -> UiFramework.uiParagraph [ Font.bold ] [ text data.role ]
                  }
                , { head = text "Column 1"
                  , viewData = \data -> UiFramework.uiParagraph [] [ text data.column1 ]
                  }
                , { head = text "Column 2"
                  , viewData = \data -> UiFramework.uiParagraph [] [ text data.column2 ]
                  }
                , { head = text "Column 3"
                  , viewData = \data -> UiFramework.uiParagraph [] [ text data.column3 ]
                  }
                ]

            information =
                [ { role = "Row 1"
                  , column1 = "column 1"
                  , column2 = "column 2"
                  , column3 = "column 3"
                  }
                , { role = "Row 2"
                  , column1 = "column 1"
                  , column2 = "column 2"
                  , column3 = "column 3"
                  }
                , { role = "Row 3"
                  , column1 = "column 1"
                  , column2 = "column 2"
                  , column3 = "column 3"
                  }
                , { role = "Row 4"
                  , column1 = "column 1"
                  , column2 = "column 2"
                  , column3 = "column 3"
                  }
                ]
        in
        Table.simpleTable
            |> Table.withColumns tableColumn
            |> Table.view information


typography : UiElement Msg
typography =
    section "Typography" <|
        UiFramework.uiRow
            [ Element.width Element.fill ]
            [ UiFramework.uiColumn
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
            ]


pagination : PaginationState -> UiElement Msg
pagination state =
    section "Pagination" <|
        let
            ( startNumber, endNumber ) =
                if state.numberOfSlices <= 5 then
                    ( 0, state.numberOfSlices - 1 )

                else
                    ( max 0 (state.currentSliceNumber - 2)
                    , min (state.numberOfSlices - 1) (state.currentSliceNumber + 2)
                    )

            itemList =
                (if startNumber > 0 then
                    [ Pagination.EllipsisItem ]

                 else
                    []
                )
                    ++ List.map (\index -> Pagination.NumberItem index) (List.range startNumber endNumber)
                    ++ (if endNumber < (state.numberOfSlices - 1) then
                            [ Pagination.EllipsisItem ]

                        else
                            []
                       )
        in
        Pagination.default PaginationMsg
            |> Pagination.withItems itemList
            |> Pagination.withExtraAttrs [ Element.centerX ]
            |> Pagination.view state
            |> (\paginationElement ->
                    UiFramework.uiColumn
                        [ Element.width Element.fill
                        , Element.spacing 20
                        ]
                        [ UiFramework.uiParagraph
                            [ Font.center ]
                            [ text "Currently on slice #"
                            , text <| String.fromInt (state.currentSliceNumber + 1)
                            ]
                        , paginationElement
                        ]
               )


section : String -> UiElement Msg -> UiElement Msg
section sectionTitle sectionContent =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 16
        ]
        [ Typography.h1
            [ Element.paddingXY 0 32
            ]
            (text sectionTitle)
        , sectionContent
        ]


rolesAndNames : List ( Role, String )
rolesAndNames =
    [ ( Primary, "Primary" )
    , ( Secondary, "Secondary" )
    , ( Success, "Success" )
    , ( Info, "Info" )
    , ( Warning, "Warning" )
    , ( Danger, "Danger" )
    , ( Light, "Light" )
    , ( Dark, "Dark" )
    ]



-- UPDATE


type Msg
    = NoOp
    | PaginationMsg Int
    | ToggleMenu


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none, NoUpdate )

        PaginationMsg int ->
            ( { model | paginationState = updatePaginationSlice int model.paginationState }
            , Cmd.none
            , NoUpdate
            )

        ToggleMenu ->
            ( { model | navbarState = updateNavbarToggle navbarState }
            , Cmd.none
            , NoUpdate
            )


updatePaginationSlice : Int -> PaginationState -> PaginationState
updatePaginationSlice newSlice state =
    { state | currentSliceNumber = newSlice }


updateNavbarToggle : NavbarState DropdownState -> NavbarState DropdownState
updateNavbarToggle state =
    { state | toggleMenuState = not state.toggleMenuState }
