module Modules.Showroom.View exposing (view)

import Element exposing (Element)
import Modules.Showroom.Types exposing (Model, Msg(..))
import SharedState exposing (SharedState)


view : SharedState -> Model -> Element Msg
view sharedState model =
    Element.text "Showroom"
