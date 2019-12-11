module Adventure.Position
  ( class HasPosition
  , getPosition
  , Position(..)
  , (^-^)
  , subPos
  ) where

import Prelude (class Show, show, (-))

data Position
  = Position
    { x :: Number
    , y :: Number
    }

subPos :: Position -> Position -> Position
subPos (Position a) (Position b) = Position { x: a.x - b.x, y: a.y - b.y }

infixl 7 subPos as ^-^

class HasPosition a where
  getPosition :: a -> Position

instance showPosition :: Show Position where
  show (Position p) = show p
