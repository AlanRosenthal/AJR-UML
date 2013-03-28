module Main where
import Parser
import Debug.Trace
import Data.List

main = do
    code <- getContents
    putStrLn $ showLx $ keepsimplify (Number 1000) (parseLambda code)

fullState = ['a'..'z']

emptyState = []

remState st x =
    [y | y <- st, y /= x]

addState st x =
    st ++ x

test x = showLx $ simplify $ parseLambda x
test2 x = showLx $ keepsimplify (Number 1000) (parseLambda x)

keepsimplify x y =
    if x == (trace (showLx y) y)
--     if x == y
       then x
       else keepsimplify y (simplify y)

simplify (Symbol x) =
    case x of
         'I' -> parseLambda "(&x.x)"
         'S' -> parseLambda "(&w.(&y.(&x.y(wyx))))"
         
simplify (Number x) =
    if (x == 0)
         then parseLambda "(&s.(&z.z))"
         else simplify (Apply (Symbol 'S') (Number (x-1)))
       
       
simplify (Apply (Lambda char body) tree) = 
    replace (Name char) tree body'
    where st = (free2 tree (emptyState,emptyState))
          body' = rename2 body st (free2 body (emptyState,emptyState))

simplify (Apply x y) =
    (Apply (simplify x) (simplify y))

simplify (Lambda char body) =
    (Lambda char $ simplify body)

simplify x = x

-- rename (Name x) (stF,stB,stU) = 
--     if (elem x stF)
--        then (Name (stU !! (findpos x stF)))
--        else (Name x)
-- 
-- rename (Apply x y) st =
--     (Apply (rename x st) (rename y st))
-- 
-- rename (Lambda char body) (stF,stB,stU) = 
--     if (elem char stF)
--        then (Lambda (stU !! (findpos char stF)) (rename body (stF,stB,stU)))
--        else (Lambda char (rename body (stF,stB,stU)))

rename2 (Name x) (stF,_) (_,stB') =
    if (elem x stB')
        then if (elem x stF)
            then (Name (((['a'..'z'] \\ stF) \\ stB') !! (findpos x stF)))
            else (Name x)
        else (Name x)

rename2 (Apply x y) st st' =
    (Apply (rename2 x st st') (rename2 y st st'))

rename2 (Lambda char body) (stF,stB) (stF',stB')  =
    if (elem char stF)
        then (Lambda (((['a'..'z'] \\ stF) \\ stB') !! (findpos char stF)) (rename2 body (stF,stB) (stF',stB')))
        else (Lambda char (rename2 body (stF,stB) (stF',stB')))

--     trace ("free: " ++ stF ++ "\n" ++ "bound:" ++ stB') (Lambda char body)
       
rename2test x y =
    rename2 (parseLambda x) (free2 (parseLambda y) (emptyState,emptyState)) (free2 (parseLambda x) (emptyState,emptyState))
    
freetest2 x =
    free2 (parseLambda x) (emptyState,emptyState)

free2 (Number x) st = st
free2 (Symbol x) st = st
free2 (Name x) (stF,stB) = 
    if (elem x stB)
        then (stF,stB)
        else (addState stF [x],stB)

free2 (Apply x y) st = 
    free2 x (free2 y st)

free2 (Lambda char body) (stF,stB) =
    free2 body (stF,addState stB [char])

-- free (Name x) (stF,stB,stU) = 
--     if (elem x stB)
--         then (stF,stB,stU)
--         else (addState stF [x],stB,remState stU x)
-- 
-- free (Apply x y) st = 
--     free x (free y st)
-- 
-- free (Lambda char body) (stF,stB,stU) =
--     free body (stF,addState stB [char],remState stU char)

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