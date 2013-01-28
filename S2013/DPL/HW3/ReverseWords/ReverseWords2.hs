module Main where

main = do
    countStr <- getLine
    let count = (read countStr) :: Int
    workOnLines 1 count reverseWords

workOnLines n lim fn = do
    if n > lim
        then return ()
        else do
            line <- getLine
            putStrLn $ ("Case #" ++ (show n) ++ ": " ++ fn line)
            workOnLines (n + 1) lim fn

-- Note the indentation of the if / then / else here, and the way
-- the else has its own "do" preceeding multiple statements.

reverseWords = id
