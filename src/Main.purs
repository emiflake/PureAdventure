module Main where

import Prelude

import Adventure.Command (parseCmd)
import Adventure.Log (log)
import Bot.Behavior (runBot, tick)
import Control.Promise (Promise, fromAff)
import Data.Array.NonEmpty as NA
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)

main :: Effect Unit
main =
  launchAff_ do
    log "Hello from PureScript"
    -- Keep handle_command from being optimized out:
    _ <- liftEffect $ handle_command "dummy" []
    runBot

handle_command :: String -> Array String -> Effect (Promise Boolean)
handle_command c a = fromAff $ handle_commandA c a

handle_commandA :: String -> Array String -> Aff Boolean
handle_commandA cmdName args = do
  let cmdIn = NA.cons' cmdName args
  cmd <- parseCmd cmdIn
  case cmd of
    Right task -> do
      tick $ Just task
      pure true
    Left err -> do
      log err
      pure false
