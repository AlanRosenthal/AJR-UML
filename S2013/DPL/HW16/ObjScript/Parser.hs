module Parser where --(parseCalcExpr, CalcExpr(..)) where

import Text.ParserCombinators.Parsec
import Text.ParserCombinators.Parsec.Expr

import ParseTree
import Utils (split, join)

reservedWords = ["if", "then", "else", "end", "for", "fun", "in"]
            
number :: GenParser Char st Int
number = do numb <- many1 digit
            spaces
            return (read numb :: Int)

symbol1 :: GenParser Char st String
symbol1 = do name <- many1 letter
             spaces
             if name `elem` reservedWords
                 then fail ("Reserved Word: " ++ name)
                 else return name

symbol = try symbol1

stringLit :: GenParser Char st String
stringLit = do string "\""
               text <- manyTill anyChar (string "\"")
               spaces
               return text

keyword kw = do try (string kw)
                spaces

numbExpr = do nn <- number
              return (PtNum nn)

symbExpr = do ss <- sepBy1 symbol (keyword ".")
              spaces
              return (PtSymb (join "." ss))

stringExpr = do text <- stringLit
                return (PtStr text)

arrayExpr = do keyword "["
               items <- sepEndBy opExpr (keyword ",")
               keyword "]"
               return (PtArr items)

funExpr :: GenParser Char st ParseTree
funExpr = do keyword "fun"
             keyword "("
             params <- sepBy (many1 letter) (keyword ",") 
             keyword ")"
             body <- compExpr
             keyword "end"
             return (PtFun params body)

callExpr :: GenParser Char st ParseTree
callExpr = do func <- symbExpr
              keyword "("
              args <- sepBy opExpr (keyword ",")
              keyword ")"
              return (PtCall func args)

parenExpr = do keyword "("
               ee <- opExpr
               keyword ")"
               return ee

forExpr = do keyword "for"
             keyword "("
             name <- symbol
             keyword "in"
             seq  <- opExpr
             keyword ")"
             body <- compExpr
             keyword "end"
             return (PtFor name seq body)

ifExpr = do keyword "if"
            keyword "("
            cond <- opExpr
            keyword ")"
            case0 <- compExpr
            keyword "else"
            case1 <- compExpr
            keyword "end"
            return (PtIf cond case0 case1)

nopExpr = parenExpr <|> ifExpr <|> forExpr <|> funExpr <|> arrayExpr <|>
          numbExpr <|> stringExpr <|> try callExpr <|> symbExpr

op name = Infix (do { keyword name; return (PtBop name) }) AssocLeft

opTable = [[op "*", op "/", op "%"],
           [op "+", op "-"],
           [op "<=", op ">=", op ">", op "<"],
           [op "==", op "!="],
           [op "||", op "&&"],
           [op "=", op ":="]]

opExpr = buildExpressionParser opTable nopExpr

compExpr = do
    spaces
    es <- sepEndBy opExpr (keyword ";")
    spaces
    return (PtComp es)

objExpr = do
    ee <- compExpr
    eof
    return ee

parseString ss = parse objExpr "" ss
