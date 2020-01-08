module Main exposing (main)


import Bool.Extra exposing (toString)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (lazy)
import Http
import Json.Decode as Decode exposing (Decoder, bool, field, int, map3, string)


-- MODEL
type alias Entry =
    { name: String
    , completed: Bool
    , id : Int
    }


type alias Model =
    { entries : List Entry
    , field: String
    , visibility: String
    , uid : Int
    , errorMessage : Maybe String
    }


initialModel : Model
initialModel =
    { entries = []
    , field = ""
    , visibility = "All"
    , uid = 0
    , errorMessage = Nothing
    }


init : () -> ( Model, Cmd Msg )
init _ =
   ( initialModel, fetchTodos )


-- UPDATE
type Msg
    = NoOp
    | CreateTodo
    | UpdateField String
    | SendHttpRequest
    | DataReceived (Result Http.Error (List Entry))


url : String
url = "http://localhost:8080"


fetchTodos : Cmd Msg
fetchTodos =
    Http.get
        { url = url ++ "/todos"
        , expect =
             Http.expectJson DataReceived (Decode.list entryDecoder)
        }


entryDecoder : Decoder Entry
entryDecoder =
    Decode.map3 Entry
        (field "name" string)
        (field "completed" bool)
        (field "id" int)


newEntry : String -> Bool -> Int -> Entry
newEntry desc completed id =
    { name = desc
    , completed = completed
    , id = id
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
             ( model, Cmd.none )

        CreateTodo ->
             ( { model
                | uid = model.uid + 1
                , entries =
                    if String.isEmpty model.field then
                        model.entries
                    else
                        model.entries ++ [ newEntry model.field False model.uid ]
                , field = ""
             }, Cmd.none )

        UpdateField str ->
             ( { model | field = str }, Cmd.none )

        SendHttpRequest ->
            ( model, fetchTodos )

        DataReceived (Ok entries) ->
            ( { model
                | entries = entries
                , errorMessage = Nothing
              }
            , Cmd.none
            )

        DataReceived (Err httpError) ->
            ( { model
                | errorMessage = Just (buildErrorMessage httpError)
              }
            , Cmd.none
            )


buildErrorMessage : Http.Error -> String
buildErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message

        Http.Timeout ->
            "Server is taking too long to respond."

        Http.NetworkError ->
            "Unable to reach server."

        Http.BadStatus statusCode ->
            "Request failed with status code: " ++ String.fromInt statusCode

        Http.BadBody message ->
            message


-- VIEW
view : Model -> Html Msg
view model =
    div [ class "wrapper"
        ]
        [ div [ class "todo-app"]
            [ lazy viewInput model.field
            , lazy viewEntriesOrError model
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
        , button [ onClick CreateTodo ] [ text "Submit" ]
        ]


viewEntriesOrError : Model -> Html Msg
viewEntriesOrError model =
    case model.errorMessage of
        Just message ->
            viewError message

        Nothing ->
            viewEntries model.entries


viewError : String -> Html Msg
viewError errorMessage =
    let errorHeading =
            "Couldn't fetch todos."
    in
        div []
            [ h3 [] [ text errorHeading ]
            , text ("Error: " ++ errorMessage )
            ]



viewEntries : List Entry -> Html Msg
viewEntries entries =
    div
        [ class "view-entries" ]
        [ h3 [] [ text "Todos" ]
        , table [ class "todo-list" ]
            ( [ viewTableHeader ] ++ List.map viewEntry entries )
        ]


viewTableHeader : Html Msg
viewTableHeader =
    tr []
        [ th []
            [ text "Task" ]
        , th []
            [ text "Completed" ]
        ]


viewEntry : Entry -> Html Msg
viewEntry entry =
    tr []
        [ td []
            [ text entry.name ]
        , td []
            [ text (toString entry.completed) ]
        ]


-- MAIN
main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , subscriptions = \_ -> Sub.none
        , update = update
        }
