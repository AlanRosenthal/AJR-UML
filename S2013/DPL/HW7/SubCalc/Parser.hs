module Parser where --(parseCalcExpr, CalcExpr(..)) where

import Text.ParserCombinators.Parsec
import Text.ParserCombinators.Parsec.Expr

data CalcExpr = Numb Int
              | Var  String
              | Neg  CalcExpr
              | Sum  CalcExpr CalcExpr  
              | Diff CalcExpr CalcExpr
              | Prod CalcExpr CalcExpr  
              | Quot CalcExpr CalcExpr
              | Eq   CalcExpr CalcExpr
              | Gt   CalcExpr CalcExpr
              | Lt   CalcExpr CalcExpr
              | If   CalcExpr CalcExpr CalcExpr
              | Sub  String [String] CalcExpr
              | Call String [CalcExpr]
              deriving (Show)
            
numbExpr :: GenParser Char st CalcExpr
numbExpr = do numb <- many1 digit
              spaces
              return (Numb (read numb :: Int))

varExpr :: GenParser Char st CalcExpr
varExpr = do name <- many1 letter
             spaces
             return (Var name)

defSubExpr :: GenParser Char st CalcExpr
defSubExpr = do keyword "sub"
                name <- many1 letter
                keyword "("
                params <- sepBy (many1 letter) (keyword ",") 
                keyword ")"
                ee <- expr
                keyword "end"
                return (Sub name params ee)

callExpr :: GenParser Char st CalcExpr
callExpr = do name <- many1 letter
              spaces
              keyword "("
              args <- sepBy expr (keyword ",")
              keyword ")"
              return (Call name args)

keyword kw = do { try (string kw); spaces }

operand = try parenExpr <|> ifExpr <|> defSubExpr <|> numbExpr <|> 
          (try callExpr) <|> varExpr

parenExpr = do keyword "("
               ee <- expr
               keyword ")"
               return ee

ifExpr = do keyword "if"
            cond <- expr
            keyword "then"
            case0 <- expr
            keyword "else"
            case1 <- expr
            keyword "end"
            return (If cond case0 case1)

opTable = [[prefix "-" Neg],
           [binary "*" Prod, binary "/" Quot],
           [binary "+" Sum,  binary "-" Diff],
           [binary "==" Eq,  binary ">" Gt, binary "<" Lt]
          ]

binary name fun = Infix  (do { keyword name; return fun }) AssocLeft
prefix name fun = Prefix (do { keyword name; return fun })

expr = do { ee <- exprParser; spaces; return ee }
  where exprParser = buildExpressionParser opTable operand

fullExpr = do ee <- expr
              eof
              return ee

assumeRight (Right vv) = vv
assumeRight (Left  vv) = error (show vv)

parseCalcExpr ss = assumeRight $ parse fullExpr "Parse Error" ss
