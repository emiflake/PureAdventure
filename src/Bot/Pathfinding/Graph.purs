module Bot.Pathfinding.Graph where

import Prelude
import Adventure.Position (Position, PositionE, distanceE)
import Adventure.Grid (Grid)
import Data.Foldable (minimumBy)
import Data.Maybe (Maybe)

-- Potential types
type Graph t
  = Unit -- TODO

type Path p
  = { start :: p
    , path :: Array p
    , end :: p
    }

{-
    TODO: Implement graph system for pathfinding

    Potential API:
-}
-- TODO
createGraph :: Grid -> Graph Position
createGraph _ = unit

-- TODO
dfs :: forall a. a -> a -> Graph a -> Path a
dfs start end _ = { start, end, path: [] }

closest :: forall e. PositionE e -> Array Position -> Maybe Position
closest p = minimumBy (comparing (distanceE p))
