module Parser where

import Text.ParserCombinators.Parsec
import Text.ParserCombinators.Parsec.Char
import Data.Char

data LambdaTree = Lambda Char LambdaTree
                | Name Char
                | NormLambda Int LambdaTree
                | NormName Int
                | Apply LambdaTree LambdaTree
  deriving (Show, Eq)

showLx (Lambda vv tt)     = "(&" ++ [vv] ++ "." ++ showLx tt ++ ")"
showLx (Name vv)          = [vv]
showLx (NormLambda ii tt) = "(&[" ++ show ii ++ "]." ++ showLx tt ++ ")"
showLx (NormName ii)      = "[" ++ show ii ++ "]"
showLx (Apply aa bb@(Apply _ _)) =
  showLx aa ++ "(" ++ showLx bb ++ ")"
showLx (Apply aa bb)  = showLx aa ++ showLx bb

nameExpr = 
  do nn <- lower
     spaces
     return (Name nn)

makeLambda :: [Char] -> LambdaTree -> LambdaTree
makeLambda [nn]    bb = Lambda nn bb
makeLambda (nn:ns) bb = Lambda nn (makeLambda ns bb)

lambdaExpr :: GenParser Char st LambdaTree
lambdaExpr =
  do char '&'
     spaces
     ns <- many1 lower
     spaces
     char '.'
     spaces
     ee <- expr
     spaces
     return (makeLambda ns ee)

parenExpr =
  do char '('
     spaces
     ee <- expr
     spaces
     char ')'
     spaces
     return ee

simpleExpr = nameExpr <|> lambdaExpr <|> parenExpr

expr =
  do es <- many1 simpleExpr
     spaces
     return $ foldl1 Apply es

fullExpr :: GenParser Char st LambdaTree
fullExpr =
  do spaces
     ee <- expr
     spaces
     eof
     return ee

parseLambda ss =
  case parse fullExpr "error" ss of
    Left  ee -> error (show ee)
    Right tt -> tt 
