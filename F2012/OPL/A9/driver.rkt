#lang plai

(require "FAE.rkt")
(require "FWAE.rkt")
(require "preprocessor.rkt")

(define main
  (lambda (sexp)
    (let ([a-fwae (FWAE::parse sexp)])
      (let ([a-fae (desugar a-fwae)])
        (if (duplicate-params? a-fae)
            (error 'driver "Duplicate parameters")
            (interpreter a-fae))))))



