module Bot.Locations where

import Prelude (negate, ($))

import Adventure.Position (Position)
import Data.Map (Map, fromFoldable)
import Data.Tuple (Tuple(..))

crabPos :: Position
crabPos = { x: -1073.0, y: -214.5 }

gooPos :: Position
gooPos = { x: 26.0, y: 817.0 }

npcPotionsPos :: Position
npcPotionsPos = { x: 56.0, y: -122.0 }

positions :: Map String Position
positions = fromFoldable $ [
    Tuple "crabs" crabPos
  , Tuple "goos" gooPos
  , Tuple "npcs" npcPotionsPos
  ]
