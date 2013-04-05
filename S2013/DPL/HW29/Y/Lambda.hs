module Main where

import Parser
import Debug.Trace
import Data.List

main = do
    code <- getContents
    putStrLn $ showLx $ keepsimplify $ parseLambda code

fullState = ['a'..'z']
emptyState = ([],[])
addState st x = union st x

test x = showLx $ simplify $ parseLambda x
test2 x = showLx $ keepsimplify $ parseLambda x

keepsimplify x = keepsimplify' (Number 1000) (replaceSymbolNumber x)
keepsimplify' x y =
--     if x == (trace (showLx y) y)
    if x == y
       then x
       else keepsimplify' y (simplify y)

replaceSymbolNumber (Symbol x) =
    case x of
        'I' -> parseLambda "(&x.x)"
        'S' -> parseLambda "(&w.(&y.(&x.y(wyx))))"
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
        'R' -> replaceSymbolNumber $ parseLambda "Y(&an.Zn0(+n(a(Pn))))"
        'A' -> replaceSymbolNumber $ parseLambda "Y(&an.Zn1(*n(a(Pn))))"
        'L' -> replaceSymbolNumber $ parseLambda "(&a.(&b.(Z(- a b)TF)))"
        'G' -> replaceSymbolNumber $ parseLambda "(&a.(&b.(Z(- b a)TF)))"
        'D' -> replaceSymbolNumber $ parseLambda "(&dabc.Z(Ga(*b(Sc))c(d(ab(Sc)))))"
        '-' -> replaceSymbolNumber $ parseLambda "(&x.(&y.yPx))"
        '/' -> error "Division by repeated subtraction (recursive)"
replaceSymbolNumber (Number x) = 
    if (x == 0)
         then parseLambda "(&s.(&z.z))"
         else replaceSymbolNumber (Apply (Symbol 'S') (Number (x-1)))
replaceSymbolNumber (Apply x y) = (Apply (replaceSymbolNumber x) (replaceSymbolNumber y))
replaceSymbolNumber (Lambda char body) = (Lambda char (replaceSymbolNumber body))
replaceSymbolNumber (Name x) = (Name x)

simplify l@(Apply lambda@(Lambda char body) tree) = 
--     trace ((showLx l) ++ " " ++ (showLx (Apply l' tree))) replace (Name char') tree body'
    replace (Name char') tree body'
    where
        (Lambda char' body') = rename2 lambda (free2 tree emptyState) (free2 lambda emptyState)
--         l'@(Lambda char' body') = rename2 lambda (free2 tree emptyState) (free2 lambda emptyState)

simplify (Apply x y) =
    if (x == x')
       then (Apply x (simplify y))
       else (Apply x' y)
    where
        x' = simplify x
simplify (Lambda char body) = (Lambda char $ simplify body)
simplify x = x

rename2 (Name x) (free,bound) (free',bound') =
    if (and [elem x bound',elem x free])
        then (Name (unused !! (findpos x free)))
        else (Name x)
    where unused = ((((fullState \\ free) \\ bound) \\ free') \\ bound')
rename2 (Apply x y) st st' = (Apply (rename2 x st st') (rename2 y st st'))
rename2 l@(Lambda char body) st@(free,bound) st'@(free',bound')  =
    if (elem char free)
        then (Lambda (unused !! (findpos char free)) (rename2 body st st'))
        else (Lambda char (rename2 body st st'))
    where unused = ((((fullState \\ free) \\ bound) \\ free') \\ bound')

free2 (Name x) (stF,stB) = 
    if (elem x stB)
        then (stF,stB)
        else (addState stF [x],stB)
free2 (Apply x y) st = free2 y (free2 x st)
free2 (Lambda char body) (stF,stB) = free2 body (stF,addState stB [char])
    
replace char repwith (Name x) =
    if ((Name x) == char)
       then repwith
       else (Name x)
replace char repwith (Apply x y) = (Apply (replace char repwith x) (replace char repwith y))
replace char repwith (Lambda lchar body) =
    if (char == (Name lchar))
       then (Lambda lchar body)
       else (Lambda lchar $ replace char repwith body)

findpos _ [] = error "Not in list"
findpos x (y:ys) =
    if x == y
       then 0
       else 1 + (findpos x ys)

divisiontest a b c =
    if (a >= b*(c+1))
       then divisiontest a b (c + 1)
       else c