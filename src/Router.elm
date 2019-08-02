module Router exposing (DropdownMenuState(..), Model, Msg(..), Page(..), init, initWith, navigateTo, update, updateWith)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Modules.Home.Types as Home
import Modules.NotFound.Types as NotFound
import Modules.Showroom.Types as Showroom
import Routes exposing (Route(..))
import SharedState exposing (SharedState, SharedStateUpdate)
import Task
import UiFramework.Configuration exposing (ThemeConfig)
import Url


type Page
    = HomePage Home.Model
    | ShowroomPage Showroom.Model
    | NotFoundPage NotFound.Model


type Msg
    = UrlChanged Url.Url
    | NavigateTo Route
    | HomeMsg Home.Msg
    | ShowroomMsg Showroom.Msg
    | NotFoundMsg NotFound.Msg
    | SelectTheme ThemeConfig
    | ToggleDropdown
    | ToggleMenu
    | NoOp


type alias Model =
    { route : Routes.Route
    , currentPage : Page
    , navKey : Nav.Key
    , dropdownMenuState : DropdownMenuState
    , toggleMenuState : Bool
    }


type DropdownMenuState
    = AllClosed
    | ThemeSelectOpen



-- init with the NotFoundPage, but send a command where we look at th Url and change the page


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

        ( SelectTheme themeConfig, _ ) ->
            ( { model | dropdownMenuState = AllClosed }
            , Cmd.none
            , SharedState.UpdateTheme themeConfig
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
