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
  , ($), (+), (*), (-), (<), (<>), (>), (||)
  )
import Adventure
  ( Player
  , getNearestMonster'
  , move
  , attackMonster
  , loot'
  , canAttackMonster
  , character
  , playerPos
  , random
  , use'
  , xmove
  , buy
  )
import Adventure.Log (dateLog, log)
import Adventure.Position (Position, distanceE)
import Bot.Inventory (hpPotCount, mpPotCount)
import Bot.Locations (gooPos, npcPotionsPos)
import Bot.State (withState, StateHandler)
import Bot.Task (Task(..))
import Data.Maybe (Maybe(..))
import Data.Maybe.First (First(..))
import Data.Newtype (unwrap)
import Effect.Aff (Aff, Milliseconds(..), delay)

potionsTarget :: Int
potionsTarget = 1000

shouldRestock :: Player -> Boolean
shouldRestock char =
      mpPotCount char < (potionsTarget `div` 2)
   || hpPotCount char < (potionsTarget `div` 2)

restock :: StateHandler
restock st = do
  char <- character
  log ("Have " <> show char.gold <> " gold")
  xmove npcPotionsPos
  let
    potsDist = distanceE npcPotionsPos char
  if (potsDist < 10.0) then do
    _ <- buy "mpot0" (potionsTarget - mpPotCount char)
    _ <- buy "hpot0" (potionsTarget - hpPotCount char)
    pure $ st { task = Hunting st.lastHuntingPos}
  else pure st

hunt :: Maybe Position -> StateHandler
hunt hPosMay st = do
  char <- character
  st' <- case hPosMay of
    Just hPos | distanceE hPos char > 200.0 -> do
      log $ "Moving to hunting ground pos " <> (show hPos)
      xmove hPos
      pure st
    _ -> do
      closestMay <- getNearestMonster'
      st' <- case closestMay of
        Just closest -> do
          move closest
          canAttack <- canAttackMonster closest
          if (canAttack) then do
            char' <- character
            let charPosMay =  Just $ playerPos char'
            attackMonster closest
            pure $ st {
              task = Hunting charPosMay
            , lastHuntingPos = charPosMay
            }
          else pure st
        Nothing -> do
          xr <- random
          yr <- random
          let lastHPosFirst = First hPosMay <> First st.lastHuntingPos
          case unwrap lastHPosFirst of
            Just hPos -> do
              let newHPos = {x: hPos.x + xr, y: hPos.y + yr}
              move newHPos
              pure $ st {
                task = Hunting $ Just newHPos
              }
            Nothing -> do
              -- Go kills some goos, nothing else to do
              -- Later can make this a level appropriate preset
              pure $ st {
                task = Hunting $ Just gooPos
              }
      when (char.mp < char.max_mp * 0.20) $ use' "use_mp"
      when (char.hp < char.max_hp * 0.80) $ use' "use_hp"
      loot'
      pure st'
  if (shouldRestock char) then pure $ st' { task = Restocking}
  else pure st'

taskDispatch :: Task -> StateHandler
taskDispatch task = case task of
  Restocking -> restock
  Hunting hPosMay -> hunt hPosMay

tick :: Aff Unit
tick = do
  -- TODO: add a task that reads commands from the localStore for handle_command
  dateStr <- dateLog
  withState
    $ \st -> do
        log $ "Dispatching on task " <> show st.task
          <> " at " <> dateStr
        nst <- taskDispatch st.task st
        pure nst
  delay $ Milliseconds 1000.0
  tick

runBot :: Aff Unit
runBot = do
  tick
  pure unit
