#lang plai
(print-only-errors #t)
(define-type FAE
  [FAE::num (n number?)]
  [FAE::add (lhs FAE?) (rhs FAE?)]
  [FAE::id (name symbol?)]
  [FAE::fun
   (params (listof symbol?))
   (body FAE?)]
  [FAE::app
   (fun-expr FAE?)
   (arg-exprs (listof FAE?))])

(define-type FAE-Value
  [numV (n number?)]
  [closureV (param symbol?)
            (body FAE?)
            (ds DefrdSub?)])

(define-type DefrdSub
  [mtSub]
  [aSub
   (name symbol?)
   (value FAE-Value?)
   (ds DefrdSub?)])

;; lookup : symbol DefrdSub -> (or/c #f FAE-Value)
(define (lookup name ds)
  #f)

;; (FAE::parse sexp) -> FAE?
;; sexp : list?
(define FAE::parse
  (lambda (sexp)
    (cond
      [(number? sexp) (FAE::num sexp)]
      [(symbol? sexp) (FAE::id sexp)]
      [(list? sexp)
       (case (first sexp)
         [(+)
          (if (equal? (length sexp) 3)
              (FAE::add (FAE::parse (second sexp)) (FAE::parse (third sexp)))
              (error "Invalid Number of Params for +"))]
         [(fun)
          (if (equal? (length sexp) 3)
              (FAE::fun (map FAE::parseFun (second sexp)) (FAE::parse (third sexp)))
              (error "Invalid Number of Params for Fun"))]
         [else
          (if (and (FAE::fun? (FAE::parse (first sexp))))
              (if (and (equal? (length sexp) 2) (not (empty? (second sexp))))
                  (FAE::app (FAE::parse (first sexp)) (map FAE::parse (second sexp)))
                  (if (equal? (length sexp) 2)
                      (error "Empty list for expr")
                      (error "Invalid Number of Params for app")))
              (if (and (> (length sexp) 1) (symbol? (second sexp)))
                  (FAE::id (second sexp))
                  (error "Unknown Initial Symbol")))])]
      [(error "Unexpected Error")])))
;; (FAE::parseFun sexp) -> FAE?
;; sexp : list?
(define FAE::parseFun
  (lambda (sexp)
    (if (and (list? sexp) (equal? (length sexp) 2) (symbol? (second sexp)) (equal? 'quote (first sexp)))
        (second sexp)
        (error "First term must be a symbol/Invalid number of Params"))))

(test (FAE::parse 'x) (FAE::id 'x))
(test (FAE::parse 3) (FAE::num 3))
(test (FAE::parse '{+ 1 2}) (FAE::add (FAE::num 1) (FAE::num 2)))
(test/exn (FAE::parse '{+ 1}) "Invalid Number of Params for +")
(test/exn (FAE::parse '{+ 1 1 1}) "Invalid Number of Params for +")
(test (FAE::parse '{fun {'x 'y 'z} {+ 1 2}})
      (FAE::fun '(x y z) (FAE::add (FAE::num 1) (FAE::num 2))))
(test (FAE::parse '{fun {'x 'y 'z} {+ 'x 'y}})
      (FAE::fun '(x y z) (FAE::add (FAE::id 'x) (FAE::id 'y))))
(test (FAE::parse '{{fun {'x 'y 'z} {+ 'x 'y}} {1 2 3}})
      (FAE::app (FAE::fun '(x y z) (FAE::add (FAE::id 'x) (FAE::id 'y))) (list (FAE::num 1) (FAE::num 2) (FAE::num 3))))
(test/exn (FAE::parse '{{fun {'x 'y 'z} {+ 'x 'y}} {}}) "Empty list for expr")
(test/exn (FAE::parse '{{fun {'x 'y 'z} {+ 'x 'y}} {} {}}) "Invalid Number of Params for app")

;; (FAE->sexp a-fae) -> list?
;; a-fwae : FAE?
(define FAE->sexp
  (lambda (a-fae)
    (type-case FAE a-fae
      [FAE::num (n)
                n]
      [FAE::id (n)
               (string->symbol (symbol->string n))]
      [FAE::add (l r)
                (list '+ (FAE->sexp l) (FAE->sexp r))]
      [FAE::fun (p b)
                (list 'fun (map string->symbol (map symbol->string p)) (FAE->sexp b))]
      [FAE::app (f arg)
                (list (FAE->sexp f) (map FAE->sexp arg))])))
(test (FAE->sexp (FAE::parse 3)) 3)
(test (FAE->sexp (FAE::parse 'x)) 'x)
(test (FAE->sexp (FAE::parse '{+ 'x 'y})) '(+ x y))
(test (FAE->sexp (FAE::parse '{fun {'x 'y} {+ 'x 'y}})) '(fun (x y) (+ x y)))
(test (FAE->sexp (FAE::parse '{{fun {'x 'y} {+ 'x 'y}} {{+ 3 2} {+ 3 3}}}))
      '((fun (x y) (+ x y)) ((+ 3 2) (+ 3 3))))

;; (not-duplicate-params? a-fae) -> boolean?
;; a-fae : FAE?
(define not-duplicate-params?
  (lambda (a-fae)
    (type-case FAE a-fae
      [FAE::num (n) #t]
      [FAE::id (n) #t]
      [FAE::add (l r)
                (and (not-duplicate-params? l) (not-duplicate-params? r))]
      [FAE::fun (p body)
                (and (equal? (set-count (list->set p)) (length p)) (not-duplicate-params? body))]
      [FAE::app (e arg)
                (not-duplicate-params? e)])))

;; (duplicate-params? a-fae) -> boolean?
;; a-fae : FAE?
(define duplicate-params?
  (lambda (a-fae)
    (not (not-duplicate-params? a-fae))))

(test (duplicate-params? (FAE::parse 3)) #f)
(test (duplicate-params? (FAE::parse 'x)) #f)
(test (duplicate-params? (FAE::parse '{+ 'x 'x})) #f)
(test (duplicate-params? (FAE::parse '{fun {'x 'y} {+ 'x 'y}})) #f)
(test (duplicate-params? (FAE::parse '{fun {'x 'x} {+ 'x 'y}})) #t)
(test (duplicate-params? (FAE::parse '{{fun {'y 'x} {+ 'x 'y}} {1 1}})) #f)
(test (duplicate-params? (FAE::parse '{fun {'x 'y} {+ 'x {fun {'x 'y} {+ 'x 'y}}}})) #f)

;; (interp a-fae env) -> FAE-Value
;; a-fae : FAE?
;; env : DefrdSub?
(define interp
  (lambda (a-fae env)
    (numV 3)))

;; (interpreter a-fae) -> number?
;; a-fae : FAE?
(define interpreter
  (lambda (a-fae)
    (let ([res (interp a-fae (mtSub))])
      (if (numV? res)
          (numV-n res)
          (error 'interpreter "Result value not a number.")))))