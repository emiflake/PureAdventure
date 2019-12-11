module Adventure.Log where

import Prelude
import Effect (Effect)

foreign import ffi_set_message :: String -> Effect Unit

setMessage :: String -> Effect Unit
setMessage = ffi_set_message

foreign import ffi_safe_log :: String -> String -> Effect Unit

safeLog :: String -> String -> Effect Unit
safeLog = ffi_safe_log

log :: String -> Effect Unit
log str = safeLog str "white"

logShow :: forall a. Show a => a -> Effect Unit
logShow = log <<< show