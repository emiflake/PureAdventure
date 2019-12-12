module Adventure.Log where

import Prelude
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Aff (Aff)

foreign import ffi_set_message :: String -> Effect Unit

setMessage :: String -> Aff Unit
setMessage = liftEffect <<< ffi_set_message

foreign import ffi_safe_log :: String -> String -> Effect Unit

safeLog :: String -> String -> Aff Unit
safeLog text color = liftEffect $ ffi_safe_log text color

log :: String -> Aff Unit
log str = safeLog str "white"

logShow :: forall a. Show a => a -> Aff Unit
logShow = log <<< show
