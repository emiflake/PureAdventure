module Bot.State where

{-
    This module is responsible for handling
    the Bot state. No actions will be handled here.
    It is singly responsible for all information the bot
    may hold.
-}
import Prelude (Unit, bind, discard, pure)

import Adventure.Store (storeGet, storeSet)
import Adventure.Position (Position)
import Bot.Task (Task(..))
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)

type ST
  = { task :: Task
    , counter :: Number
    , lastHuntingPos :: Maybe Position
    }

initHuntingPos :: Maybe Position
initHuntingPos = Nothing

initialState :: ST
initialState =
  { task: Hunting Nothing
  , counter: 0.0
  , lastHuntingPos: initHuntingPos
  }

storeState :: ST -> Aff Unit
storeState = storeSet "state"

getState :: Aff ST
getState = do
  st <- storeGet "state"
  case st of
    Nothing -> do
      storeState initialState
      pure initialState
    Just st' -> pure st'

type StateHandler = (ST -> Aff ST)

withState :: (ST -> Aff ST) -> Aff Unit
withState f = do
  st <- getState
  res <- f st
  storeState res
