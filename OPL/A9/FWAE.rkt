#lang plai

(print-only-errors #t)

(define-type FWAE::Binding
  [binding (id symbol?) (named-expr FWAE?)])

(define-type FWAE
  [FWAE::num (n number?)]
  [FWAE::add (lhs FWAE?) (rhs FWAE?)]
  [FWAE::id (name symbol?)]
  [FWAE::with
   (b (listof FWAE::Binding?))
   (body FWAE?)]
  [FWAE::fun
   (params (listof symbol?))
   (body FWAE?)]
  [FWAE::app
   (fun-expr FWAE?)
   (arg-exprs (listof FWAE?))])


;; (parse sexp) -> FWAE?
;; sexp : list?
(define FWAE::parse
  (lambda (sexp)
    (cond
      [(number? sexp) (FWAE::num sexp)]
      [(symbol? sexp) (FWAE::id sexp)]
      [(list? sexp)
       (case (first sexp)
         [(+)
          (if (equal? (length sexp) 3)
              (FWAE::add (FWAE::parse (second sexp)) (FWAE::parse (third sexp)))
              (error "Invalid Number of Params for +"))]
         [(with)
          (if (equal? (length sexp) 3)
              (FWAE::with (map FWAE::parseBindings (second sexp)) (FWAE::parse (third sexp)))
              (error "Invalid Number of Params for with"))]
         [(fun)
          (if (equal? (length sexp) 3)
              (FWAE::fun (map FWAE::parseFun (second sexp)) (FWAE::parse (third sexp)))
              (error "Invalid Number of Parmas for fun"))]
         [else
          (if (and (FWAE::fun? (FWAE::parse (first sexp))))
              (if (and (equal? (length sexp) 2) (not (empty? (second sexp))))
                  (FWAE::app (FWAE::parse (first sexp)) (map FWAE::parse (second sexp)))
                  (if (equal? (length sexp) 2)
                      (error "Empty list for expr")
                      (error "Invalid Number of Params for app")))
              (if (and (> (length sexp) 1) (symbol? (second sexp)))
                  (FWAE::id (second sexp))
                  (error "Unknown Initial Symbol")))])])))


(test/exn (FWAE::parse '{fun 1}) "Invalid Number of Parmas for fun")
(test/exn (FWAE::parse '{fun 1 2 3}) "Invalid Number of Parmas for fun")
(test (FWAE::id 'x) (FWAE::parse 'x)) 
(test (FWAE::parse '{+ 1 'x}) (FWAE::add (FWAE::num 1) (FWAE::id 'x)))
(test (FWAE::add (FWAE::num 1) (FWAE::num 2)) (FWAE::parse '{+ 1 2}))
(test/exn (FWAE::parse '{+}) "Invalid Number of Params for +")
(test/exn (FWAE::parse '{+ 1}) "Invalid Number of Params for +")
(test/exn (FWAE::parse '{+ 1 2 3}) "Invalid Number of Params for +")

;; (parseBindings sexp) -> binding?
;; sexp : list?
(define FWAE::parseBindings
  (lambda (sexp)
    (if (equal? (length sexp) 2)
        (if (and (list? (first sexp)) (symbol? (second (first sexp))))
            (binding (second (first sexp)) (FWAE::parse (second sexp)))
            (error "First term must be a symbol"))
        (error "Invalid Number of Params for with"))))
(test (FWAE::parseBindings '{'x 2}) (binding 'x (FWAE::num 2)))
(test/exn (FWAE::parseBindings '{'x 2 3}) "Invalid Number of Params for with")
(test/exn (FWAE::parseBindings '{2 3}) "First term must be a symbol")
(test (FWAE::parse '{with {{'x 2} {'y 3} {'z 4}} {+ x y}})
      (FWAE::with (list (binding 'x (FWAE::num 2)) (binding 'y (FWAE::num 3)) (binding 'z (FWAE::num 4)))
                  (FWAE::add (FWAE::id 'x) (FWAE::id 'y))))

;; (parseFun sexp) -> FWAE?
;; sexp : list?
(define FWAE::parseFun
  (lambda (sexp)
    (if (and (list? sexp) (symbol? (second sexp)) (equal? 'quote (first sexp)) (equal? (length sexp) 2))
        (second sexp)
        (error "First term must be a symbol/Invalid number of Params"))))

(test (FWAE::parse '{fun {'x 'y 'z} {+ 'x 'y}}) (FWAE::fun '(x y z) (FWAE::add (FWAE::id 'x) (FWAE::id 'y))))
(test/exn (FWAE::parse '{fun {'x 2 'z} {+ 'x 'y}}) "First term must be a symbol/Invalid number of Params")
(test/exn (FWAE::parse '{fun {{'x 'y 'z}} {+ 'x 'y}}) "First term must be a symbol/Invalid number of Params")
(test (FWAE::parse '{{fun {'x} {+ 'x 'x}} {2 3 4}})
      (FWAE::app (FWAE::fun '(x) (FWAE::add (FWAE::id 'x) (FWAE::id 'x)))
                 (list (FWAE::num 2) (FWAE::num 3) (FWAE::num 4))))
(test/exn (FWAE::parse '{{fun {'x} {+ 'x 'x}} {}}) "Empty list for expr")
(test/exn (FWAE::parse '{{fun {'x} {+ 'x 'x}}}) "Invalid Number of Params for app")
(test/exn (FWAE::parse '{{fun {'x} {+ 'x 'x}} {'x} {'x}}) "Invalid Number of Params for app")
;; (FWAE->sexp a-fwae) -> list?
;; a-fwae : FWAE?
(define FWAE->sexp
  (lambda (a-fwae)
    (type-case FWAE a-fwae
      [FWAE::num (n)
                 n]
      [FWAE::id (n)
                (string->symbol (symbol->string n))]
      [FWAE::add (lhs rhs)
                 (list '+ (FWAE->sexp lhs) (FWAE->sexp rhs))]
      [FWAE::with (b body)
                  (list 'with (map FWAE::with->sexp b) (FWAE->sexp body))]
      [FWAE::fun (params body)
                 (list 'fun (map string->symbol (map symbol->string params)) (FWAE->sexp body))]
      [FWAE::app (f e)
                 (list (FWAE->sexp f) (map FWAE->sexp e))])))

(define FWAE::with->sexp
  (lambda (a-fwae)
    (list (binding-id a-fwae) (FWAE->sexp (binding-named-expr a-fwae)))))

(test (FWAE->sexp (FWAE::parse '{{fun {'x} {+ 'x 3}} {3 4 5}}))
      '((fun (x) (+ x 3)) (3 4 5)))
(test (FWAE->sexp (FWAE::parse '{fun {'x} {+ 'x 3}}))
      '(fun (x) (+ x 3)))
(test (FWAE->sexp (FWAE::parse '{fun {'x 'y 'z} {+ 'x 3}}))
      '(fun (x y z) (+ x 3)))
(test (FWAE->sexp (FWAE::parse '{with {{'x 2}} {+ 'x 5}}))
      '(with ((x 2)) (+ x 5)))
(test (FWAE->sexp (FWAE::parse '{with {{'x 2} {'y 3}} {+ 'x 5}}))
      '(with ((x 2) (y 3)) (+ x 5)))
(test (FWAE->sexp (FWAE::parse '{with {{'x 2} {'y {+ x 3}}} {+ 'x 5}}))
      '(with ((x 2) (y (+ x 3))) (+ x 5)))
(test (FWAE->sexp (FWAE::parse '{+ 1 2})) '(+ 1 2))
(test (FWAE->sexp (FWAE::parse '{+ {+ 'x 'y} 2})) '(+ (+ x y) 2))
(test (FWAE->sexp (FWAE::parse 10)) 10)
(test (FWAE->sexp (FWAE::parse 'x)) 'x)