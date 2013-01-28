module Main where

import Data.List

-- Look at ReverseWords2.hs for a less idiomatic (and therefore
-- possibly easier to understand) version of this code.

main = do
    count <- getLine
    lines <- getLines (read count :: Int)
    mapM_ putStrLn $ addCaseLabels $ map reverseWords lines

-- mapM_ is "for each"
--   Inside a "do" block, it takes a function and a list and calls
--   the function on each item in the list as if the calls were 
--   directly in the "do" block.

getLines 0 = return []
getLines n = do
    x  <- getLine
    xs <- getLines (n - 1)
    return $ x : xs

addCaseLabels xs = map addCase $ zip [1..] xs
    where addCase (nn, ss) = "Case #" ++ (show nn) ++ ": " ++ ss

reverseWords :: [Char] -> [Char]
reverseWords x = unwords $ reverse $ words x
