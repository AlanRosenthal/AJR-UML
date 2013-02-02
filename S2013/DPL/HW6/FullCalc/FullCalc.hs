module Main where 

import System.Console.Readline
import Parser

{-
  An env is a map from String to Int implemented
  as a list of (key, value) pairs.

  New, add, delete, and update operations are
  provided.
-}

emptyEnv :: [(String, Int)]
emptyEnv = []

delEnv []         name = []
delEnv ((n,v):xs) name =
  if n == name
  then delEnv xs name
  else (n,v) : delEnv xs name

addEnv env name value = (name, value) : delEnv env name

getEnv []         name = 0
getEnv ((n,v):xs) name =
  if n == name
  then v
  else getEnv xs name

{-
  evalBinOp, evalBoolOp

  These helper functions make definitions of boolean
  and numeric binary operators more clear and concise.
-}

evalBinOp op aa bb env = (xx `op` yy, env'') 
  where (xx, env')  = eval aa env
        (yy, env'') = eval bb env'

evalBoolOp op aa bb env = (truth, env'')
  where (xx, env')  = eval aa env
        (yy, env'') = eval bb env'
        truth = if xx `op` yy then 1 else 0

{-
  eval

  Evaluate an abstract syntax tree. With
  FullCalc, we're interested both in the
  value of an expression and how it modifies
  the current environment.
-}

eval :: CalcExpr -> [(String, Int)] -> (Int, [(String, Int)])

eval (Numb nn) env = (nn, env)

eval (Name ss) env = (getEnv env ss, env)

eval (Neg  ee) env = (-nn, env')
  where (nn, env') = eval ee env

eval (Sum  aa bb) env = evalBinOp (+) aa bb env
eval (Diff aa bb) env = evalBinOp (-) aa bb env
eval (Prod aa bb) env = evalBinOp (*) aa bb env
eval (Quot aa bb) env = evalBinOp div aa bb env

eval (Gt aa bb) env = evalBoolOp (>)  aa bb env
eval (Eq aa bb) env = evalBoolOp (==) aa bb env
eval (Lt aa bb) env = evalBoolOp (<)  aa bb env

eval (Set (Name ss) vv) env = (xx, env'')
  where (xx, env') = eval vv env
        env''      = addEnv env' ss xx

eval (If cond body) env = (vv, env'')
  where (xx, env')  = eval cond env
        (vv, env'') = if xx /= 0 
                      then eval body env' 
                      else (0, env')

eval (While cond body) env = (vv, env'')
  where (xx, env')  = eval cond env
        (_,env''') = eval body env'
        (vv, env'') = if xx /= 0 
                      then eval (While cond body) env'''
                      else (0, env')
{-
  readLoop
  This function provides an interactive shell and calls
  a function (fn) on each line of input. That function
  is also passed the state (st) and returns an updated
  version of it.
-}

readLoop :: String -> (String -> a -> IO a) -> a -> IO a
readLoop prompt fn st = 
  do maybeLine <- readline prompt
     case maybeLine of
       Just line -> do st' <- fn (line) st
                       readLoop prompt fn st'
       Nothing   -> return st

{-
  evalPrint

  Evaluate an expression and print the result.
-}

evalPrint :: String -> [(String, Int)] -> IO [(String, Int)]
evalPrint line st =
  let expr      = parseCalcExpr line
      (vv, st') = eval expr st
  in do print vv
        return st'

main = readLoop "(FullCalc) " evalPrint emptyEnv
