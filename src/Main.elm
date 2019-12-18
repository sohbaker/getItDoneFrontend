module Main exposing (main)


import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Keyed as Keyed
import Html.Lazy exposing (lazy)


-- MODEL
type alias Model =
    { entries : List Entry
    , field: String
    , visibility: String
    , uuid : Int
    }

type alias Entry =
    { name: String
    , completed: Bool
    , id : Int
    }

newEntry : String -> Int -> Entry
newEntry desc id =
    { name = desc
    , completed = False
    , id = id
    }

init : Model
init =
        { entries = []
        , field = ""
        , visibility = "All"
        , uuid = 0
        }

-- UPDATE
type Msg
    = NoOp
    | Add
    | UpdateField String

update : Msg -> Model ->  Model
update msg model =
    case msg of
        NoOp ->
             model

        Add ->
             { model
                | uuid = model.uuid + 1
                , entries =
                    if String.isEmpty model.field then
                        model.entries
                    else
                        model.entries ++ [ newEntry model.field model.uuid ]
                , field = ""
             }

        UpdateField str ->
             { model | field = str }

-- VIEW
view : Model -> Html Msg
view model =
    div [ class "wrapper"
        ]
        [ div [ class "todo-app"]
            [ lazy viewInput model.field
            , lazy viewEntries model.entries
            ]
        ]

viewInput : String -> Html Msg
viewInput task =
    header [ class "header" ]
        [ h1 [] [ text "To Do List" ]
        , input
            [ class "new-todo-item"
            , placeholder "What needs to be done?"
            , size 50
            , autofocus True
            , value task
            , name "newTodoItem"
            , onInput UpdateField
            ]
            []
        , button [ onClick Add ] [ text "Submit" ]
        ]

viewEntries : List Entry -> Html Msg
viewEntries entries =
    div
        [ class "all-entries" ]
        [ Keyed.ul [ class "todo-list" ] <|
            List.map viewKeyedEntry entries
        ]

viewKeyedEntry : Entry -> ( String, Html Msg )
viewKeyedEntry todo =
    ( String.fromInt todo.id, lazy viewEntry todo )

viewEntry : Entry -> Html Msg
viewEntry todo =
    li
        []
        [ div
            [ class "view" ]
            [ label
                []
                [ text todo.name ]
            ]
        ]

main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }
