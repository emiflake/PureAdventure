module Main where

import Prelude
import Effect (Effect)
import Adventure (getPlayer, getNearestMonster')
import Adventure.Log (logShow)
import Effect.Timer (setInterval)

main :: Effect Unit
main = do
    _ <- setInterval 1000 $ do
        player <- getPlayer "PureAlpha"
        nearest <- getNearestMonster'
        
        logShow nearest
        pure unit
    pure unit