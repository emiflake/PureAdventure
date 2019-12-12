module Main where

import Prelude
import Effect (Effect)
import Bot.Behavior (runBot)
import Adventure.Log (log)
import Effect.Aff (launchAff_)

main :: Effect Unit
main =
  launchAff_ do
    log "Hello from PureScript"
    runBot
