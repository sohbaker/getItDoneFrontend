module Main exposing (main)


import Bool.Extra exposing (toString)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (lazy)
import Http
import Json.Decode as Decode exposing (Decoder, bool, field, int, map3, string)
import Json.Encode as Encode


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
    , createError : Maybe String
    }


initialModel : Model
initialModel =
    { entries = []
    , field = ""
    , visibility = "All"
    , uid = 0
    , errorMessage = Nothing
    , createError = Nothing
    }


init : () -> ( Model, Cmd Msg )
init _ =
   ( initialModel, fetchTodos )


-- UPDATE
type Msg
    = NoOp
    | CreateTodo
    | TodoCreated (Result Http.Error Entry)
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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
             ( model, Cmd.none )

        CreateTodo ->
            ( model, createTodo model )

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

        TodoCreated (Ok _) ->
            ( { model
                | uid = model.uid + 1
                , field = ""
                , createError = Nothing
            } , fetchTodos
            )

        TodoCreated (Err error) ->
            ( { model | createError = Just (buildErrorMessage error) }
            , Cmd.none
            )


createTodo : Model -> Cmd Msg
createTodo model =
    Http.post
        { url = url ++ "/todos"
        , body = Http.jsonBody (newPostEncoder model)
        , expect = Http.expectJson TodoCreated entryDecoder
        }


newPostEncoder : Model -> Encode.Value
newPostEncoder model =
    Encode.object
        [ ("name", Encode.string model.field)
        , ("completed", Encode.bool False)
        ]


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
            [ lazy viewInput model
            , lazy viewEntriesOrError model
            ]
        ]


viewInput : Model -> Html Msg
viewInput model =
    header [ class "header" ]
        [ h1 [] [ text "To Do List" ]
        , input
            [ class "new-todo-item"
            , placeholder "What needs to be done?"
            , size 50
            , autofocus True
            , value model.field
            , name "newTodoItem"
            , onInput UpdateField
            ]
            []
        , button [ onClick CreateTodo ] [ text "Submit" ]
        , viewCreateError model.createError
        ]


viewEntriesOrError : Model -> Html Msg
viewEntriesOrError model =
    case model.errorMessage of
        Just message ->
            viewFetchError message

        Nothing ->
            viewEntries model.entries


viewFetchError : String -> Html Msg
viewFetchError errorMessage =
    let errorHeading =
            "Couldn't fetch todos."
    in
        div []
            [ h3 [] [ text errorHeading ]
            , text ("Error: " ++ errorMessage )
            ]


viewCreateError : Maybe String -> Html Msg
viewCreateError maybeError =
    case maybeError of
        Just error ->
            div []
               [ h5 [] [ text "Couldn't create a todo."]
               , text (" Error: " ++ error)
               ]

        Nothing ->
            text ""



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
