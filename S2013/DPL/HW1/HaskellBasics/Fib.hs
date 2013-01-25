module Main where

-- Implement Fibonacci numbers using recursion.
-- Use pattern matching for the case of fib 1 = 1 and fib 2 = 1.
-- Use recursion for the rest.
-- Do not worry about fib 0 or fib of a negative number.


fib :: (Integral a, Eq a) => a -> a
fib 1 = 1
fib 2 = 1
fib x =
    fib (x - 1) + fib (x - 2)

    
main = do  
  l <- getLine
  putStr $ show $ fib (read l :: Int)
          
  
