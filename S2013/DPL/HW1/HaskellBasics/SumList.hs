module Main where

-- Write a function named 'sumList' that takes a list of numbers
-- and returns the sum of the list.

-- You should use pattern matching to define the edge case, 
-- which is that the sum of an empty list is 0.

-- Include a type declaration for the function, and write a comment
-- near the type declaration that explains in English how to read it.

-- sumList takes a list of numbers and returns a number
sumList :: (Num a) => [a] -> a
sumList [] = 0
sumList (x:xs) = x + sumList xs



main = do  
  l <- getLine
  putStrLn $ show $ 
    (sumList (map (\x -> read x :: Int) (words l)))
