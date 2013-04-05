module Main where

import Parser
import Debug.Trace
import Data.List

main = do
    code <- getContents
    putStrLn $ showLx $ keepsimplify (Number 1000) (replaceSymbolNumber (parseLambda code))

fullState = ['a'..'z']

emptyState = []

remState st x =
    [y | y <- st, y /= x]

addState st x =
    union st x

test x = showLx $ simplify $ parseLambda x
test2 x = showLx $ keepsimplify (Number 1000) (replaceSymbolNumber (parseLambda x))

keepsimplify x y =
--     if x == (trace (showLx y) y)
    if x == y
       then x
       else keepsimplify y (simplify y)

test3 x = showLx $ keepaddSymbolNumber (Number 0) (addSymbolNumber $ parseLambda x)

keepaddSymbolNumber x y =
    if x == y
       then x
       else keepaddSymbolNumber y (addSymbolNumber y)

replaceSymbolNumber (Symbol x) =
    case x of
        'I' -> parseLambda "(&x.x)"
        'S' -> parseLambda "(&w.(&y.(&x.y(wyx))))"
--         '+' -> parseLambda "(&x.(&y.x(&w.(&y.(&x.y(wyx))))y))"
        '+' -> replaceSymbolNumber $ parseLambda "(&x.(&y.xSy))"
        '*' -> parseLambda "(&x.(&y.(&z.x(yz))))"
        'T' -> parseLambda "(&xy.x)"
        'F' -> parseLambda "(&xy.y)"
        '∧' -> parseLambda "(&xy.xy(&uv.v))"
        '∨' -> parseLambda "(&xy.x(&uv.u)y)"
        'N' -> parseLambda "(&x.x(&uv.v)(&ab.a))"
        'Z' -> replaceSymbolNumber $ parseLambda "(&x.xFNF)"
--         'P' -> parseLambda "(&n.&f.&x.n(&g.&h.h(gf))(&u.x)(&u.u))"      
        'P' -> replaceSymbolNumber $ parseLambda "(&n.n((&pz.z(S(pT))(pT)))(&z.(z0)0)F)"
        'Y' -> parseLambda "(&g.((&x.g(xx))(&x.g(xx))))"
        'R' -> replaceSymbolNumber $ parseLambda "(&rn.Zn0(nS(r(Pn))))"
--         'A' -> simplify $ parseLambda "(&rn.Zn1(*n(r(Pn))))"
        'A' -> replaceSymbolNumber $ parseLambda "Y(&rn.Zn1(*n(r(Pn))))"
        '-' -> replaceSymbolNumber $ parseLambda "(&x.(&y.yPx))"
        '/' -> error "Division by repeated subtraction (recursive)"

replaceSymbolNumber (Number x) = 
    if (x == 0)
         then parseLambda "(&s.(&z.z))"
         else replaceSymbolNumber (Apply (Symbol 'S') (Number (x-1)))

replaceSymbolNumber (Apply x y) =
    (Apply (replaceSymbolNumber x) (replaceSymbolNumber y))

replaceSymbolNumber (Lambda char body) =
    (Lambda char (replaceSymbolNumber body))

replaceSymbolNumber (Name x) =
    (Name x)

