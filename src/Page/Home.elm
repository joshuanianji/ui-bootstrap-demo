module Page.Home exposing (Model, Msg(..), update, view, init)

import Browser.Navigation as Navigation
import Element exposing (Element)
import Element.Background as Background
import Element.Font as Font
import FontAwesome.Solid
import Routes exposing (Route(..))
import SharedState exposing (SharedState, SharedStateUpdate)
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



-- UIFRAMEWORK TYPE


type alias UiElement msg =
    WithContext Context msg



-- MODEL


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}
    , Cmd.none
    )



-- VIEW


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
            , themeConfig = SharedState.getThemeConfig sharedState.theme
            }
    in
    toElement context <|
        jumbotron


{-| full-width jumbotron serves as a background, while the container within it holds the content.
-}
jumbotron : UiElement Msg
jumbotron =
    let
        jumbotronContent =
            UiFramework.uiColumn
                [ Element.width Element.fill
                , Element.height Element.fill
                , Element.spacing 16
                ]
                [ title
                , lead
                , description
                , button
                ]
    in
    Container.jumbotron
        |> Container.withFullWidth
        |> Container.withChild
            (Container.default
                |> Container.withChild jumbotronContent
                |> Container.view
            )
        |> Container.view


title : UiElement Msg
title =
    Typography.display2 [ Element.paddingXY 0 30 ] <|
        text "Hello, World!"


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
        |> Button.withMessage (Just <| NavigateTo Showroom)
        |> Button.withLabel "Learn more »"
        |> Button.withLarge
        |> Button.view


alert : UiElement Msg
alert =
    Alert.simple Types.Warning <| text "This is an alert!"



-- UPDATE


type Msg
    = NoOp
    | NavigateTo Route


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NavigateTo route ->
            ( model, Navigation.pushUrl sharedState.navKey (Routes.toUrlString route), SharedState.NoUpdate )

        NoOp ->
            ( model, Cmd.none, SharedState.NoUpdate )