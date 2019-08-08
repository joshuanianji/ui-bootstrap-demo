module Modules.Showroom.Types exposing (Context, Model, Msg(..), UiElement, init, update)

import Browser.Navigation as Navigation
import Routes exposing (Route)
import SharedState exposing (SharedState, SharedStateUpdate(..), Theme)
import UiFramework exposing (UiContextual, WithContext)
import UiFramework.Pagination exposing ( PaginationState)



-- UIFRAMEWORK TYPE


type alias UiElement msg =
    WithContext Context msg



{-| the ui Bootstrap defines three default fields, as defined in the source code.

(from UiFramework.Internal)
type alias UiContextual context =
    { context
        | device : Device
        , themeConfig : ThemeConfig
        , parentRole : Maybe Role
    }

If we need more, we need to define them ourselves in this Context type, which will be added on to the context in our Modules.Showroom.View module.

-}


type alias Context =
    { theme : Theme
    , state : PaginationState }



-- MODEL


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )


type Msg
    = NoOp
    | PaginationMsg Int


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none, NoUpdate )

        PaginationMsg int ->
            ( model, Cmd.none, NoUpdate)
