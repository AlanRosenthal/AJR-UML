;Alan Rosenthal
;November 27, 2012
;A8

#lang plai

(define-type AEV
  [num (n number?)]
  [add (lhs AEV?)
       (rhs AEV?)]
  [mul (lhs AEV?)
       (rhs AEV?)]
  [pow (lhs AEV?)
       (rhs number?)]
  [ident (n symbol?)])

(print-only-errors #t)

;; (parse s) -> AEV?
;; s : list?
(define parse
  (lambda (s)
    (cond
      [(number? s) (num s)]
      [(symbol? s) (ident s)]
      [(list? s)
       (case (first s)
         [(+)
          (if (equal? (length s) 3)
              (add (parse (second s)) (parse (third s)))
              (error "Invalid Number of Parameters for +"))]
         [(*)
          (if (equal? (length s) 3)
              (mul (parse (second s)) (parse (third s)))
              (error "Invalid Number of Parameters for *"))]
         [(^)
          (if (equal? (length s) 3)
              (if (number? (third s))
                  (pow (parse (second s)) (third s))
                  (error "Last Parameter must be a number for ^"))
              (error "Invalid Number of Parameters for ^"))]
         [else
          (if (and (> (length s) 1) (symbol? (second s)))
              (ident (second s))
              (error "Unkonwn Inital Symbol"))])]
      [(error "Unexpected expression")])))
(test (add (num 1) (num 2)) (parse '(+ 1 2)))
(test (mul (num 1) (num 2)) (parse '(* 1 2)))
(test (pow (num 1) 2) (parse '(^ 1 2)))
(test (ident 'x) (parse 'x))
(test (num 10) (parse 10))
(test (add (num 1) (add (num 2) (add (num 3) (num 4)))) (parse '(+ 1 (+ 2 (+ 3 4)))))
(test/exn (parse '(+)) "Invalid Number of Parameters for +")
(test/exn (parse '(+ 1)) "Invalid Number of Parameters for +")
(test/exn (parse '(+ 1 2 3)) "Invalid Number of Parameters for +")
(test/exn (parse '(*)) "Invalid Number of Parameters for *")
(test/exn (parse '(* 1)) "Invalid Number of Parameters for *")
(test/exn (parse '(* 1 2 3)) "Invalid Number of Parameters for *")
(test/exn (parse '(^)) "Invalid Number of Parameters for ^")
(test/exn (parse '(^ 1)) "Invalid Number of Parameters for ^")
(test/exn (parse '(^ 1 2 3)) "Invalid Number of Parameters for ^")
(test/exn (parse '(^ 2 'x)) "Last Parameter must be a number for ^")
(test/exn (parse '(& 3 2)) "Unkonwn Inital Symbol")
(test/exn (parse +) "Unexpected expression")

;; (derivative exp x) -> AEV?
;; exp : AEV?
;; x : symbol?
(define derivative
  (lambda (exp x)
    (type-case AEV exp
      [add (f g)
           (add (derivative f x) (derivative g x))]
      [mul (f g)
           (add (mul f (derivative g x)) (mul g (derivative f x)))]
      [pow (f n)
           (mul (mul (num n) (pow f (- n 1))) (derivative f x))]
      [ident (n)
             (if (equal? n x)
                 (num 1)
                 (num 0))]
      [num (n)
           (num 0)])))
(test (add (num 1) (num 1)) (derivative (add (ident 'x) (ident'x)) 'x))
(test (add (mul (ident 'x) (num 0)) (mul (ident 'y) (num 1))) (derivative (mul (ident 'x) (ident 'y)) 'x))
(test (mul (mul (num 5) (pow (ident 'x) 4)) (num 1)) (derivative (pow (ident 'x) 5) 'x))
(test (num 1) (derivative (ident 'x) 'x))
(test (num 0) (derivative (ident 'y) 'x))
(test (num 0) (derivative (num 100) 'x))

;; (simplify exp) -> AEV?
;; exp : AEV?
(define simplify
  (lambda (exp)
    (type-case AEV exp
      [add (l r)
           (cond 
             ;A: (+ <num1> <num2>) => <num1> + <num2>
             [(and (num? (simplify l)) (num? (simplify r)))
              (num (+ (num-n (simplify l)) (num-n (simplify r))))]
             ;B: (+ 0 <AEV>) => <AEV>
             [(and (num? (simplify l)) (equal? (num-n (simplify l)) 0) (AEV? (simplify r)))
              (simplify r)]
             ;C: (+ <AEV> 0) =? <AEV>
             [(and (num? (simplify r)) (equal? (num-n (simplify r)) 0) (AEV? (simplify l)))
              (simplify l)]
             [else (add (simplify l) (simplify r))])]
      [mul (l r)
           (cond
             ;D: (* <num1> <num2>) => <num1> * <num2>
             [(and (num? (simplify l)) (num? (simplify r)))
              (num (* (num-n (simplify l)) (num-n (simplify r))))]
             ;E: (* 0 <AEV>) => 0
             [(and (num? (simplify l)) (equal? (num-n (simplify l)) 0) (AEV? (simplify r)))
              (num 0)]
             ;F: (* <AEV> 0) => 0
             [(and (num? (simplify r)) (equal? (num-n (simplify r)) 0) (AEV? (simplify l)))
              (num 0)]
             ;G: (* 1 <AEV>) => <AEV>
             [(and (num? (simplify l)) (equal? (num-n (simplify l)) 1) (AEV? (simplify r)))
              (simplify r)]
             ;H: (* <AEV> 1) => <AEV>
             [(and (num? (simplify r)) (equal? (num-n (simplify r)) 1) (AEV? (simplify l)))
              (simplify l)]
             [else (mul (simplify l) (simplify r))])]
      [pow (l r)
           (cond
             ;I: (^ <AEV> 0) => 1
             [(and (equal? r 0))
              (num 1)]
             ;J: (^ <AEV> 1) => <AEV>
             [(and (equal? r 1))
              (simplify l)]
             [else (pow (simplify l) r)])]
      
      [ident (n) (ident n)]
      [num (n) (num n)])))
(test (num 10) (simplify (parse '(+ 5 5))))
(test (num 0) (simplify (parse '(+ 5 -5))))
(test (ident 'x) (simplify (parse '(+ 0 'x))))
(test (ident 'x) (simplify (parse '(+ 'x 0))))
(test (num 10) (simplify (parse '(* 2 5))))
(test (num 0) (simplify (parse '(* 'x 0))))
(test (num 0) (simplify (parse '(* 0 'x))))
(test (ident 'x) (simplify (parse '(* 'x 1))))
(test (ident 'x) (simplify (parse '(* 1 'x))))
(test (ident 'x) (simplify (parse '(^ 'x 1))))
(test (num 1) (simplify (parse '(^ 'x 0))))
(test (num 10) (simplify (parse '(^ (* (+ 1 (+ 1 (+ 7 1))) 1) 1))))


;; (AEV->sexp exp) -> AEV?
;; exp : AEV?
(define AEV->sexp
  (lambda (exp)
    (type-case AEV exp
      [num (n)
           n]
      [ident (n)
             (string->symbol (symbol->string n))]
      [add (l r)
           (list '+ (AEV->sexp l) (AEV->sexp r))]
      [mul (l r)
           (list '* (AEV->sexp l) (AEV->sexp r))]
      [pow (l n)
           (list '^ (AEV->sexp l) n)])))
(let ([a '(+ 1 2)]) (test a (AEV->sexp(parse a))))
(let ([a '(+ 3 x)]) (test a (AEV->sexp(parse a))))
(let ([a '(* 3 x)]) (test a (AEV->sexp(parse a))))
(let ([a '(^ x 3)]) (test a (AEV->sexp(parse a))))
(let ([a '(* (+ 3 2) (^ x 2))]) (test a (AEV->sexp(parse a))))

;; (do-all sexp) -> AEV?
;; sexp : list?
(define do-all
  (lambda (sexp)
    (AEV->sexp
     (simplify
      (derivative
       (simplify (parse sexp))
       'x)))))
