module Adventure.Log where

import Prelude (class Show, Unit, (<<<), ($), show)

import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)

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
