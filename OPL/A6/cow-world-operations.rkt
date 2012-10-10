#lang racket

(require rackunit)

(require "cow-world.rkt")

;; (decrement-time-to-move w clock-reset-time) -> cow-world?
;; w : cow-world?
;; clock-reset-time : exact-nonnegative-integer?
(define decrement-time-to-move
  (lambda (w clock-reset-time)
    (let ([current-ticks
           (cow-ticks-until-move w)])
    (let ([new-clock-time
           (if (= current-ticks 0)
               clock-reset-time
               (- current-ticks 1))])
      (world-with-new-cow-ticks-until-move w new-clock-time)))))

(provide decrement-time-to-move)

