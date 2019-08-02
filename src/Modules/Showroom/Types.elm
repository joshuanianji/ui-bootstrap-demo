module Modules.Showroom.Types exposing (Model, Msg(..), init, update)

import Browser.Navigation as Navigation
import Routes exposing (Route)
import SharedState exposing (SharedState, SharedStateUpdate(..))


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )


type Msg
    = NoOp


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none, NoUpdate )
