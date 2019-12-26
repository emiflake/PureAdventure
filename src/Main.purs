module Main where

import Prelude

import Adventure.Log (log)
import Bot.Behavior (runBot)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)

main :: Effect Unit
main =
  launchAff_ do
    log "Hello from PureScript"
    _ <- handle_command "foo" ["bar", "baz"]
    runBot

handle_command :: String -> Array String -> Aff Boolean
handle_command cmd args = do
  log $ (show cmd) <> (show args)
  pure true