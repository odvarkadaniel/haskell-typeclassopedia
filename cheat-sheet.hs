module Test where

import Control.Applicative qualified as Control

-- Typeclasses
data TrafficLigth = Red | Orange | Green

instance Eq TrafficLigth where
  Red == Red = True
  Orange == Orange = True
  Green == Green = True
  _ == _ = False

instance Show TrafficLigth where
  show Red = "Red Light"
  show Orange = "Orange Light"
  show Green = "Green Light"

-- Recursive data structures
data Tree a = EmptyTree | Node a (Tree a) (Tree a) deriving (Show, Read, Eq)

singleton :: a -> Tree a
singleton x = Node x EmptyTree EmptyTree

treeInsert :: (Ord a) => a -> Tree a -> Tree a
treeInsert x EmptyTree = singleton x
treeInsert x (Node a left right)
  | x == a = Node x left right
  | x < a = Node a (treeInsert x left) right
  | x > a = Node a left (treeInsert x right)

treeElem :: (Ord a) => a -> Tree a -> Bool
treeElem x EmptyTree = False
treeElem x (Node a left right)
  | x == a = True
  | x < a = treeElem x left
  | x > a = treeElem x right

-- Functor typeclass
-- Definition:
-- instance Functor f where
--   fmap :: (a -> b) -> f a -> f b
-- Types that can acts like a box can be a functor (like lists)

-- Functor wants a type constructor!!! Not a concrete type like `Maybe a`
-- instance Functor Maybe where
--   fmap f (Just x) = Just (f x)
--   fmap f Nothing = Nothing

-- For these "boxes", we can't apply the functions an normal
-- fmap (+2) (Just 2) => Just 4
-- fmap (+2) Nothing  => Nothing
-- Infix version of fmap is <$>
-- (+2) <$> (Just 2)

-- Applicatives
-- Control.Applicative defines <*>
-- <*> knows how to apply a function wrapped in a context to a value wrapped in a context
-- Just (+3) <*> Just 2       => Just 5
-- [(*2), (+3)] <*> [1, 2, 3] => [1,4,6,4,5,6]

-- Monads
-- They apply a function that returns a wrapped value to a wrapped value
-- Function (>>=), so called "bind"
-- `Maybe` is a monad
class Monad m where
  (>>=) :: m a -> (a -> m b) -> m b

-- IO Monads
foo = do
  filename <- getLine
  contens <- readFile filename
  putStrLn contens

-- Is equivalent to
-- getLine >>= readFile >>= putStrLn