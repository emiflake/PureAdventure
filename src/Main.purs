module Main where

import Prelude
import Effect (Effect)
import Adventure
  ( getNearestMonster'
  , moveTo
  , attackMonster
  , loot'
  , canAttackMonster
  , character
  , use'
  , PlayerT(..)
  )
-- import Adventure.Log (logShow)
-- import Adventure.Position (getPosition, (^-^))
import Effect.Timer (setInterval)

main :: Effect Unit
main = do
  _ <-
    setInterval 2000
      $ do
          PlayerT char <- character
          closest <- getNearestMonster'
          moveTo closest
          whenM (canAttackMonster closest)
            $ attackMonster closest
          when (char.mp < char.max_mp * 0.20) $ use' "use_mp"
          when (char.hp < char.max_hp * 0.20) $ use' "use_hp"
          loot'
  pure unit
