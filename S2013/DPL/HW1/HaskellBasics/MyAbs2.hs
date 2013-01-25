module Main where

-- Modify the myAbs function to work properly.
-- Use pattern matching for the zero case, 
-- and guards for positive or negative inputs.

-- Also, include the type declaration for the resulting myAbs function,
-- and, in a comment immediately above the function, write a plain-English
-- description of how to read and understand it.

-- myAbs takes a number that can be ordered and retruns a number
myAbs :: (Num a, Ord a) => a -> a
myAbs x
    | x < 0 = x * (-1)
    | otherwise = x

main = do  
  l <- getLine
  putStr $ show $ myAbs (read l :: Float)
          
  
