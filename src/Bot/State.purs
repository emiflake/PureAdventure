module Bot.State where

{-
    This module is responsible for handling
    the Bot state. No actions will be handled here.
    It is singly responsible for all information the bot
    may hold.
-}
import Prelude (Unit, bind, discard, not, pure, ($), (<>))

import Adventure (character)
import Adventure.Store (storeGet, storeSet)
import Adventure.Position (Position)
import Bot.Task (Task(..))
import Control.Applicative (when)
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)

type ST
  = { task :: Task
    , counter :: Number
    , lastHuntingPos :: Maybe Position
    , interrupted :: Boolean
    }

initHuntingPos :: Maybe Position
initHuntingPos = Nothing

initialState :: ST
initialState =
  { task: Hunting Nothing
  , counter: 0.0
  , lastHuntingPos: initHuntingPos
  , interrupted: false
  }

stateKey :: Aff String
stateKey = do
  char <- character
  pure $ "PureAdventure_" <> char.name <> "_state"

storeState :: ST -> Aff Unit
storeState st = do
  sKey <- stateKey
  storeSet sKey st

getState :: Aff ST
getState = do
  sKey <- stateKey
  st <- storeGet sKey
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

-- | Checks if interrupt is in progress before writing state.
withStateSafe :: (ST -> Aff ST) -> Aff Unit
withStateSafe f = do
  st <- getState
  res <- f st
  st' <- getState
  when (not st'.interrupted) $ storeState res
