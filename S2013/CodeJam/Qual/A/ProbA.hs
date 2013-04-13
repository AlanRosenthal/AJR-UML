module Main where
import Data.List

-- main =
--     getFile 
--     (f:_) <- getArgs
--     file <- readFile f
--     parseFile file
-- 
-- parseFile x = do
--     
    
main = do
    count <- getLine
    lines <- getLines (read count :: Int)
    mapM_ putStrLn (addCase (map findWinner lines) 1)

addCase [] _ = []
addCase (x:xs) n = 
    ("Case #" ++ (show n) ++ ": " ++ x) : (addCase xs (n+1))

getLines 0 = return []
getLines n = do
    a <- getLine
    b <- getLine
    c <- getLine
    d <- getLine
    getLine
    let x = a ++ b ++ c ++ d
    xs <- getLines (n - 1)
    return $ x : xs
    
findWinner x = 
    if ((findWinnerX $ replaceT x "X") == True)
        then "X won"
        else if ((findWinnerY $ replaceT x "O") == True)
            then "O won"
            else if (findWinnerDot x)
                then "Game has not completed"
                else "Draw"

findWinnerX x =
    if (find (=="XXXX") (splitIntoRows x ++ splitIntoCols x ++ splitIntoDias x) == Nothing)
        then False
        else True

findWinnerY x =
    if (find (=="OOOO") (splitIntoRows x ++ splitIntoCols x ++ splitIntoDias x) == Nothing)
        then False
        else True

findWinnerDot x = 
    if (find (=='.') x == Nothing)
        then False
        else True
        
splitIntoRows [] = []
splitIntoRows (x1:x2:x3:x4:xs) = 
    [x1,x2,x3,x4] : splitIntoRows xs

splitIntoCols xs =
    [[xs !! 0,xs !! 4, xs !! 8, xs !! 12],[xs !! 1,xs !! 5, xs !! 9, xs !! 13],[xs !! 2,xs !! 6, xs !! 10, xs !! 14],[xs !! 3,xs !! 7, xs !! 11, xs !! 15]]

splitIntoDias xs = 
    [[xs !! 0,xs !! 5, xs !! 10, xs !! 15],[xs !! 3,xs !! 6, xs !! 9, xs !! 12]]

replaceT [] _ = []
replaceT (x:xs) [with] = 
    if (x == 'T')
        then with : (replaceT xs [with])
        else x : (replaceT xs [with])