-- addSymbolNumber l@(Lambda s (Lambda z (Name z'))) =
--     if (z == z')
--        then (Number 0)
--        else l
-- 
-- addSymbolNumber l@(Lambda x (Name x')) =
--     if (x == x')
--        then (Symbol 'I')
--        else l
-- 
-- addSymbolNumber l@(Lambda w (Lambda y (Lambda x (Apply (Name y') (Apply (Apply (Name w') (Name y'')) (Name x')))))) = 
--     if (and [w == w',y == y',y == y'',x == x'])
--        then (Symbol 'S')
--        else l
-- 
-- addSymbolNumber l@(Lambda x (Lambda y (Apply (Apply (Name x') (Symbol 'S')) (Name y')))) = 
--     if (and [x == x',y == y'])
--        then (Symbol '+')
--        else l
-- 
-- addSymbolNumber l@(Lambda x (Lambda y (Lambda z (Apply (Name x') (Apply (Name y') (Name z')))))) = 
--     if (and [x == x',y == y',z == z'])
--        then (Symbol '*')
--        else l
-- 
-- addSymbolNumber l@(Lambda x (Lambda y (Name x'))) = 
--     if (and [x == x'])
--        then (Symbol 'T')
--        else l
-- 
-- addSymbolNumber l@(Lambda x (Lambda y (Name y'))) = 
--     if (and [y == y'])
--        then (Symbol 'F')
--        else l
-- 
-- addSymbolNumber l@(Lambda x (Lambda y (Apply (Apply (Name x') (Name y')) (Lambda u (Lambda v (Name v')))))) = 
--     if (and [x == x',y == y',v == v'])
--        then (Symbol '∧')
--        else l
-- 
-- addSymbolNumber l@(Lambda x (Lambda y (Apply (Apply (Name x') (Lambda u (Lambda v (Name u')))) (Name y')))) = 
--     if (and [x == x',y == y',u == u'])
--        then (Symbol '∨')
--        else l
-- 
-- addSymbolNumber l@(Lambda x (Apply (Apply (Name x') (Lambda u (Lambda v (Name v')))) (Lambda a (Lambda b (Name a'))))) = 
--     if (and [x == x',v == v',a == a'])
--        then (Symbol 'N')
--        else l
-- 
-- addSymbolNumber l@(Lambda x (Apply (Apply (Apply (Name x') (Symbol 'F')) (Symbol 'N')) (Symbol 'F'))) = 
--     if (and [x == x'])
--        then (Symbol 'Z')
--        else l
-- 
-- addSymbolNumber l@(Lambda x (Apply (Apply (Apply (Name x') (Number 0)) (Symbol 'N')) (Number 0))) = 
--     if (and [x == x'])
--        then (Symbol 'Z')
--        else l
-- 
-- addSymbolNumber l@(Lambda n (Apply (Apply (Apply (Name n') (Lambda p (Lambda z (Apply (Apply (Name z') (Apply (Symbol 'S') (Apply (Name p') (Symbol 'T')))) (Apply (Name p'') (Symbol 'T')))))) (Lambda z''' (Apply (Apply (Name z'''') (Number 0)) (Number 0)))) (Symbol 'F'))) = 
--     if (and [n == n',p == p',p == p'',z == z',z''' == z''''])
--        then (Symbol 'P')
--        else l
-- 
-- addSymbolNumber l@() = 
--     if (and [])
--        then (Symbol 'Y')
--        else l
-- 
-- addSymbolNumber l@() = 
--     if (and [])
--        then (Symbol 'R')
--        else l



addSymbolNumber l@(Apply (Symbol 'S') (Number x)) = 
    (Number (x+1))
addSymbolNumber (Apply x y) =
    (Apply (addSymbolNumber x) (addSymbolNumber y))

addSymbolNumber (Lambda char body) = 
    (Lambda char (addSymbolNumber body))

addSymbolNumber (Name x) = 
    (Name x)

addSymbolNumber (Symbol x) =
    (Symbol x)

addSymbolNumber (Number x) = 
    (Number x)


simplify (Apply (Lambda char body) tree) = 
--     trace ("\nApply [Lambda {" ++ [char] ++ "} -> " ++ showLx body ++ "] TO " ++ showLx tree) $ replace (Name char') tree body'
    replace (Name char') tree body'
    where st = (free2 tree (emptyState,emptyState))
          (Lambda char' body') = rename2 (Lambda char body) st (free2 (Lambda char body) (emptyState,emptyState))

simplify (Apply x y) =
    if (x == x')
       then (Apply x (simplify y))
       else (Apply x' y)
    where
        x' = simplify x
   --     compressApply $ simplifyApply $ expandApply (Apply x y)
--     where expanded = expandApply (Apply x y)
--     trace ("\nApply: " ++ showLx x ++ " TO " ++ showLx y) $ (Apply (simplify x) (simplify y))
--     compressApply $ simplifyApply $ (expandApply (Apply x y))
--     compressApply $ foldl (\a b -> a ++ b) [] $ map expandApply $ simplifyApply $ expandApply (Apply x y)        

simplify (Lambda char body) =
--     trace ("\nLambda: {" ++ [char] ++ "} -> " ++ showLx body) $ (Lambda char $ simplify body)
    (Lambda char $ simplify body)

simplify x = 
--     trace ("\nFALL OFF EDGE: " ++ showLx x) x
    x
    
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

expandApply (Apply a b) =
   (expandApply a) ++ [b]
   
expandApply x = [x]

expandApplytest x = expandApply $ parseLambda x

simplifyApply [] = []

simplifyApply ((Lambda char body):x:xs) = 
    (simplify (Apply (Lambda char body) x)) : simplifyApply xs

simplifyApply ((Apply x y):xs) =
    (compressApply (simplifyApply (expandApply (Apply x y)))) : simplifyApply xs          
    
simplifyApply (x:xs) =
    x : simplifyApply xs
    
compressApply [x] = x

compressApply (xs) =
    (Apply (compressApply (init xs)) (last xs))

rename2 (Name x) (free,_) (_,bound) =
    if (elem x bound)
        then if (elem x free)
            then (Name (((fullState \\ free) \\ bound) !! (findpos x free)))
            else (Name x)
        else (Name x)

rename2 (Apply x y) st st' =
    (Apply (rename2 x st st') (rename2 y st st'))

rename2 (Lambda char body) st@(free,_) st'@(_,bound)  =
    if (elem char free)
        then (Lambda (((fullState \\ free) \\ bound) !! (findpos char free)) (rename2 body st st'))
        else (Lambda char (rename2 body st st'))

rename2test x y =
    rename2 (parseLambda x) (free2 (parseLambda y) (emptyState,emptyState)) (free2 (parseLambda x) (emptyState,emptyState))

freetest2 x =
    free2 (parseLambda x) (emptyState,emptyState)

free2 (Name x) (stF,stB) = 
    if (elem x stB)
        then (stF,stB)
        else (addState stF [x],stB)

free2 (Apply x y) st = 
    free2 y st'
    where
        st' = free2 x st

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

printlist [] =  return ()
printlist (x:xs) = 
    do print x
       printlist xs
