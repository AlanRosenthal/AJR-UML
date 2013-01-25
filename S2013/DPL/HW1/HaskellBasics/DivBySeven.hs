module Main where

-- Write a function named "divBySeven" that takes a list of numbers
-- and returns a list of numbers that are divisible by 7
-- (in the same order that they appeared in the original list).

-- You should use pattern matching to define the edge case.

-- Include a type declaration for the function, and write a comment
-- near the type declaration that explains in English how to read it.

-- note: 'id' is the identity function, so you're starting out with
-- a function that returns its input.
-- this is clearly not the answer; it's only given so you have
-- something which will compile.

-- divBySeven takes a list of numbers (integers) that can be compared and returns a list of numbers (intergers)
divBySeven :: (Integral a, Eq a) => [a] -> [a]
divBySeven x = [y | y <- x, (mod y 7) == 0]

main = do  
  l <- getLine
  putStr $ unwords $
    map show
    (divBySeven (map (\x -> read x :: Int) (words l)))
