module Adventure.Graphics where

import Prelude (Unit)
import Effect (Effect)
import Effect.Aff (Aff)
import Data.Int (toNumber)
import Effect.Class (liftEffect)
import Adventure.Position (Position)

foreign import ffi_draw_line :: Position -> Position -> Number -> Number -> Effect Unit

drawLine :: Position -> Position -> Int -> Int -> Aff Unit
drawLine a b size color = liftEffect (ffi_draw_line a b (toNumber size) (toNumber color))

foreign import ffi_clear_drawings :: Effect Unit

clearDrawings :: Aff Unit
clearDrawings = liftEffect ffi_clear_drawings
