module Bot.Behavior where

import Prelude (
    Unit
  , bind
  , discard
  , div
  , pure
  , show
  , unit
  , when
  , whenM
  , ($), (*), (-), (<), (<>), (>), (||)
  )
import Adventure
  ( getNearestMonster'
  , move
  , attackMonster
  , loot'
  , canAttackMonster
  , character
  , use'
  , itemCount
  , xmove
  , buy
  )
import Adventure.Log (dateLog, log)
import Adventure.Position (Position, distanceE)
import Bot.Locations (npcPotionsPos)
import Bot.State (withState, StateHandler, ST)
import Bot.Task (Task(..))
import Data.Maybe (Maybe(..), fromMaybe)
import Effect.Aff (Aff, Milliseconds(..), delay)

potionsTarget :: Int
potionsTarget = 1000

decideCourseOfAction :: ST -> Aff ST
decideCourseOfAction st = case st.task of
  Hunting (hPosMay) -> do
    char <- character
    let
      mCount = fromMaybe 0 $ itemCount "mpot0" char
      hCount = fromMaybe 0 $ itemCount "hpot0" char
    if (mCount < (potionsTarget `div` 2) || hCount < (potionsTarget `div` 2)) then do
      log "Setting task to Restocking DEBUG"
      pure $ st { task = Restocking }
    else do
      log "Setting task to Hunting DEBUG"
      pure $ st { task = Hunting hPosMay}
  _ -> pure st

restock :: StateHandler
restock st = do
  char <- character
  log ("Have " <> show char.gold <> " gold")
  xmove npcPotionsPos
  let
    mCount = fromMaybe 0 $ itemCount "mpot0" char
    hCount = fromMaybe 0 $ itemCount "hpot0" char
  if ((distanceE npcPotionsPos char) < 10.0) then do
    _ <- buy "mpot0" (potionsTarget - mCount)
    _ <- buy "hpot0" (potionsTarget - hCount)
    pure $ st { task = Hunting st.lastHuntingPos}
  else do
    pure $ st

hunt :: Maybe Position -> StateHandler
hunt hPosMay st = do
  char <- character
  case hPosMay of
    Just hPos | distanceE hPos char > 200.0 -> do
      log $ "Moving to hunting ground pos " <> (show hPos)
      xmove hPos
    _ -> do
      closest <- getNearestMonster'
      move closest
      whenM (canAttackMonster closest)
        $ attackMonster closest
      when (char.mp < char.max_mp * 0.20) $ use' "use_mp"
      when (char.hp < char.max_hp * 0.80) $ use' "use_hp"
      loot'
  pure $ st { task = Hunting st.lastHuntingPos}

taskDispatch :: Task -> StateHandler
taskDispatch task = case task of
  Restocking -> restock
  Hunting hPosMay -> hunt hPosMay

tick :: Aff Unit
tick = do
  dateStr <- dateLog
  withState
    $ \st -> do
        log $ "Dispatching on task " <> show st.task
          <> " at " <> dateStr
        nst <- taskDispatch st.task st
        nst' <- decideCourseOfAction nst
        log $ "DEBUG: new task state is " <> (case nst'.task of
          Restocking -> "Restocking"
          Hunting _ -> "Hunting"
        )
        pure nst'
  delay $ Milliseconds 1000.0
  tick

runBot :: Aff Unit
runBot = do
  tick
  pure unit
