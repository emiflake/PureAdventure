module Adventure where

import Prelude (Unit, class Show, show, (<$>), discard)
import Adventure.Position (class HasPosition, getPosition, Position(..))
import Adventure.Log (logShow)
import Effect (Effect)
import Data.Maybe (Maybe(..))

data PlayerT
  = PlayerT Player

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

instance showPlayer :: Show PlayerT where
  show (PlayerT p) = show p

foreign import ffi_get_player :: String -> Effect Player

getPlayer :: String -> Effect PlayerT
getPlayer s = PlayerT <$> ffi_get_player s

foreign import ffi_character :: Effect Player

character :: Effect PlayerT
character = PlayerT <$> ffi_character

instance playerPos :: HasPosition PlayerT where
  getPosition :: PlayerT -> Position
  getPosition (PlayerT p) = Position { x: p.x, y: p.y }

data MonsterT
  = MonsterT Monster

type Monster
  = { name :: String
    , hp :: Number
    , level :: Number
    , x :: Number
    , y :: Number
    }

instance showMonster :: Show MonsterT where
  show (MonsterT m) = show m

type NearestMonsterArgs
  = {}

foreign import ffi_get_nearest_monster :: NearestMonsterArgs -> Effect Monster

getNearestMonster :: NearestMonsterArgs -> Effect MonsterT
getNearestMonster args = MonsterT <$> ffi_get_nearest_monster args

getNearestMonster' :: Effect MonsterT
getNearestMonster' = getNearestMonster {}

instance monsterPos :: HasPosition MonsterT where
  getPosition :: MonsterT -> Position
  getPosition (MonsterT m) = Position { x: m.x, y: m.y }

type AttackTarget
  = Monster

foreign import ffi_attack :: AttackTarget -> Effect Unit

foreign import ffi_can_attack :: AttackTarget -> Effect Boolean

attackMonster :: MonsterT -> Effect Unit
attackMonster (MonsterT m) = ffi_attack m

canAttackMonster :: MonsterT -> Effect Boolean
canAttackMonster (MonsterT m) = ffi_can_attack m

foreign import ffi_smart_move :: Position -> Effect Unit

foreign import ffi_move :: Number -> Number -> Effect Unit

move :: Position -> Effect Unit
move (Position p) = ffi_move p.x p.y

moveTo :: forall a. HasPosition a => a -> Effect Unit
moveTo a = move (getPosition a)

smartMove :: Position -> Effect Unit
smartMove = ffi_smart_move

smartMoveTo :: forall a. HasPosition a => a -> Effect Unit
smartMoveTo trgt = do
  let
    position = getPosition trgt
  logShow position
  smartMove position

foreign import ffi_loot :: Boolean -> Effect Unit

loot' :: Effect Unit
loot' = ffi_loot false

type UseTarget
  = Player

foreign import ffi_use :: String -> Maybe UseTarget -> Effect Unit

use' :: String -> Effect Unit
use' name = ffi_use name Nothing
