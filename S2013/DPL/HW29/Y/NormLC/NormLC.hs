module Main where

import Data.Map (Map)
import qualified Data.Map as M

import Control.Monad.State

import Parser

norm :: LambdaTree -> State (Int, Map Char Int) LambdaTree

norm (Lambda vv bb) = do
  (ii, vars) <- get
  put (ii + 1, M.insert vv ii vars)
  bb' <- norm bb
  (jj, _) <- get
  put (jj, vars)
  return $ NormLambda ii bb'

norm (Name vv) = do
  (ii, vars) <- get
  if M.member vv vars
    then do
      return $ NormName (vars M.! vv)
    else do
      let vars' = M.insert vv ii vars
      put (ii + 1, vars')
      return $ NormName ii

norm (Apply aa bb) = do
  aa' <- norm aa
  bb' <- norm bb
  return $ Apply aa' bb'

normalize :: LambdaTree -> LambdaTree
normalize tt = evalState (norm tt) (1, M.empty)

main = do
  code <- getContents
  let tr0 = parseLambda code
      tr1 = normalize tr0
  putStrLn $ showLx tr1
