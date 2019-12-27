module Adventure.Command where

import Prelude (($), (<>), bind, pure)

import Adventure.Position (Position)
import Bot.Locations (positions)
import Data.Array.NonEmpty as NA
import Data.Either (Either(..))
import Data.List (List, (:), fromFoldable)
import Data.Map (lookup)
import Data.Maybe (Maybe(..))
import Data.Number (fromString)

type CommandRow = (cmd :: String, args :: Array String)
type CommandRec = Record CommandRow

data Command
 = Go Position
 | Hunt (Maybe Position)
 | Restock


parseCmd :: NA.NonEmptyArray String -> Either String Command
parseCmd cmdStrs = case NA.head cmdStrs of
  "go" -> Left "Unimplemented"
  "hunt" -> hunt $ fromFoldable $ NA.tail cmdStrs
  "restock" -> Left "Unimplemented"
  badCmd -> Left $ "Unkown command: " <> badCmd

-- runCmd :: Command -> Aff Unit -- TODO

hunt :: List String -> Either String Command
hunt (a1:a2:as) = case getPos of
  Just pos -> Right $ Hunt $ Just pos
  Nothing -> Left "hunt error: one of the coordinates was not a number"
  where
    getPos :: Maybe Position
    getPos = do
      x <- fromString a1
      y <- fromString a2
      pure {x: x, y: y}
hunt (a1:as) = case a1 of
  "stop" -> Right $ Restock
  _ -> case (lookup a1 positions) of
    Just pos -> Right $ Hunt $ Just pos
    Nothing -> Left "hunt error: not a valid position name"
hunt _ = Right $ Hunt Nothing
