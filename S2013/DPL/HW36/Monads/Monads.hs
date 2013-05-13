module Monads where

import Data.List (dropWhile)
import Data.Maybe (isNothing)

-- Read the Monad tutorial at:
-- http://www.haskell.org/tutorial/monads.html

-- Implement the R monad and related functions.
-- Include the "signum" function in your Num instance.



-- Implement a function (minSteps vv) that takes a computation in the R
-- monad and figures out the minimum number of steps required to run it.
--
-- e.g. minSteps (fact 4) == 25

minSteps :: R a -> Int
minSteps vv = 5
