module Main where

import Prelude

import Adventure.Log (log)
import Bot.Behavior (runBot)
import Effect (Effect)
import Effect.Aff (launchAff_)

main :: Effect Unit
main =
  launchAff_ do
    log "Hello from PureScript"
    runBot
