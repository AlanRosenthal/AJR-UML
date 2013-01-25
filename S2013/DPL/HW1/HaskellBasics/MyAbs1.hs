module Main where

-- Modify the myAbs function to work properly.
-- Use an if-then-else expression.

-- Also, include the type declaration for the resulting myAbs function,
-- and, in a comment immediately above the function,  write a plain-English
-- description of how to read and understand it.

-- myAbs takes a number that can be ordered and returns a number
myAbs :: (Num a, Ord a) => a -> a
myAbs x =
    if x < 0
       then x * (-1)
       else x
       
       
main = do  
    l <- getLine
    putStr $ show $ myAbs (read l :: Float)