#lang plai

(require "FAE.rkt")
(require "FWAE.rkt")

;; (desugar a-fwae) -> FAE?
;; a-fwae : FWAE?
(define desugar
  (lambda (a-fwae)
    (FAE::num 3)))