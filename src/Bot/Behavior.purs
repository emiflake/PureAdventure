module Bot.Behavior where

import Prelude
import Effect (Effect)
import Bot.State (withState, StateHandler)
import Adventure
  ( getNearestMonster'
  , move
  , attackMonster
  , loot'
  , canAttackMonster
  , character
  , use'
  )
import Adventure.Log (log, logShow)
import Effect.Timer (setInterval, IntervalId)
import Bot.Task (Task(..))

taskDispatch :: Task -> StateHandler
taskDispatch _ = \st -> do
  char <- character
  closest <- getNearestMonster'
  move closest
  whenM (canAttackMonster closest)
    $ attackMonster closest
  when (char.mp < char.max_mp * 0.20) $ use' "use_mp"
  when (char.hp < char.max_hp * 0.20) $ use' "use_hp"
  loot'
  pure st

botTimer :: Effect IntervalId
botTimer = do
  setInterval 1000
    $ do
        withState
          $ \st -> do
              log $ "Dispatching on Task " <> show st.task
              taskDispatch st.task st

runBot :: Effect Unit
runBot = do
  _ <- botTimer
  pure unit
