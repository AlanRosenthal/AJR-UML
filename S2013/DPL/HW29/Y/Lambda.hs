module Main where

import Parser

-- Your program should expand these symbols:
symb 'I' = "(&x.x)"
symb 'S' = "(&wyx.y(wyx))"
symb '+' = "(&xy.xSy)"
symb '*' = "(&xyz.x(yz))"
symb 'T' = "(&xy.x)"
symb 'F' = "(&xy.y)"
symb '∧' = "(&xy.xy(&uv.v))"
symb '∨' = "(&xy.x(&uv.u)y)"
symb 'N' = "(&x.x(&uv.v)(&ab.a))"
symb 'Z' = "(&x.xFNF)"
symb 'P' = "(&n.&f.&x.n(&g.&h.h(gf))(&u.x)(&u.u))"
symb 'Y' = "(&g.((&x.g(xx))(&x.g(xx))))"

-- Additionally, you should figure out the following functions
-- in the lambda calculus and expand them too:
symb 'A' = error "Factorial function"
symb '-' = error "Subtraction"
symb '/' = error "Division by repeated subtraction (recursive)"

main :: IO ()
main = do
  code <- getContents
  putStrLn $ code
