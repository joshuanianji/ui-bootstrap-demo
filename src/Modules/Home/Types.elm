module Modules.Home.Types exposing (Model, Msg(..), init, update)

import SharedState exposing (SharedState, SharedStateUpdate)
import UiFramework.Configuration exposing (ThemeConfig)
import Browser.Navigation as Navigation
import Routes exposing (Route)


type alias Model =
    {}


type Msg
    = NoOp
    | NavigateTo Route


init : ( Model, Cmd Msg )
init =
    ( {}
    , Cmd.none
    )


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NavigateTo route ->
            ( model, Navigation.pushUrl sharedState.navKey (Routes.toUrlString route), SharedState.NoUpdate  )
        
        NoOp ->
            ( model, Cmd.none, SharedState.NoUpdate )
