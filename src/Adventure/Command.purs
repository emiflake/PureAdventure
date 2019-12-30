module Adventure.Command where

import Prelude (($), (<$>), (<>), bind, discard, join, not, pure, show)

import Adventure (character, playerPos)
import Adventure.Log (setLogLvl)
import Adventure.Position (Position)
import Bot.Locations (positions)
import Bot.State (getState)
import Bot.Task (Task(..))
import Data.Array.NonEmpty as NA
import Data.Either (Either(..))
import Data.Int as DI
import Data.List (List, (:), filter, fromFoldable, head)
import Data.Map (lookup)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Number as DN
import Data.String.Common (split, null)
import Data.String.Pattern (Pattern(..))
import Effect.Aff (Aff)

type CommandRow = (cmd :: String, args :: Array String)
type CommandRec = Record CommandRow

-- | Note that `Left String` values serve two purposes:
-- | error reporting, and dispalaying
-- | information to the user where the purpose
-- | of a command is strictly informational in nature.
type Command = Either String Task

parseCmd :: NA.NonEmptyArray String -> Aff Command
parseCmd cmdStrs = case NA.head cmdStrs of
  "coords" -> do
    char <- character
    pure $ Left $ "Player coords: " <> (show $ playerPos char)
  "dummy" -> pure $ Left "" -- Say nothing, do nothing
  "go" -> pure $ Left "Unimplemented"
  "hunt" -> pure $ hunt $ args
  "loglvl" -> do
    st <- getState
    setLogLvl $ fromMaybe st.logLevel $
      join $ DI.fromString <$> head args
    pure $ Left ""
  "restock" -> pure $ Left "Unimplemented"
  badCmd -> pure $ Left $ "Unkown command: " <> badCmd
  where
    args = filter (not null) $ fromFoldable $ join
      $ (split (Pattern " ")) <$> NA.tail cmdStrs

hunt :: List String -> Command
hunt (a1:a2:as) = case getPos of
  Just pos -> Right $ Hunting $ Just pos
  Nothing -> Left "hunt error: one of the coordinates was not a number"
  where
    getPos :: Maybe Position
    getPos = do
      x <- DN.fromString a1
      y <- DN.fromString a2
      pure {x: x, y: y}
hunt (a1:as) = case a1 of
  "stop" -> Right $ Restocking
  _ -> case (lookup a1 positions) of
    Just pos -> Right $ Hunting $ Just pos
    Nothing -> Left $ "hunt error: '" <> a1
      <> "' not a valid position name"
hunt _ = Right $ Hunting Nothing
