module Adventure where

import Adventure.Position (Position, PositionE)
import Prelude
import Data.Int (floor)
import Data.Array (find)
import Adventure.Log (log)
import Control.Promise
import Effect (Effect)
import Effect.Aff
import Effect.Class (liftEffect)
import Data.Maybe (Maybe(..))
import Data.Functor ((<$>))
import Control.Promise (toAff)

type Item
  = { name :: String
    , quantity :: Number
    }

itemCount :: String -> Player -> Maybe Int
itemCount name player = (floor <<< (\i -> i.quantity)) <$> find (\i -> i.name == name) player.itemList

type Player
  = { name :: String
    , hp :: Number
    , max_hp :: Number
    , mp :: Number
    , max_mp :: Number
    , level :: Number
    , x :: Number
    , y :: Number
    , isize :: Number
    , esize :: Number
    , gold :: Number
    , itemList :: Array Item
    }

foreign import ffi_get_player :: String -> Effect Player

getPlayer :: String -> Effect Player
getPlayer = ffi_get_player

foreign import ffi_character :: Effect Player

character :: Aff Player
character = liftEffect ffi_character

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

getNearestMonster :: NearestMonsterArgs -> Aff Monster
getNearestMonster = liftEffect <$> ffi_get_nearest_monster

getNearestMonster' :: Aff Monster
getNearestMonster' = getNearestMonster {}

type AttackTarget r
  = { id :: String
    | r
    }

foreign import ffi_attack :: forall r. AttackTarget r -> Effect Unit

foreign import ffi_can_attack :: forall r. AttackTarget r -> Effect Boolean

attackMonster :: forall r. AttackTarget r -> Aff Unit
attackMonster = liftEffect <$> ffi_attack

canAttackMonster :: forall r. AttackTarget r -> Aff Boolean
canAttackMonster = liftEffect <$> ffi_can_attack

foreign import ffi_xmove :: forall e. PositionE e -> Effect Unit

foreign import ffi_smart_move :: forall e. PositionE e -> Effect Unit

foreign import ffi_move :: Number -> Number -> Effect Unit

move ::
  forall e.
  PositionE e ->
  Aff Unit
move p = liftEffect $ ffi_move p.x p.y

xmove ::
  forall e.
  PositionE e ->
  Aff Unit
xmove = liftEffect <$> ffi_xmove

smart_move ::
  forall e.
  PositionE e ->
  Aff Unit
smart_move = liftEffect <$> ffi_smart_move

foreign import ffi_loot :: Boolean -> Effect Unit

loot' :: Aff Unit
loot' = liftEffect $ ffi_loot false

type UseTarget
  = Player

foreign import ffi_use :: String -> Maybe UseTarget -> Effect Unit

use' :: String -> Aff Unit
use' name = liftEffect $ ffi_use name Nothing

foreign import ffi_find_npc ::
  forall a.
  (a -> Maybe a) ->
  (Maybe a) ->
  String ->
  Effect (Maybe Position)

findNPC ::
  String ->
  Effect (Maybe Position)
findNPC = ffi_find_npc Just Nothing

foreign import ffi_buy :: String -> Number -> Effect (Promise Unit)

buy :: String -> Number -> Aff Unit
buy name amt = do
  toAffE $ ffi_buy name amt
