module Main where

-- Implement foldr using list recursion.

-- (a -> b -> b) => input, fuction that takes type a,b outputs b
-- b => input, type b
-- [a] => input, list of a
-- b => output, type b
myFoldr :: (a -> b -> b) -> b -> [a] -> b
myFoldr _ acc [] = acc
myFoldr fn acc xs =
    myFoldr fn (fn (last xs) acc) (init xs)
    --calls myFoldr recusrively, with params
    --fn: function to be applied
    --acc: the function applied to the last item in the list, and acc
    --xs: the inital list (without the last item)
    --when myFoldr is called on an empty list, acc is returned

mySum = myFoldr (+) 0

main = do  
  l <- getLine
  putStrLn $ show $ 
    (mySum (map (\x -> read x :: Int) (words l)))
