#lang plai

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
    (FAE::num 32)))

;; (FAE->sexp a-fae) -> list?
;; a-fwae : FAE?
(define FAE->sexp
  (lambda (a-fae)
    '()))

;; (duplicate-params? a-fae) -> boolean?
;; a-fae : FAE?
(define duplicate-params?
  (lambda (a-fae)
    #t))

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