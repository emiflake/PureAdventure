module Bot.Task where

import Prelude
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Argonaut.Core (stringify)
import Data.Argonaut.Decode.Class (class DecodeJson, decodeJson)
import Data.Argonaut.Decode.Generic.Rep (class DecodeLiteral, decodeLiteralSumWithTransform, genericDecodeJson, genericDecodeJsonWith)
import Data.Argonaut.Encode.Class (class EncodeJson, encodeJson)
import Data.Argonaut.Encode.Generic.Rep (class EncodeLiteral, encodeLiteralSumWithTransform, genericEncodeJson, genericEncodeJsonWith)
import Effect (Effect)
import Data.Maybe (Maybe(..))
import Adventure.Position

data Task
  = Hunting
  | Restocking

derive instance genericTask :: Generic Task _

derive instance eqTask :: Eq Task

instance encodeTask :: EncodeJson Task where
  encodeJson a = encodeLiteralSumWithTransform identity a

instance decodeTask :: DecodeJson Task where
  decodeJson a = decodeLiteralSumWithTransform identity a

instance showTask :: Show Task where
  show = genericShow
