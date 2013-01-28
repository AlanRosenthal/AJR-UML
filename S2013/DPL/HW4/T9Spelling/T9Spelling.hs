module Main where
import Data.List
-- Solve the Google Code Jam problem "T9 Spelling":
--   http://code.google.com/codejam/contest/351101/dashboard#s=p2

main = do
    count <- getLine
    lines <- getLines (read count :: Int)
    mapM_ putStrLn $ addCaseLabels $ map tNine lines

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


tNine x = tNinetoNum (tNineRec x []) []

tNineRec :: [Char] -> [Char] -> [Char]
tNineRec (x:[]) acc = acc ++ [x]
tNineRec (x:y:z) acc 
    | map (x `elem`) ["abc","def","ghi","jkl","mno","pqrs","tuv","wxyz"," "] == map (y `elem`) ["abc","def","ghi","jkl","mno","pqrs","tuv","wxyz"," "] = tNineRec (y:z) (acc ++ [x] ++ ".")
    | otherwise = tNineRec (y:z) (acc ++ [x])
 
tNinetoNum [] acc = acc
tNinetoNum (x:y) acc
    | x == 'a' = tNinetoNum y $ acc ++ "2"
    | x == 'b' = tNinetoNum y $ acc ++ "22"
    | x == 'c' = tNinetoNum y $ acc ++ "222"
    | x == 'd' = tNinetoNum y $ acc ++ "3"
    | x == 'e' = tNinetoNum y $ acc ++ "33"
    | x == 'f' = tNinetoNum y $ acc ++ "333"
    | x == 'g' = tNinetoNum y $ acc ++ "4"
    | x == 'h' = tNinetoNum y $ acc ++ "44"
    | x == 'i' = tNinetoNum y $ acc ++ "444"
    | x == 'j' = tNinetoNum y $ acc ++ "5"
    | x == 'k' = tNinetoNum y $ acc ++ "55"
    | x == 'l' = tNinetoNum y $ acc ++ "555"
    | x == 'm' = tNinetoNum y $ acc ++ "6"
    | x == 'n' = tNinetoNum y $ acc ++ "66"
    | x == 'o' = tNinetoNum y $ acc ++ "666"
    | x == 'p' = tNinetoNum y $ acc ++ "7"
    | x == 'q' = tNinetoNum y $ acc ++ "77"
    | x == 'r' = tNinetoNum y $ acc ++ "777"
    | x == 's' = tNinetoNum y $ acc ++ "7777"
    | x == 't' = tNinetoNum y $ acc ++ "8"
    | x == 'u' = tNinetoNum y $ acc ++ "88"
    | x == 'v' = tNinetoNum y $ acc ++ "888"
    | x == 'w' = tNinetoNum y $ acc ++ "9"
    | x == 'x' = tNinetoNum y $ acc ++ "99"
    | x == 'y' = tNinetoNum y $ acc ++ "999"
    | x == 'z' = tNinetoNum y $ acc ++ "9999"
    | x == ' ' = tNinetoNum y $ acc ++ "0"
    | x == '.' = tNinetoNum y $ acc ++ " "
