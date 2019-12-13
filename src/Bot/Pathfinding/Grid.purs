module Bot.Pathfinding.Grid where

import Prelude
import Data.Map as Map
import Adventure.Position
import Effect.Aff (Aff)

type Grid
  = { map :: Map.Map { x :: Number, y :: Number } Unit
    , gridfindingOpts :: GridfindingOpts -- Options we used to find Grid with
    }

type GridfindingOpts
  = { nodeRadius :: Number
    , world :: String
    , startingPoint :: Position
    , maxDistance :: Number
    }

defaultGridFindingOpts :: GridfindingOpts
defaultGridFindingOpts =
  { nodeRadius: 9.0
  , world: "main"
  , startingPoint: { x: 0.0, y: 0.0 }
  , maxDistance: 5000.0
  }

findGridDefault :: String -> Aff Grid
findGridDefault name = findGrid $ defaultGridFindingOpts { world = name }

-- TODO: implement
-- This will be an expensive function, use sparingly
findGrid :: GridfindingOpts -> Aff Grid
findGrid args =
  pure
    $ { gridfindingOpts: args
      , map: Map.empty
      }
