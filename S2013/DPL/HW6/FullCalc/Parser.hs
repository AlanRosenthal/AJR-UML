module Parser where --(parseCalcExpr, CalcExpr(..)) where

import Text.ParserCombinators.Parsec
import Text.ParserCombinators.Parsec.Expr

data CalcExpr = Numb Int
              | Name String
              | Neg  CalcExpr   
              | Sum  CalcExpr CalcExpr  
              | Diff CalcExpr CalcExpr
              | Prod CalcExpr CalcExpr  
              | Quot CalcExpr CalcExpr
              | Set  CalcExpr CalcExpr
              | Eq   CalcExpr CalcExpr
              | Gt   CalcExpr CalcExpr
              | Lt   CalcExpr CalcExpr
              | If   CalcExpr CalcExpr
              | While CalcExpr CalcExpr
              deriving (Show)
            
numbExpr :: GenParser Char st CalcExpr
numbExpr = do numb <- many1 digit
              spaces
              return (Numb (read numb :: Int))

nameExpr :: GenParser Char st CalcExpr
nameExpr = do name <- many1 letter
	      spaces
	      return (Name name)

keyword kw = do { try (string kw); spaces }

parenExpr = try (parens expr) <|> ifExpr <|> whileExpr <|> numbExpr <|> nameExpr
            
parens p = do keyword "("
              ee <- p
              keyword ")"
              return ee

ifExpr = do   keyword "if"
              cond <- expr
              keyword "do"
              body <- expr
              keyword "end"
              return (If cond body)
            
whileExpr = do  keyword "while"
                cond <- expr
                keyword "do"
                body <- expr
                keyword "end"
                return (While cond body)
            
            
opTable = [[prefix "-" Neg],
           [binary "*" Prod, binary "/" Quot],
           [binary "+" Sum,  binary "-" Diff],
           [binary "==" Eq,  binary ">" Gt, binary "<" Lt],
	   [binary "=" Set]]

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
