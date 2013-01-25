module Main where

-- Write a function named "squareList" which will take a list of numbers 
-- and output a list where each item is squared.
--
-- Use recursion to accomplish this (not mapping).
-- 
-- Include a type declaration for the function, and write a comment
-- near the type declaration that explains in English how to read it.

-- note: 'id' is the identity function, so you're starting out with
-- a function that returns its input.
-- this is clearly not the answer; it's only given so you have
-- something which will compile.

-- squareList takes a list of numbers and returns a list of numbers
squareList :: (Num a) => [a] -> [a]
squareList [] = []
squareList (x:xs) = x^2:squareList(xs)


main = do  
  l <- getLine
  putStr $ unwords $
    map show
    (squareList (map (\x -> read x :: Int) (words l)))
          
  
