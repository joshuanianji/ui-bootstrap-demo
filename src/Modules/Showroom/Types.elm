module Modules.Showroom.Types exposing (Model, Msg(..), init, update, UiElement, Context)

import Browser.Navigation as Navigation
import UiFramework exposing (UiContextual, WithContext)
import Routes exposing (Route)
import SharedState exposing (SharedState, SharedStateUpdate(..))


-- UIFRAMEWORK TYPE


type alias UiElement msg =
    WithContext Context msg


type alias Context =
    {}


-- MODEL 

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
