module Main where 

import qualified Data.Map as Map
import Data.Map (Map)
import Data.List (mapAccumL, zip)
import System.Console.Readline
import Parser

{-
  The state of the SubCalc interpreter consists of
  two separate environments (name -> value maps):
   - VarEnv maps names to (integer) variables.
   - SubEnv maps names to subroutines.

  Since the language can distinguish between these
  two kinds of name by syntactic context, we can
  just keep them as two separate environments.
-}

data CalcState = CalcState (Map String Int) (Map String ([String], CalcExpr)) deriving (Show)

emptyState = CalcState Map.empty Map.empty

addVar (CalcState vars subs) name val = 
    (CalcState (Map.insert name val vars) subs)

addVars st [] [] = st
addVars (CalcState vars subs) (name:names) (val:vals) =
    addVars (CalcState (Map.insert name val vars) subs) names vals
-- addVars (CalcState vars subs) (name:names) (val:vals) = st
--   where (_,val') = eval emptyState val
--         st = addVars (CalcState (Map.insert name val' vars) subs) names vals
    
getVar (CalcState vars _) name =
    case Map.lookup name vars of
        Just val -> val
        Nothing  -> error "No such var"

addSub (CalcState vars subs) name sub = 
    (CalcState vars (Map.insert name sub subs))
getSub (CalcState _ subs) name =
    case Map.lookup name subs of
        Just sub -> sub
        Nothing  -> error "No such sub"

{-
  evalBinOp, evalBoolOp

  These helper functions make definitions of boolean
  and numeric binary operators more clear and concise.
-}

evalBinOp st op aa bb = (st'', xx `op` yy)
  where (st', xx)  = eval st aa
        (st'', yy) = eval st' bb

evalBoolOp st op aa bb = (st'', truth)
  where (st', xx)  = eval st aa
        (st'', yy) = eval st bb
        truth = if xx `op` yy then 1 else 0

{-
  eval

  Evaluate an abstract syntax tree. With
  FullCalc, we're interested both in the
  value of an expression and how it modifies
  the current environment.
-}

eval :: CalcState -> CalcExpr -> (CalcState, Int)

eval st (Numb nn) = (st, nn)

eval st (Var name) = (st, getVar st name)

eval st (Neg ee) = (st', -nn)
  where (st', nn) = eval st ee

eval st (Sum  aa bb) = evalBinOp st (+) aa bb
eval st (Diff aa bb) = evalBinOp st (-) aa bb 
eval st (Prod aa bb) = evalBinOp st (*) aa bb
eval st (Quot aa bb) = evalBinOp st div aa bb

eval st (Gt aa bb) = evalBoolOp st (>)  aa bb
eval st (Eq aa bb) = evalBoolOp st (==) aa bb
eval st (Lt aa bb) = evalBoolOp st (<)  aa bb

eval st (If cond case0 case1) = (st'', vv)
  where (st', xx)  = eval st cond
        (st'', vv) = if xx /= 0 
                      then eval st' case0
                      else eval st' case1

{-
 TODO: 
    - eval st (Sub ...)
        Should allow a sub to be defined. That means
        updating the state with the info needed to call
        the sub later.

    - eval st (Call ...)
        Should allow a sub to be called. That means
        creating a temporary environment that binds the
        evaluated arguments to the sub parameters and
        then evaluating the sub body in that environment.
-}

eval st (Sub name params body) = (st', 0)
    where st' = addSub st name (params, body)


eval st (Call name args) = (st, result)   --name: name of sub, args: arguments to sub (values)
    where (argnames,body) = (getSub st name) --get the sub, argnames:arguments to sub (names), body: CalcExpr
          st' = addVars st argnames (map snd (map (eval st) args))     --add the variables to temp state
          (_,result) = eval st' body --eval

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

evalPrint :: String -> CalcState -> IO CalcState
evalPrint line st =
  let expr      = parseCalcExpr line
      (st', vv) = eval st expr
  in do print vv
        return st'

main = readLoop "(SubCalc) " evalPrint emptyState
