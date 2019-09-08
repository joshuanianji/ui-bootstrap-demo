module Page.Showroom exposing (Model, Msg(..), init, update, view)

import Element exposing (DeviceClass(..), Element)
import Element.Font as Font
import SharedState exposing (SharedState, SharedStateUpdate(..), Theme(..))
import UiFramework
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
    UiFramework.WithContext Context msg


{-| the ui Bootstrap defines three default fields, as defined in the source code (in UiFramwork.Internal)

they are:

  - device : Device
  - themeConfig : ThemeConfig
  - parentRole : Maybe Role

We need to define a Theme type so we will explicitly know what our theme is, so we can change the title as necessary.

-}
type alias Context =
    { theme : Theme
    }



-- Nav type


type alias NavState =
    NavbarState DropdownState



-- MODEL


type alias Model =
    { paginationState : PaginationState
    , primaryNavState : NavState
    , darkNavState : NavState
    , lightNavState : NavState
    }


type DropdownState
    = LmaoIDontHaveDropdowns


init : ( Model, Cmd Msg )
init =
    ( { paginationState = initPaginationState
      , primaryNavState = initNavState
      , darkNavState = initNavState
      , lightNavState = initNavState
      }
    , Cmd.none
    )


initPaginationState : PaginationState
initPaginationState =
    { currentSliceNumber = 0 -- starts from 0
    , numberOfSlices = 10
    }


initNavState : NavState
initNavState =
    { toggleMenuState = False
    , dropdownState = LmaoIDontHaveDropdowns
    }



-- VIEW


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
                , navbars model
                , buttons
                , typography
                , badges
                , alerts
                , table
                , pagination model.paginationState
                ]
            )
        |> Container.view
        |> UiFramework.toElement context



-- i.e. the theme name and a small description below


title : UiElement Msg
title =
    UiFramework.withContext
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

                        Materia _ ->
                            ( "Materia", "Material Design" )
            in
            UiFramework.uiColumn
                [ Element.spacing 16
                , Element.width Element.fill
                ]
                [ Typography.display4 [ align ] <| UiFramework.uiText titleText
                , Typography.textLead [ align ] <| UiFramework.uiText subTitleText
                ]
        )


navbars : Model -> UiElement Msg
navbars model =
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

            navTemplate backgroundColorRole msg state =
                Navbar.default msg
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
            [ navTemplate Primary TogglePrimaryNav model.primaryNavState
            , navTemplate Dark ToggleDarkNav model.darkNavState
            , navTemplate Light ToggleLightNav model.lightNavState
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
                Alert.simpleWarning
                    (UiFramework.uiColumn
                        [ Element.width Element.fill
                        , Element.spacing 8
                        ]
                        [ Typography.h4 [] <| UiFramework.uiText "Whoa bro!"
                        , UiFramework.uiParagraph []
                            [ UiFramework.uiText "Watch out - you got warning." ]
                        ]
                    )

            danger =
                Alert.simpleDanger
                    (UiFramework.uiColumn
                        [ Element.width Element.fill
                        , Element.spacing 8
                        ]
                        [ Typography.h4 [] <| UiFramework.uiText "Uh oh!"
                        , UiFramework.uiParagraph []
                            [ UiFramework.uiText "Change a few things and try again." ]
                        ]
                    )

            success =
                Alert.simpleSuccess
                    (UiFramework.uiColumn
                        [ Element.width Element.fill
                        , Element.spacing 8
                        ]
                        [ Typography.h4 [] <| UiFramework.uiText "Yee haw!"
                        , UiFramework.uiParagraph []
                            [ UiFramework.uiText "You did it!" ]
                        ]
                    )

            info =
                Alert.simpleInfo
                    (UiFramework.uiColumn
                        [ Element.width Element.fill
                        , Element.spacing 8
                        ]
                        [ Typography.h4 [] <| UiFramework.uiText "Heads up!"
                        , UiFramework.uiParagraph []
                            [ UiFramework.uiText "This alert is an attention whore." ]
                        ]
                    )

            primary =
                Alert.simplePrimary
                    (UiFramework.uiColumn
                        [ Element.width Element.fill
                        , Element.spacing 8
                        ]
                        [ Typography.h4 [] <| UiFramework.uiText "The Primary Role"
                        , UiFramework.uiParagraph []
                            [ UiFramework.uiText "People say I'm the best boss. They go, 'God, we've never worked in a place like this. You're hilarious, and you get the best out of us.'" ]
                        ]
                    )

            secondary =
                Alert.simpleSecondary
                    (UiFramework.uiColumn
                        [ Element.width Element.fill
                        , Element.spacing 8
                        ]
                        [ Typography.h4 [] <| UiFramework.uiText "Aww man"
                        , UiFramework.uiParagraph []
                            [ UiFramework.uiText "Being the 'secondary' role, this alert has a major inferiority complex." ]
                        ]
                    )
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
                [ { head = UiFramework.uiText "Role"
                  , viewData = \data -> UiFramework.uiParagraph [ Font.bold ] [ UiFramework.uiText data.role ]
                  }
                , { head = UiFramework.uiText "Column 1"
                  , viewData = \data -> UiFramework.uiParagraph [] [ UiFramework.uiText data.column1 ]
                  }
                , { head = UiFramework.uiText "Column 2"
                  , viewData = \data -> UiFramework.uiParagraph [] [ UiFramework.uiText data.column2 ]
                  }
                , { head = UiFramework.uiText "Column 3"
                  , viewData = \data -> UiFramework.uiParagraph [] [ UiFramework.uiText data.column3 ]
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
                [ Typography.h1 [] (UiFramework.uiText "Heading 1")
                , Typography.h2 [] (UiFramework.uiText "Heading 2")
                , Typography.h3 [] (UiFramework.uiText "Heading 3")
                , Typography.h4 [] (UiFramework.uiText "Heading 4")
                , Typography.h5 [] (UiFramework.uiText "Heading 5")
                , Typography.h6 [] (UiFramework.uiText "Heading 6")
                , Typography.textLead [] (UiFramework.uiText "Lead Text")
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
                    let
                        start =
                            if state.currentSliceNumber < 3 then
                                0

                            else if state.currentSliceNumber + 2 < state.numberOfSlices then
                                state.currentSliceNumber - 2

                            else
                                state.numberOfSlices - 5

                        end =
                            if start + 4 < state.numberOfSlices then
                                start + 4

                            else
                                state.numberOfSlices - 1
                    in
                    ( start, end )

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
                            [ UiFramework.uiText "Currently on slice #"
                            , UiFramework.uiText <| String.fromInt (state.currentSliceNumber + 1)
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
            (UiFramework.uiText sectionTitle)
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
    | TogglePrimaryNav
    | ToggleDarkNav
    | ToggleLightNav


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

        TogglePrimaryNav ->
            ( { model | primaryNavState = updateNavbarToggle model.primaryNavState }
            , Cmd.none
            , NoUpdate
            )

        ToggleDarkNav ->
            ( { model | darkNavState = updateNavbarToggle model.darkNavState }
            , Cmd.none
            , NoUpdate
            )

        ToggleLightNav ->
            ( { model | lightNavState = updateNavbarToggle model.lightNavState }
            , Cmd.none
            , NoUpdate
            )


updatePaginationSlice : Int -> PaginationState -> PaginationState
updatePaginationSlice newSlice state =
    { state | currentSliceNumber = newSlice }


updateNavbarToggle : NavState -> NavState
updateNavbarToggle state =
    { state | toggleMenuState = not state.toggleMenuState }
