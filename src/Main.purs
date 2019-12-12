module Main where

import Prelude
import Effect (Effect)
import Bot.Behavior (runBot)
import Adventure.Log (log)

main :: Effect Unit
main = do
  log "Hello from PureScript"
  runBot
