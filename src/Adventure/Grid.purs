module Adventure.Grid where

import Prelude (pure, ($), bind, (<<<))
import Data.Map as Map
import Effect.Aff (Aff)
import Effect (Effect)
import Effect.Class (liftEffect)

type MapSize
  = { minX :: Number
    , minY :: Number
    , maxX :: Number
    , maxY :: Number
    }

type Grid
  = { map :: Map.Map { x :: Number, y :: Number } Boolean
    , size :: MapSize
    , gridfindingOpts :: GridfindingOpts -- Options we used to find Grid with
    }

type GridfindingOpts
  = { nodeRadius :: Number
    , world :: String
    }

type Line
  = { pos :: Int
    , min :: Int
    , max :: Int
    }

foreign import ffi_x_lines :: String -> Effect (Array Line)

foreign import ffi_y_lines :: String -> Effect (Array Line)

foreign import ffi_map_size :: String -> Effect MapSize

getXLines :: String -> Aff (Array Line)
getXLines = liftEffect <<< ffi_x_lines

getYLines :: String -> Aff (Array Line)
getYLines = liftEffect <<< ffi_x_lines

getMapSize :: String -> Aff MapSize
getMapSize = liftEffect <<< ffi_map_size

defaultGridFindingOpts :: GridfindingOpts
defaultGridFindingOpts =
  { nodeRadius: 9.0
  , world: "main"
  }

findGridDefault :: String -> Aff Grid
findGridDefault name = findGrid $ defaultGridFindingOpts { world = name }

-- TODO: implement
constructGrid :: MapSize -> Array Line -> Array Line -> Map.Map { x :: Number, y :: Number } Boolean
constructGrid mapSize xLines yLines = Map.empty

findGrid :: GridfindingOpts -> Aff Grid
findGrid args = do
  xLines <- getXLines args.world
  yLines <- getYLines args.world
  mapSize <- getMapSize args.world
  pure
    { gridfindingOpts: args
    , map: constructGrid mapSize xLines yLines
    , size: mapSize
    }
