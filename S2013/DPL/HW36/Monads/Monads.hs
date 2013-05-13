module Monads where

import Data.List (dropWhile)
import Data.Maybe (isNothing)


-- Read the Monad tutorial at:
-- http://www.haskell.org/tutorial/monads.html

-- Implement the R monad and related functions.
-- Include the "signum" function in your Num instance.


data R a = R (Resource -> (Resource, Either a (R a)))

instance Monad R where
    R c1 >>= fc2 = R (\r -> case c1 r of
                                 (r', Left v) -> let R c2 = fc2 v in c2 r'
                                 (r', Right pc1) -> (r', Right (pc1 >>= fc2)))
    return v = R (\r -> (r, (Left v)))

type Resource = Integer

step :: a -> R a
step v = c where
    c = R (\r -> if r /= 0 then (r-1, Left v)
                       else (r, Right c))

inc :: R Integer -> R Integer
inc i = i + 1 

lift1 :: (a -> b) -> (R a -> R b)
lift1 f = \ra1 -> do a1 <- ra1
                     step (f a1)

lift2 :: (a-> b -> c) -> (R a -> R b -> R c)
lift2 f = \ra1 ra2 -> do a1 <- ra1
                         a2 <- ra2
                         step (f a1 a2)

(==*) :: Ord a => R a -> R a -> R Bool
(==*) = lift2 (==)

instance  Num a => Num (R a) where
    (+) = lift2 (+)
    (-) = lift2 (-)
    negate = lift1 negate
    (*) = lift2 (*)
    abs = lift1 abs
    fromInteger = return . fromInteger
    signum = lift1 signum

ifR :: R Bool -> R a -> R a -> R a
ifR tst thn els = do t <- tst
                     if t then thn else els

fact :: R Integer -> R Integer
fact x = ifR (x ==* 0) 1 (x * fact (x-1))

run :: Resource -> R a -> Maybe a
run s (R p) = case (p s) of
                   (_, Left v) -> Just v
                   _ -> Nothing


-- Implement a function (minSteps vv) that takes a computation in the R
-- monad and figures out the minimum number of steps required to run it.
--
-- e.g. minSteps (fact 4) == 25

-- minSteps :: R a -> Integer
minSteps vv = minSteps' vv 0

-- minSteps' ::  R a -> b -> Integer
minSteps' vv n = 
    case (run n vv) of
       Just _ -> n
       Nothing -> minSteps' vv (n+1)