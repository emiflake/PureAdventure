module Adventure.Log where

import Prelude (class Show, Unit, bind, pure, show, (<<<), ($))

import Data.Formatter.DateTime (
    format
  , Formatter
  , FormatterCommand(..)
  )
import Data.List.Types (List(..), (:))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Now (nowDateTime)


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

-- | Just a convenience function for creating
-- | the current time as a concise but easy-to-read string
dateLog :: Aff String
dateLog = do
  ts <- liftEffect nowDateTime
  pure $ format dateLogFmt ts

dateLogFmt :: Formatter
dateLogFmt =  MonthShort : d : DayOfMonth : s
  : Hours24 : c : Minutes : c :  Seconds : Nil
  where
    s = Placeholder " "
    c = Placeholder ":"
    d = Placeholder "-"