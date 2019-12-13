module Bot.Behavior where

import Prelude
import Effect.Aff (Aff, Milliseconds(..), delay)
import Data.Int (toNumber)
import Data.Maybe (fromMaybe)
import Bot.State (withState, StateHandler, ST)
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
import Adventure.Position (distanceE)
import Bot.Locations (npcPotionsPos, huntingGroundsPos)
import Adventure.Log (log)
import Bot.Task (Task(..))

potionsTarget :: Number
potionsTarget = 1000.0

decideCourseOfAction :: ST -> Aff ST
decideCourseOfAction st
  | st.task == Hunting = do
    char <- character
    let
      mCount = fromMaybe 0 $ itemCount "mpot0" char

      hCount = fromMaybe 0 $ itemCount "hpot0" char
    if (toNumber mCount < (potionsTarget / 2.0) || toNumber hCount < (potionsTarget / 2.0)) then
      pure $ st { task = Restocking }
    else
      pure $ st { task = Hunting }

decideCourseOfAction st = pure st

restock :: StateHandler
restock st = do
  char <- character
  log ("Have " <> show char.gold <> " gold")
  xmove npcPotionsPos
  let
    mCount = fromMaybe 0 $ itemCount "mpot0" char

    hCount = fromMaybe 0 $ itemCount "hpot0" char
  if ((distanceE npcPotionsPos char) < 10.0) then do
    _ <- buy "mpot0" (potionsTarget - toNumber mCount)
    _ <- buy "hpot0" (potionsTarget - toNumber hCount)
    pure $ st { task = Hunting }
  else do
    pure $ st

hunt :: StateHandler
hunt st = do
  char <- character
  if distanceE huntingGroundsPos char > 200.0 then do
    xmove huntingGroundsPos
  else do
    closest <- getNearestMonster'
    move closest
    whenM (canAttackMonster closest)
      $ attackMonster closest
    when (char.mp < char.max_mp * 0.20) $ use' "use_mp"
    when (char.hp < char.max_hp * 0.80) $ use' "use_hp"
    loot'
  pure st

taskDispatch :: Task -> StateHandler
taskDispatch task = case task of
  Restocking -> restock
  Hunting -> hunt

tick :: Aff Unit
tick = do
  withState
    $ \st -> do
        log ("Dispatching on task " <> show st.task)
        nst <- taskDispatch st.task st
        nst' <- decideCourseOfAction nst
        pure nst'
  delay $ Milliseconds 1000.0
  tick

runBot :: Aff Unit
runBot = do
  tick
  pure unit
