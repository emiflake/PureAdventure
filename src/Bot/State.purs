module Bot.State where

{-
    This module is responsible for handling
    the Bot state. No actions will be handled here.
    It is singly responsible for all information the bot
    may hold.
-}
import Prelude
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Argonaut.Core (stringify)
import Data.Argonaut.Decode.Class (class DecodeJson, decodeJson)
import Data.Argonaut.Decode.Generic.Rep (class DecodeLiteral, decodeLiteralSumWithTransform, genericDecodeJson, genericDecodeJsonWith)
import Data.Argonaut.Encode.Class (class EncodeJson, encodeJson)
import Data.Argonaut.Encode.Generic.Rep (class EncodeLiteral, encodeLiteralSumWithTransform, genericEncodeJson, genericEncodeJsonWith)
import Effect (Effect)
import Effect.Aff
import Data.Maybe (Maybe(..))
import Adventure.Store (storeGet, storeSet)
import Bot.Task

type ST
  = { task :: Task
    , counter :: Number
    }

initialState :: ST
initialState =
  { task: Hunting
  , counter: 0.0
  }

storeState :: ST -> Aff Unit
storeState = storeSet "state"

getState :: Aff ST
getState = do
  st <- storeGet "state"
  case st of
    Nothing -> do
      storeState initialState
      pure initialState
    Just st' -> do
      pure st'

type StateHandler
  = (ST -> Aff ST)

withState :: (ST -> Aff ST) -> Aff Unit
withState f = do
  st <- getState
  res <- f st
  storeState res
