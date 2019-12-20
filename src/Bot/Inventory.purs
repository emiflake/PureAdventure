module Bot.Inventory where

import Prelude (($))
import Adventure
  ( Player
  , itemCount
  )

import Data.Maybe (Maybe(..), fromMaybe)

mpPotCount :: Player -> Int
mpPotCount char = fromMaybe 0 $ itemCount "mpot0" char

hpPotCount :: Player -> Int
hpPotCount char = fromMaybe 0 $ itemCount "hpot0" char