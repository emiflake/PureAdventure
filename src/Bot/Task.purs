module Bot.Task where

import Prelude (class Eq, class Show, identity)

import Adventure.Position (Position)
import Data.Argonaut.Decode.Class (class DecodeJson)
import Data.Argonaut.Decode.Generic.Rep (decodeLiteralSumWithTransform)
import Data.Argonaut.Encode.Class (class EncodeJson)
import Data.Argonaut.Encode.Generic.Rep (encodeLiteralSumWithTransform)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Maybe (Maybe)

data Task
  = Hunting (Maybe Position)
  | Restocking

derive instance genericTask :: Generic Task _

derive instance eqTask :: Eq Task

instance encodeTask :: EncodeJson Task where
  encodeJson a = encodeLiteralSumWithTransform identity a

instance decodeTask :: DecodeJson Task where
  decodeJson a = decodeLiteralSumWithTransform identity a

instance showTask :: Show Task where
  show = genericShow
