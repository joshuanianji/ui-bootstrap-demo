module Modules.Home.Types exposing (Model, Msg(..), init, update)

import SharedState exposing (SharedState, SharedStateUpdate)
import UiFramework.Configuration exposing (ThemeConfig)


type alias Model =
    {}


type Msg
    = NoOp


init : ( Model, Cmd Msg )
init =
    ( {}
    , Cmd.none
    )


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none, SharedState.NoUpdate )
