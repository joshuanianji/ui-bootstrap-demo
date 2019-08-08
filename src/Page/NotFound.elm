module Page.NotFound exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Navigation
import Element exposing (Element)
import Routes exposing (Route)
import SharedState exposing (SharedState, SharedStateUpdate(..))



-- MODEL


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



-- VIEW


view : SharedState -> Model -> Element Msg
view sharedState model =
    Element.text "bruh moment"



-- UPDATE


type Msg
    = NoOp


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none, NoUpdate )
