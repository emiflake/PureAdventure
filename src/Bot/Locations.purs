module Bot.Locations where

import Prelude (negate, ($))

import Adventure.Position (Position)
import Data.Map (Map, fromFoldable)
import Data.Tuple (Tuple(..))

npcPotionsPos :: Position
npcPotionsPos = { x: 56.0, y: -122.0 }

gooPos :: Position
gooPos = { x: 0.0, y: 800.0 }

positions :: Map String Position
positions = fromFoldable $ [
    Tuple "goos" gooPos
  , Tuple "npcs" npcPotionsPos
  ]
