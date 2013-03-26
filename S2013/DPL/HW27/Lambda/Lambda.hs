module Main where
import Parser

main = do
  code <- getContents
  putStrLn code
