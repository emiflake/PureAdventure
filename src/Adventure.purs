module Adventure where

import Prelude (Unit)
-- import Adventure.Log (logShow)
import Effect (Effect)
import Data.Maybe (Maybe(..))

type Player
  = { name :: String
    , hp :: Number
    , max_hp :: Number
    , mp :: Number
    , max_mp :: Number
    , level :: Number
    , x :: Number
    , y :: Number
    }

foreign import ffi_get_player :: String -> Effect Player

getPlayer :: String -> Effect Player
getPlayer = ffi_get_player

foreign import ffi_character :: Effect Player

character :: Effect Player
character = ffi_character

type Monster
  = { name :: String
    , id :: String
    , hp :: Number
    , level :: Number
    , x :: Number
    , y :: Number
    }

type NearestMonsterArgs
  = {}

foreign import ffi_get_nearest_monster :: NearestMonsterArgs -> Effect Monster

getNearestMonster :: NearestMonsterArgs -> Effect Monster
getNearestMonster = ffi_get_nearest_monster

getNearestMonster' :: Effect Monster
getNearestMonster' = getNearestMonster {}

type AttackTarget r
  = { id :: String
    | r
    }

foreign import ffi_attack :: forall r. AttackTarget r -> Effect Unit

foreign import ffi_can_attack :: forall r. AttackTarget r -> Effect Boolean

attackMonster :: forall r. AttackTarget r -> Effect Unit
attackMonster = ffi_attack

canAttackMonster :: forall r. AttackTarget r -> Effect Boolean
canAttackMonster = ffi_can_attack

foreign import ffi_smart_move :: forall r. { x :: Number, y :: Number | r } -> Effect Unit

foreign import ffi_move :: Number -> Number -> Effect Unit

move ::
  forall r.
  { x :: Number, y :: Number | r } ->
  Effect Unit
move p = ffi_move p.x p.y

smartMove ::
  forall r.
  { x :: Number, y :: Number | r } ->
  Effect Unit
smartMove = ffi_smart_move

foreign import ffi_loot :: Boolean -> Effect Unit

loot' :: Effect Unit
loot' = ffi_loot false

type UseTarget
  = Player

foreign import ffi_use :: String -> Maybe UseTarget -> Effect Unit

use' :: String -> Effect Unit
use' name = ffi_use name Nothing

foreign import ffi_find_npc ::
  String ->
  Effect
    ( Maybe
        { x :: Number
        , y :: Number
        }
    )

findNPC ::
  String ->
  Effect
    ( Maybe
        { x :: Number
        , y :: Number
        }
    )
findNPC = ffi_find_npc
