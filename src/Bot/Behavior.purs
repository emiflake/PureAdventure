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
import Bot.State (getState, storeState, withState, withStateSafe, StateHandler)
import Bot.Task (Task(..))
import Data.Maybe (Maybe(..), fromMaybe, isJust)
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
  log 0 $ ("Have " <> show char.gold <> " gold")
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
      log 3 $ "Moving to hunting ground pos " <> (show hPos)
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

-- | Maps `Task` values to function calls implementing task logic
taskDispatch :: Task -> StateHandler
taskDispatch task = case task of
  Restocking -> restock
  Hunting hPosMay -> hunt hPosMay

-- | Executes the current task.
-- |
-- | Takes an optional /command task supplied by the user,
-- | which alters the existing control-flow as follows:
-- | 1. interrupt (2nd async `tick` call) means this call
-- |    should not write state.
-- | 2. 2nd `tick` call writes to interrupt flag
-- | 3. `withStateSafe` checks if it is in interrupt mode; if so,
-- |    does not modify state.
-- | 4. reset interrupted to false once interrupting call finishes
tick :: Maybe Task -> Aff Unit
tick cmdMay = do
  dateStr <- dateLog
  st0 <- getState
  st1 <- pure $ if isJust cmdMay then st0 { interrupted = true }
                else st0
  storeState st1
  let ws = if isJust cmdMay then withState else withStateSafe
  ws $ \st -> do
    let task = fromMaybe st.task cmdMay
    log 3 $ "Dispatching on task " <> show task
      <> " at " <> dateStr
    nst <- taskDispatch task st
    pure nst
  when (isJust cmdMay) do
    pst <- getState
    storeState $ pst { interrupted = false }
  delay $ Milliseconds 1000.0
  case cmdMay of
    Nothing -> tick Nothing
    _ -> pure unit -- finished the interrupt task, return

runBot :: Aff Unit
runBot = do
  tick Nothing
  pure unit
