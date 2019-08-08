module Modules.Showroom.Pagination exposing (pagination, paginationState)

import Element exposing (Element)
import Modules.Showroom.Types exposing (Msg(..), UiElement)
import SharedState exposing (SharedState)
import UiFramework
import UiFramework.Pagination as Pagination exposing (Item(..), PaginationState)
import UiFramework.Types exposing (Role(..))


pagination : UiElement Msg
pagination =
    Pagination.default PaginationMsg
        |> Pagination.withItems paginationItems
        |> Pagination.view


paginationState =
    { numberOfSlices = 10
    , currentSliceNumber = 1 -- start from 1
    }


paginationItems =
    [ NumberItem 1
    , NumberItem 2
    , NumberItem 3
    , EllipsisItem
    , NumberItem 9
    , NumberItem 10
    ]
