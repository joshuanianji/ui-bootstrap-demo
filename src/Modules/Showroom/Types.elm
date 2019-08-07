module Modules.Showroom.Types exposing (Context, Model, Msg(..), UiElement, init, update)

import Browser.Navigation as Navigation
import Routes exposing (Route)
import SharedState exposing (SharedState, SharedStateUpdate(..), Theme)
import UiFramework exposing (UiContextual, WithContext)



-- UIFRAMEWORK TYPE


type alias UiElement msg =
    WithContext Context msg



-- add in theme to the Context


type alias Context =
    { theme : Theme }



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
