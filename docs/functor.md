# Functor
- the most basic and ubiquitous type class in the Haskell libraries
- a simple intuition is that a Functor represents a “container” of some sort, along with the ability to apply a function uniformly to every element in the container
- for example, a list is a container of elements, and we can apply a function to every element of a list, using `map`
- another intuition is that a Functor represents some sort of “computational context”

## Definition
```haskell
class Functor f where
  fmap :: (a -> b) -> f a -> f b

  (<$) :: a        -> f b -> f a
  (<$) = fmap . const
```
- exported from `Prelude`
- type of `map` takes any function from a to b, and a value of type f a, and outputs a value of type f b
    - from the container point of view, the intention is that fmap applies a function to each element of a container, without altering the structure of the container
    - from the context point of view, the intention is that fmap applies a function to a value without altering its context

## Instances
- `[]` is a Functor (type `[a]` can be written as `[] a`)
- `Maybe` is a Functor
```haskell
instance Functor [] where
  fmap :: (a -> b) -> [a] -> [b]
  fmap _ [] = []
  fmap f (x:xs) = f x : fmap f xs

instance Funtor Maybe where
  fmap :: (a -> b) -> Maybe a -> Maybe b
  fmap _ Nothing = Nothing
  fmap f (Just x) = Just (f x)
```

### Other Instances
- `Either e`
    - `Either e a` is a container that contains either value of type `e` or value of type `a`
- `((,) e)`
    - represents a container which holds an "annotation" of type `e` along with the actual value it holds (can be written as `(e,)`) 
- `((->) e)`
    - can be thought of as `(e ->)`
    - the type of functions which take a value of type `e` as a parameter, is a Functor
    - as a container `(e -> a)` represents (possibly infinite) set of values of type `a`, indexed by values of `e`
    - can be thought of as a context in which a value of type `e` is available to be consulted in a read-only fashion (i.e. `reader monad`)
- `IO`
    - a value of `IO a` represents a computation producing a value of type `a` which may have `I/O` effects
    - if `m` computes the value `x` while producing some `I/O` effects, then `fmap g m` will compute the value `g x` while producing some `I/O` effects

## Laws
- as far as the Haskell language itself is concerned, the only requirement to be a Functor is an implementation of `fmap` with the proper type
- Functor laws:
    ```haskell
    fmap id = id
    fmap (g . h) = (fmap g) . (fmap h)
    ```
    - these laws ensure that `fmap g` does not change the structure of a container, only the elements

## Intuition
- we can write fmap’s type with extra parentheses: `fmap :: (a -> b) -> (f a -> f b)`
- written in this form, it is apparent that fmap transforms a “normal” function `(g :: a -> b)` into one which operates over containers/contexts `(fmap g :: f a -> f b)`
- this transformation is often referred to as a `lift`; `fmap` “lifts” a function from the “normal world” into the “f world”