module Bot.Behavior where

import Prelude
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
import Adventure.Log (log)
import Adventure.Position (Position, distanceE)
import Adventure.Graphics (drawLine, clearDrawings)
import Bot.Locations (npcPotionsPos, huntingGroundsPos)
import Bot.State (withState, StateHandler, ST)
import Bot.Task (Task(..))
import Data.Int (toNumber)
import Data.Maybe (Maybe(..), fromMaybe)
import Effect.Aff (Aff, Milliseconds(..), delay)

potionsTarget :: Number
potionsTarget = 1000.0

decideCourseOfAction :: ST -> Aff ST
decideCourseOfAction st = case st.task of
  Hunting (hPosMay) -> do
    char <- character
    let
      mCount = fromMaybe 0 $ itemCount "mpot0" char

      hCount = fromMaybe 0 $ itemCount "hpot0" char
    if (toNumber mCount < (potionsTarget / 2.0) || toNumber hCount < (potionsTarget / 2.0)) then
      pure $ st { task = Restocking }
    else
      pure $ st { task = Hunting hPosMay }
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
    _ <- buy "mpot0" (potionsTarget - toNumber mCount)
    _ <- buy "hpot0" (potionsTarget - toNumber hCount)
    pure $ st { task = Hunting st.lastHuntingPos }
  else do
    pure $ st

hunt :: Maybe Position -> StateHandler
hunt hPosMay st = do
  char <- character
  case hPosMay of
    Just hPos
      | distanceE hPos char > 200.0 -> do
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
  pure $ st { task = Hunting st.lastHuntingPos }

taskDispatch :: Task -> StateHandler
taskDispatch task = case task of
  Restocking -> restock
  Hunting hPosMay -> hunt hPosMay

tick :: Aff Unit
tick = do
  withState
    $ \st -> do
        -- clearDrawings
        -- drawLine { x: 0.0, y: 0.0 } { x: 1000.0, y: 1000.0 } 1 0xFFFFFF
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
