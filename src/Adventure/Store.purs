module Adventure.Store where

import Prelude (Unit, bind, pure, ($), (<<<))

import Data.Argonaut.Core (stringify)
import Data.Argonaut.Parser (jsonParser)
import Data.Argonaut.Decode.Class (class DecodeJson, decodeJson)
import Data.Argonaut.Encode.Class (class EncodeJson, encodeJson)
import Data.Either (hush)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)

foreign import unsafe_ffi_set :: String -> String -> Effect Unit

foreign import unsafe_ffi_get :: String -> Effect String

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
storeSetR k v = liftEffect $ unsafe_ffi_set k v

storeGetR :: String -> Aff (Maybe String)
storeGetR key = do
  val <- liftEffect $ unsafe_ffi_get key
  pure case val of
    "" -> Nothing
    xs -> Just xs
