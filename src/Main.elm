module Main exposing (main)


import Html exposing (..)
import Html.Attributes exposing (..)


type alias Model =
    { entries : List Entry
    , uuid : Int
    }

type alias Entry =
    { name: String
    , completed: Bool
    , id : Int
    }

main =
    div []
        [ h1 [] [ text "Welcome to To Do List" ]
        , Html.form []
            [ label []
                 [  text "What needs to be done?"
                 , input [type_ "text", name "todo" ] []
                 ]
            ]
        ]


