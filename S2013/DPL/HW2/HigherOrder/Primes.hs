
-- All you need to do is to make "primes" be the list of all primes.

-- Here's the infinite list of all numbers. I suggest filtering
-- out the ones that aren't prime.

-- Try typing this in to ghci for the fun of it:
-- ghci> let odds = filter odd [1..]
-- ghci> takeWhile (<100) odds

-- Use list comprehensions rather than filter or map.

primes = 2:[x | x <- [3..], isprime x == True]

isprime :: Int -> Bool
isprime x =
    and $ map (\y -> if y == 0 then False else True) ((\z -> zipWith mod (take (z-2) $ repeat z) [2..(z-1)]) x)
-- takes a list of x (the number you are testing) as well as a list of 2-(x-1) and zips them together with mod functions
-- this will produce a list of remainders, if any are 0, then they the number is not a prime
-- the map fuction turns all non zero numbers to True, and 0s to False.  The and fuction checks to see if everything is true, if so returns true
    
main = do  
  l <- getLine
  putStrLn $ show $ (primes !! (read l :: Int))
