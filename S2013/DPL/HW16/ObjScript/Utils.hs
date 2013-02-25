module Utils where

import Data.List
import Data.Maybe

split :: String -> String -> [String]
split _     [] = []
split [sep] xs =
  if sep `elem` xs
    then takeWhile (/=sep) xs : split [sep] (drop 1 (dropWhile (/=sep) xs))
    else [xs]
split _ _ = error "Don't actually need multi-character separators"

join :: String -> [String] -> String
join = intercalate
