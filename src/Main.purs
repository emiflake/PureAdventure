module Main where

import Prelude

import Adventure.Command (parseCmd)
import Adventure.Log (log, logE)
import Adventure.Store (storeSetE)
import Bot.Behavior (runBot)
import Data.Array.NonEmpty as NA
import Data.Either (Either(..))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)

main :: Effect Unit
main =
  launchAff_ do
    log "Hello from PureScript"
    -- Keep handle_command from being optimized out:
    _ <- liftEffect $ handle_command "foo" ["bar", "baz"]
    runBot

commandKey :: String
commandKey = "PureAdventureCommand"

handle_command :: String -> Array String -> Effect Boolean
handle_command cmdName args = do
  -- TODO: determine between immediate commands and commands that
  --       (may also) modify the next task, etc?
  let cmdIn = NA.cons' cmdName args
  case parseCmd cmdIn of
    Right cmd -> do
      let cmdInNE = NA.toNonEmpty $ cmdIn
      storeSetE commandKey cmdInNE -- TODO: serialize Command instead when needed
      pure true
    Left err -> do
      logE err
      pure false
