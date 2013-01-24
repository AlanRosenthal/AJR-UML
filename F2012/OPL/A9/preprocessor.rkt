#lang plai

(require "FAE.rkt")
(require "FWAE.rkt")

;; (desugar a-fwae) -> FAE?
;; a-fwae : FWAE?
(define desugar
  (lambda (a-fwae)
    (type-case FWAE a-fwae
      [FWAE::num (n)
                 (FAE::num n)]
      [FWAE::id (n)
                (FAE::id n)]
      [FWAE::add (l r)
                 (FAE::add (desugar l) (desugar r))]
      [FWAE::fun (p body)
                 (FAE::fun p (desugar body))]
      [FWAE::app (expr arg)
                 (FAE::app (desugar expr) (map desugar arg))]
      [FWAE::with (b body)
                  (FAE::app (FAE::fun (map binding-id b) (desugar body)) (map desugar (map binding-named-expr b)))])))

(test (desugar (FWAE::parse 3)) (FAE::num 3))
(test (desugar (FWAE::parse 'x)) (FAE::id 'x))
(test (desugar (FWAE::parse '{+ 'x 3}))(FAE::add (FAE::id 'x) (FAE::num 3)))
(test (desugar (FWAE::parse '{fun {'x 'y 'z} {+ 'x 'x}}))
      (FAE::fun '(x y z) (FAE::add (FAE::id 'x) (FAE::id 'x))))
(test (desugar (FWAE::parse '{{fun {'x 'y 'z} {+ 'x 'x}} {1 2 3}}))
      (FAE::app (FAE::fun '(x y z) (FAE::add (FAE::id 'x) (FAE::id 'x))) (list (FAE::num 1) (FAE::num 2) (FAE::num 3))))
(test (desugar (FWAE::parse '{with {{'x 2} {'y 4} {'z 3}} {+ 'x 'x}}))
      (FAE::app (FAE::fun '(x y z) (FAE::add (FAE::id 'x) (FAE::id 'x))) (list (FAE::num 2) (FAE::num 4) (FAE::num 3))))
