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

storeSetE :: forall a. EncodeJson a => String -> a -> Effect Unit
storeSetE key value = storeSetR key <<< stringify $ encodeJson value

storeGetE :: forall a. DecodeJson a => String -> Effect (Maybe a)
storeGetE key = do
  raw <- storeGetR key
  pure do
    raw' <- raw
    json' <- hush (jsonParser raw')
    hush (decodeJson json')

storeSet :: forall a. EncodeJson a => String -> a -> Aff Unit
storeSet k v = liftEffect $ storeSetE k v

storeGet :: forall a. DecodeJson a => String -> Aff (Maybe a)
storeGet = liftEffect <<< storeGetE


storeSetR :: String -> String -> Effect Unit
storeSetR k v =  unsafe_ffi_set k v

storeGetR :: String -> Effect (Maybe String)
storeGetR key = do
  val <- unsafe_ffi_get key
  pure case val of
    "" -> Nothing
    xs -> Just xs
