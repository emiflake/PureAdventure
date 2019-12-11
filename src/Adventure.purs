module Adventure where

import Prelude
import Effect (Effect)

type Player = { name   :: String
              , hp     :: Number
              , max_hp :: Number
              , mp     :: Number
              , max_mp :: Number
              , level  :: Number
              }

foreign import ffi_get_player :: String -> Effect Player

getPlayer :: String -> Effect Player
getPlayer = ffi_get_player

type Monster = { name  :: String
               , hp    :: Number
               , level :: Number
               , x     :: Number
               , y     :: Number
               }

type NearestMonsterArgs = {}

foreign import ffi_get_nearest_monster :: NearestMonsterArgs -> Effect Monster

getNearestMonster :: NearestMonsterArgs -> Effect Monster
getNearestMonster = ffi_get_nearest_monster

getNearestMonster' :: Effect Monster
getNearestMonster' = getNearestMonster {}

type AttackTarget = Monster

foreign import ffi_attack :: AttackTarget -> Effect Unit

attack :: AttackTarget -> Effect Unit
attack = ffi_attack
