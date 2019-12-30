module Adventure.Log where

import Prelude (class Show, Unit, bind, pure, show, (<<<), ($), (<=))

import Bot.State (getState, withState)
import Control.Applicative (when)
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

safeLogE :: String -> String -> Effect Unit
safeLogE text color = ffi_safe_log text color

safeLog :: String -> String -> Aff Unit
safeLog text color = liftEffect $ safeLogE text color

logE :: String -> Effect Unit
logE str = safeLogE str "white"

log :: Int -> String -> Aff Unit
log lvl str = do
  st <- getState
  when (lvl <= st.logLevel) $ liftEffect $ logE str

logShow :: forall a. Show a => Int -> a -> Aff Unit
logShow lvl a = log lvl $ show a

-- | Just a convenience function for creating
-- | the current time as a concise but easy-to-read string
dateLog :: Aff String
dateLog = do
  ts <- liftEffect nowDateTime
  pure $ format dateLogFmt ts

setLogLvl :: Int -> Aff Unit
setLogLvl lvl = withState $ \st -> do
  pure st { logLevel = lvl }

dateLogFmt :: Formatter
dateLogFmt =  MonthShort : d : DayOfMonth : s
  : Hours24 : c : Minutes : c :  Seconds : Nil
  where
    s = Placeholder " "
    c = Placeholder ":"
    d = Placeholder "-"