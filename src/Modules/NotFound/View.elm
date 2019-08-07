module Modules.NotFound.View exposing (view)

import Element exposing (Element)
import Modules.NotFound.Types exposing (Model, Msg(..))
import SharedState exposing (SharedState)


view : SharedState -> Model -> Element Msg
view sharedState model =
    Element.text "Not found lol"
