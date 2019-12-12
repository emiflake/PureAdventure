module Adventure.Store where

import Data.Maybe (Maybe(..))
import Data.Either (Either(..), hush)
import Prelude
import Effect (Effect)
import Data.Argonaut.Core (stringify)
import Data.Argonaut.Parser (jsonParser)
import Data.Argonaut.Decode.Class (class DecodeJson, decodeJson)
import Data.Argonaut.Encode.Class (class EncodeJson, encodeJson)

foreign import ffi_set :: String -> String -> Effect Unit

foreign import ffi_get :: String -> Effect String

storeSet :: forall a. EncodeJson a => String -> a -> Effect Unit
storeSet key value = storeSetR key <<< stringify $ encodeJson value

storeGet :: forall a. DecodeJson a => String -> Effect (Maybe a)
storeGet key = do
  raw <- storeGetR key
  pure do
    raw' <- raw
    json' <- hush (jsonParser raw')
    hush (decodeJson json')

storeSetR :: String -> String -> Effect Unit
storeSetR = ffi_set

storeGetR :: String -> Effect (Maybe String)
storeGetR key = do
  val <- ffi_get key
  pure case val of
    "" -> Nothing
    xs -> Just xs
