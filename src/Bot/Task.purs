module Bot.Task where

import Prelude (class Eq, class Show)

import Adventure.Position (Position)
import Data.Argonaut.Decode (class DecodeJson)
import Data.Argonaut.Decode.Generic.Rep (genericDecodeJson)
import Data.Argonaut.Encode (class EncodeJson)
import Data.Argonaut.Encode.Generic.Rep (genericEncodeJson)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Maybe (Maybe)

data Task
  = Hunting (Maybe Position)
  | Restocking

derive instance genericTask :: Generic Task _

derive instance eqTask :: Eq Task

instance encodeTask :: EncodeJson Task where
  encodeJson a = genericEncodeJson a

instance decodeTask :: DecodeJson Task where
  decodeJson a = genericDecodeJson a

instance showTask :: Show Task where
  show = genericShow
