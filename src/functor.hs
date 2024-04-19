module Functor where

import Distribution.Simple.Utils (xargs)

class MyFunctor f where
  fmap' :: (a -> b) -> f a -> f b

instance MyFunctor (Either e) where
  fmap' :: (a -> b) -> Either e a -> Either e b
  fmap' _ (Left a) = Left a
  fmap' f (Right b) = Right (f b)

instance MyFunctor ((->) e) where
  fmap' :: (a -> b) -> (e -> a) -> e -> b
  fmap' = (.)

instance MyFunctor ((,) e) where
  fmap' :: (a -> b) -> (e, a) -> (e, b)
  fmap' f (e, a) = (e, f a)

data Pair a = Pair a a

instance Show (Pair Integer) where
  show :: Pair Integer -> String
  show (Pair a b) = show a ++ " - " ++ show b

instance MyFunctor Pair where
  fmap' :: (a -> b) -> Pair a -> Pair b
  fmap' f (Pair a b) = Pair (f a) (f b)

data ITree a
  = Leaf (Int -> a)
  | Node [ITree a]

instance MyFunctor ITree where
  fmap' :: (a -> b) -> ITree a -> ITree b
  fmap' f (Leaf g) = Leaf (f . g)
  fmap' f (Node xs) = Node (map (fmap' f) xs)
