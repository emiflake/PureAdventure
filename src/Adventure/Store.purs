module Adventure.Store where

import Data.Maybe (Maybe(..))
import Data.Either (Either(..), hush)
import Prelude
import Effect (Effect)
import Effect.Aff
import Effect.Class (liftEffect)
import Data.Argonaut.Core (stringify)
import Data.Argonaut.Parser (jsonParser)
import Data.Argonaut.Decode.Class (class DecodeJson, decodeJson)
import Data.Argonaut.Encode.Class (class EncodeJson, encodeJson)

foreign import ffi_set :: String -> String -> Effect Unit

foreign import ffi_get :: String -> Effect String

storeSet :: forall a. EncodeJson a => String -> a -> Aff Unit
storeSet key value = storeSetR key <<< stringify $ encodeJson value

storeGet :: forall a. DecodeJson a => String -> Aff (Maybe a)
storeGet key = do
  raw <- storeGetR key
  pure do
    raw' <- raw
    json' <- hush (jsonParser raw')
    hush (decodeJson json')

storeSetR :: String -> String -> Aff Unit
storeSetR k v = liftEffect $ ffi_set k v

storeGetR :: String -> Aff (Maybe String)
storeGetR key =
  liftEffect
    $ do
        val <- ffi_get key
        pure case val of
          "" -> Nothing
          xs -> Just xs
