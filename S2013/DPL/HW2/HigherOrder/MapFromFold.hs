
-- For this problem, you need to build map using fold.

myMap f xs = 
    foldr (\x y -> (f x):y) [] xs
    -- cons the function applied to the acculater, making the list

main = do
    putStr (show $ sum $ myMap (+2) [1..10])
    putStr " "
    putStrLn (show $ sum $ myMap (*2) [1..10])
