module Modules.Showroom.Table exposing (table)

import Element
import Modules.Showroom.Types exposing (Msg(..), UiElement)
import UiFramework
import UiFramework.Table as Table
import UiFramework.Typography as Typography
import Element.Font as Font


text : String -> UiElement Msg
text str =
    UiFramework.uiText (\_ -> str)


table =
    Table.simpleTable
        |> Table.withColumns tableColumn
        |> Table.view information



-- specifies how to render each column


tableColumn =
    [ { head = text "Role"
      , viewData = \data -> UiFramework.uiParagraph [Font.bold] [text data.role]
      }
    , { head = text "Column 1"
      , viewData = \data ->  UiFramework.uiParagraph  [] [text data.column1]
      }
    , { head = text "Column 2"
      , viewData = \data ->  UiFramework.uiParagraph  [] [text data.column2]
      }
    , { head = text "Column 3"
      , viewData = \data ->  UiFramework.uiParagraph  [] [text data.column3]
      }
    ]


type alias Info =
    { role : String
    , column1 : String
    , column2 : String
    , column3 : String
    }


information : List Info
information =
    [ { role = "Row 1"
      , column1 = "column 1"
      , column2 = "column 2"
      , column3 = "column 3"
      }
    , { role = "Row 2"
      , column1 = "column 1"
      , column2 = "column 2"
      , column3 = "column 3"
      }
    , { role = "Row 3"
      , column1 = "column 1"
      , column2 = "column 2"
      , column3 = "column 3"
      }
    , { role = "Row 4"
      , column1 = "column 1"
      , column2 = "column 2"
      , column3 = "column 3"
      }
    ]
