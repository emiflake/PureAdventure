module Bot.Inventory where

import Prelude (($), (<<<), (==))
import Adventure
  ( Player
  )

import Data.Array (find)
import Data.Functor ((<$>))
import Data.Int (floor)
import Data.Map (Map, fromFoldable)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Tuple (Tuple(..))

data ItemProp = 
    Potion
  | HealthPotion
  | ManaPotion
  | Usable

type Item = {
  name :: String
, iLvl :: Maybe Int
, props :: Array ItemProp
}

hpot0 :: Item
hpot0 = {
  name : "hpot0"
, iLvl : Just 0
, props : [Potion, HealthPotion, Usable]
}

mpot0 :: Item
mpot0 = {
  name : "mpot0"
, iLvl : Just 0
, props : [Potion, ManaPotion, Usable]
}

allItems :: Array Item
allItems = [
  hpot0
, mpot0
]

itemMap :: Map String Item
itemMap = fromFoldable $ (\i -> Tuple i.name i) <$> allItems 

mpPotCount :: Player -> Int
mpPotCount char = fromMaybe 0 $ itemCount mpot0 char

hpPotCount :: Player -> Int
hpPotCount char = fromMaybe 0 $ itemCount hpot0 char

itemCount :: Item -> Player -> Maybe Int
itemCount item player = (floor <<< (\i -> i.quantity)) <$> find (\i -> i.name == item.name) player.itemList
