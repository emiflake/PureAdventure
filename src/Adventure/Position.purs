module Adventure.Position where

import Prelude (($), (*), (+), (-))
import Math (sqrt)

type PositionE e
  = { x :: Number, y :: Number | e }

type Position
  = PositionE ()

distance :: Position -> Position -> Number
distance = distanceE

distanceE :: forall a b. PositionE a -> PositionE b -> Number
distanceE a b = let sqr x = x * x in sqrt $ (sqr $ a.x - b.x) + (sqr $ a.y - b.y)
