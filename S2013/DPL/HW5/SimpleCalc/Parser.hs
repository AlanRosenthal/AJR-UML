module Parser where

import Text.ParserCombinators.Parsec
import Text.ParserCombinators.Parsec.Expr

data CalcExpr = Numb Int        
              | Neg  CalcExpr   
              | Sum  CalcExpr CalcExpr  
              | Diff CalcExpr CalcExpr
              | Prod CalcExpr CalcExpr  
              | Quot CalcExpr CalcExpr
              | Exp  CalcExpr CalcExpr
              deriving (Show)
            
numbExpr :: GenParser Char st CalcExpr
numbExpr = do numb <- many1 digit
              spaces
              return (Numb (read numb :: Int))

keyword kw = do { try (string kw); spaces }

parenExpr = try (parens expr) <|> numbExpr

parens p = do keyword "("
              ee <- p
              keyword ")"
              return ee

opTable = [[prefix "-" Neg],
           [binary "^" Exp],
           [binary "*" Prod, binary "/" Quot],
           [binary "+" Sum,  binary "-" Diff]]

binary name fun = Infix  (do { keyword name; return fun }) AssocLeft
prefix name fun = Prefix (do { keyword name; return fun })

expr = do { ee <- exprParser; spaces; return ee }
  where exprParser = buildExpressionParser opTable parenExpr

fullExpr = do ee <- expr
              eof
              return ee

assumeRight (Right vv) = vv
assumeRight (Left  vv) = error (show vv)

parseCalcExpr ss = assumeRight $ parse fullExpr "Parse Error" ss
