module Router exposing (DropdownMenuState(..), Model, Msg(..), Page(..), init, initWith, navigateTo, update, updateWith, viewApplication)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Element exposing (Element)
import Element.Background as Background
import Element.Font as Font
import FontAwesome.Solid
import FontAwesome.Styles
import Html exposing (Html)
import Page.Home as Home
import Page.NotFound as NotFound
import Page.Showroom as Showroom
import Routes exposing (Route(..))
import SharedState exposing (SharedState, SharedStateUpdate, Theme(..))
import Task
import Themes.Darkly exposing (darklyThemeConfig)
import UiFramework exposing (toElement)
import UiFramework.Configuration exposing (defaultThemeConfig)
import UiFramework.Dropdown as Dropdown
import UiFramework.Navbar as Navbar
import UiFramework.Types exposing (Role(..))
import Url



-- MODEL


type alias Model =
    { route : Routes.Route
    , currentPage : Page
    , navKey : Nav.Key
    , dropdownMenuState : DropdownMenuState
    , toggleMenuState : Bool
    }


type Page
    = HomePage Home.Model
    | ShowroomPage Showroom.Model
    | NotFoundPage NotFound.Model


type DropdownMenuState
    = AllClosed
    | ThemeSelectOpen



-- init with the NotFoundPage, but send a command where we look at the Url and change the page


init : Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init url key =
    let
        currentRoute =
            Routes.fromUrl url
    in
    ( { route = currentRoute
      , currentPage = NotFoundPage {}
      , navKey = key
      , dropdownMenuState = AllClosed
      , toggleMenuState = False
      }
    , (Task.perform identity << Task.succeed) <| UrlChanged url
    )



-- VIEW


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
            Dropdown.default ToggleDropdown ThemeSelectOpen
                |> Dropdown.withIcon FontAwesome.Solid.flag
                |> Dropdown.withTitle "Theme"
                |> Dropdown.withMenuItems
                    [ Dropdown.menuLinkItem (SelectTheme <| Default defaultThemeConfig)
                        |> Dropdown.withMenuTitle "Default"
                    , Dropdown.menuLinkItem (SelectTheme <| Darkly darklyThemeConfig)
                        |> Dropdown.withMenuTitle "Dark"
                    ]
                |> Navbar.DropdownItem
    in
    Navbar.default ToggleMenu
        |> Navbar.withBrand brand
        |> Navbar.withBackground Dark
        |> Navbar.withMenuItems
            [ homeItem
            , showRoomItem
            , themeSelect
            ]
        |> Navbar.view navbarState
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



-- UPDATE


type Msg
    = UrlChanged Url.Url
    | NavigateTo Route
    | HomeMsg Home.Msg
    | ShowroomMsg Showroom.Msg
    | NotFoundMsg NotFound.Msg
    | SelectTheme Theme
    | ToggleDropdown
    | ToggleMenu
    | NoOp


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case ( msg, model.currentPage ) of
        ( UrlChanged url, _ ) ->
            let
                route =
                    Routes.fromUrl url

                ( newModel, newCmd, newSharedStateUpdate ) =
                    navigateTo route sharedState model
            in
            ( { newModel | route = route }
            , newCmd
            , newSharedStateUpdate
            )

        ( NavigateTo route, _ ) ->
            -- changes url
            ( model
            , Nav.pushUrl model.navKey
                (Routes.toUrlString route)
            , SharedState.NoUpdate
            )

        ( HomeMsg subMsg, HomePage subModel ) ->
            Home.update sharedState subMsg subModel
                |> updateWith HomePage HomeMsg model

        ( ShowroomMsg subMsg, ShowroomPage subModel ) ->
            Showroom.update sharedState subMsg subModel
                |> updateWith ShowroomPage ShowroomMsg model

        ( NotFoundMsg subMsg, NotFoundPage subModel ) ->
            NotFound.update sharedState subMsg subModel
                |> updateWith NotFoundPage NotFoundMsg model

        ( SelectTheme theme, _ ) ->
            ( { model | dropdownMenuState = AllClosed }
            , Cmd.none
            , SharedState.UpdateTheme theme
            )

        ( ToggleDropdown, _ ) ->
            let
                dropdownMenuState =
                    if model.dropdownMenuState == ThemeSelectOpen then
                        AllClosed

                    else
                        ThemeSelectOpen
            in
            ( { model | dropdownMenuState = dropdownMenuState }
            , Cmd.none
            , SharedState.NoUpdate
            )

        ( ToggleMenu, _ ) ->
            ( { model | toggleMenuState = not model.toggleMenuState }
            , Cmd.none
            , SharedState.NoUpdate
            )

        ( _, _ ) ->
            -- message arrived for the wrong page. Ignore.
            ( model, Cmd.none, SharedState.NoUpdate )


updateWith :
    (subModel -> Page)
    -> (subMsg -> Msg)
    -> Model
    -> ( subModel, Cmd subMsg, SharedStateUpdate )
    -> ( Model, Cmd Msg, SharedStateUpdate )
updateWith toPage toMsg model ( subModel, subCmd, subSharedStateUpdate ) =
    ( { model | currentPage = toPage subModel }
    , Cmd.map toMsg subCmd
    , subSharedStateUpdate
    )


navigateTo : Route -> SharedState -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
navigateTo route sharedState model =
    case route of
        Home ->
            Home.init |> initWith HomePage HomeMsg model SharedState.NoUpdate

        Showroom ->
            Showroom.init |> initWith ShowroomPage ShowroomMsg model SharedState.NoUpdate

        NotFound ->
            NotFound.init |> initWith NotFoundPage NotFoundMsg model SharedState.NoUpdate


initWith : (subModel -> Page) -> (subMsg -> Msg) -> Model -> SharedStateUpdate -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg, SharedStateUpdate )
initWith toPage toMsg model sharedStateUpdate ( subModel, subCmd ) =
    ( { model | currentPage = toPage subModel }
    , Cmd.map toMsg subCmd
    , sharedStateUpdate
    )
