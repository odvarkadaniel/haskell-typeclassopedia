module Collatz where

step :: Integer -> Integer
step x
  | even x = x `div` 2
  | odd x = 3 * x + 1

collatz :: Integer -> Integer
collatz 1 = 0
collatz x = 1 + collatz (step x)
