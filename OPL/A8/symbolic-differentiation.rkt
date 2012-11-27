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

;; (parse s) -> AEV?
;; s : list?
(define parse
  (lambda (s) (num 0)))

;; (derivative exp x) -> AEV?
;; exp : AEV?
;; x : symbol?
(define derivative
  (lambda (exp x) exp))

;; (simplify exp) -> AEV?
;; exp : AEV?
(define simplify
  (lambda (exp) exp))

;; (AEV->sexp exp) -> AEV?
;; exp : AEV?
(define AEV->sexp
  (lambda (exp) '()))

;; (do-all sexp) -> AEV?
;; sexp : list?
(define do-all
  (lambda (sexp)
    (AEV->sexp
     (simplify
      (derivative
       (simplify (parse sexp))
       'x)))))