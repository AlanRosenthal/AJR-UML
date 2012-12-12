#lang plai

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
    (FWAE::num 3)))

;; (FWAE->sexp a-fwae) -> list?
;; a-fwae : FWAE?
(define FWAE->sexp
  (lambda (a-fwae)
    '()))