module Main where

import System.Console.Readline
import Parser

{-
  eval

  Takes an abstract syntax tree and evaluates recursively
  to produce the numeric value of the expression it represents.
-}

eval (Numb nn) = nn
eval (Neg  nn) = -(eval nn)

eval (Sum  aa bb) = eval aa + eval bb
eval (Diff aa bb) = eval aa - eval bb
eval (Prod aa bb) = eval aa * eval bb 
eval (Quot aa bb) = eval aa `div` eval bb
eval (Exp aa bb) = eval aa ^ eval bb

{- 
  evalPrint

  Takes a line of text, parses it to an AST, evaluates the AST,
  and prints the result.
-}

evalPrint line =
  let expr = parseCalcExpr line in
  print (eval expr)

{-
  readLoop

  Prints a prompt, reads a line of input from the user,
  and calls a function. This is repeated until the user
  enters EOF.
-}

readLoop :: String -> (String -> IO ()) -> IO ()
readLoop prompt fn = 
  do maybeLine <- readline prompt
     case maybeLine of
       Just line -> do fn (line)
                       readLoop prompt fn
       Nothing   -> return ()

main = readLoop "(SimpleCalc) " evalPrint
