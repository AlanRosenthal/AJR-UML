module Main where
import Data.List

main = do
    count <- getLine
    lines <- getLines (read count :: Int)
--     mapM_ putStrLn (map show lines)
    mapM_ putStrLn $ addCase (map keepsolve lines) 1

addCase [] _ = []
addCase (x:xs) n = 
    ("Case #" ++ (show n) ++ ": " ++ x) : (addCase xs (n+1))

getLines 0 = return []
getLines total = do
    nm <- getLine
    let nm' = words nm
    let n = (read ((words nm) !! 0) :: Int)
    let m = (read ((words nm) !! 1) :: Int)
    x <- getNLines n
    xs <- getLines (total - 1)
    return $ ((n,m,(addPerm n m x 0)) : xs)

getNLines 0 = return []
getNLines n = do
    x <- getLine
    let x' = strToInt $ words x
    xs <- getNLines (n - 1)
    return $ x' ++ xs

strToInt [] = []
strToInt (x:xs) = 
    (read x :: Int) : strToInt xs

keepsolve (n,m,x) =
    if (x == x')
        then checkall x
        else keepsolve (n,m,x')
    where
        x' = walk n m x x 0
        x'' = walk n m x' x' 0

walk _ _ [] _ _ = []
walk n m ((x,t):xs) xx i = 
    if (t == 1)
        then (x,t) : (walk n m xs xx (i+1))
--         else (x,t) : (walk n m xs xx (i+1))
        else (check [xx !! (i - m),xx !! (i + m),xx !! (i-1),xx !! (i+1)] x) : (walk n m xs xx (i+1))

checkall [] = "YES"
checkall ((x,t):xs) =
    if (t == 0)
        then "NO"
        else checkall xs

check [] x = (x,0)
check ((n,t):ns) x =
    if (and [(t == 1),(n >= x)])
        then (x,1)
        else check ns x
{-
addPerm _ _ [] _ = []
addPerm n m (x:xs) i =
    if (or [i `mod` m == 0,i `mod` m == (m-1),i `div` m == 0,i `div` m == (n-1)])
        then (x,1) : addPerm n m xs (i+1)
        else (x,0) : addPerm n m xs (i+1)-}

addPerm _ _ [] _ = []
addPerm n m (x:xs) i =
    if (or [i `mod` m == 0,i `mod` m == (m-1),i `div` m == 0,i `div` m == (n-1)])
        then (x,1) : addPerm n m xs (i+1)
        else (x,0) : addPerm n m xs (i+1)

showArray [] = return []
showArray (x:xs) = do
    putStrLn (show x)
    showArray xs