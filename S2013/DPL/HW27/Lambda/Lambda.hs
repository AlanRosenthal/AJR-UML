module Main where
import Parser
import Debug.Trace

main = do
    code <- getContents
    putStrLn $ showLx $ keepsimplify (Number 0) (simplify $ parseLambda code)

fullState = ['a'..'z']

emptyState = []

remState st x =
    [y | y <- st, y /= x]

addState st x =
    st ++ x

test x = simplify $ parseLambda x

keepsimplify x y =
    if x == y
       then x
       else keepsimplify y (simplify y)


simplify (Apply (Lambda char body) tree) = 
    replace (Name char) tree body'
    where st = (free tree (emptyState,emptyState,fullState))
          body' = rename body st

simplify (Apply x y) =
    (Apply (simplify x) (simplify y))

simplify (Lambda char body) =
    (Lambda char $ simplify body)

simplify x = x

rename (Name x) (stF,stB,stU) = 
    if (elem x stF)
       then (Name (stU !! (findpos x stF)))
       else (Name x)

rename (Apply x y) st =
    (Apply (rename x st) (rename y st))

rename (Lambda char body) (stF,stB,stU) = 
    if (elem char stF)
       then (Lambda (stU !! (findpos char stF)) (rename body (stF,stB,stU)))
       else (Lambda char (rename body (stF,stB,stU)))

free (Name x) (stF,stB,stU) = 
    if (elem x stB)
        then (stF,stB,stU)
        else (addState stF [x],stB,remState stU x)

free (Apply x y) st = 
    free x (free y st)

free (Lambda char body) (stF,stB,stU) =
    free body (stF,addState stB [char],remState stU char)

replace char repwith (Name x) =
    if ((Name x) == char)
       then repwith
       else (Name x)

replace char repwith (Apply x y) =
    (Apply (replace char repwith x) (replace char repwith y))

replace char repwith (Lambda lchar body) =
    if (char == (Name lchar))
       then (Lambda lchar body)
       else (Lambda lchar $ replace char repwith body)

findpos _ [] = error "Not in list"
findpos x (y:ys) =
    if x == y
       then 0
       else 1 + (findpos x ys)