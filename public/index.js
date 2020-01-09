import { Elm } from '../src/Main.elm'
import '../cypress/support/commands'

Elm.Main.init({ node: document.getElementById("app") })