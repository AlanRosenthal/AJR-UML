module ParseTree where

data ParseTree = PtNum  Int
               | PtStr  String
               | PtSymb String
               | PtBop  String ParseTree ParseTree
               | PtFun  [String] ParseTree
               | PtCall ParseTree [ParseTree]
               | PtArr  [ParseTree]
               | PtComp [ParseTree]
               | PtIf   ParseTree ParseTree ParseTree
               | PtFor  String ParseTree ParseTree
              deriving (Show, Eq)
