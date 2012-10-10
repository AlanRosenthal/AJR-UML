#lang racket

(require rackunit)

;; (vec2d x y) -> vec2d?
;; x : real?
;; y : real?
(struct vec2d (x y) #:transparent)

;; (cow-info cow-pos cow-dimensions) -> cow-info?
;; pos : vec2d
;; dimension : vec2d
;; ticks-until-move : exact-nonnegative-integer?
;; clickable : boolean?
;; score : exact-nonnegative-integer?
;; clicked : boolean?
(struct cow-info
  (pos dimensions ticks-until-move clickable score clicked) #:transparent)

;; (cow-world cow-info pasture-dimensions) -> cow-world?
;; cow-info : cow-info?
;; pasture-dimensions : vec2d
(struct cow-world
  (the-cow pasture-dimensions) #:transparent)

;; (make-cow-world
;;   field-width field-height
;;   cow-width cow-height
;;   cow-x cow-y) -> cow-world?
;; field-width : real?
;; field-height : real?
;; cow-width : real?
;; cow-height : real?
;; cow-x : real?
;; cow-y : real?
;; clickable : boolean?
;; score : exact-nonnegative-integer?
(define make-cow-world
  (lambda (field-width
           field-height
           cow-width
           cow-height
           cow-x
           cow-y
           clickable
           score
           clicked)
    (cow-world
     (cow-info
      (vec2d cow-x cow-y)
      (vec2d cow-width cow-height)
     0
      clickable
      score
      clicked)
     (vec2d field-width field-height))))

(check-equal?
 (make-cow-world 1 2 3 4 5 6 #f 7 #f)
 (cow-world
  (cow-info
   (vec2d 5 6)
   (vec2d 3 4)
   0
   #f
   7
   #f)
  (vec2d 1 2)))

;; (cow-score w) -> exact-nonnegative-integer?
;; w : cow-world?
(define cow-score
  (lambda (w)
    (cow-info-score
     (cow-world-the-cow w))))

(check-equal?
 (cow-score
  (make-cow-world #f #f #f #f #f #f #f 2 #f))
 2)

;; (cow-clickable w) -> boolean?
;; w : cow-world?
(define cow-clickable
  (lambda (w)
    (cow-info-clickable
     (cow-world-the-cow w))))

(check-equal?
 (cow-clickable
  (make-cow-world #f #f #f #f #f #f #t #f #f))
 #t)

;; (cow-clicked w) -> boolean?
;; w : cow-world?
(define cow-clicked
  (lambda (w)
    (cow-info-clicked
     (cow-world-the-cow w))))

(check-equal?
 (cow-clicked
  (make-cow-world #f #f #f #f #f #f #f #f #t))
 #t)

;; (cow-width w) -> real?
;; w : cow-world?
(define cow-width
  (lambda (w)
    (vec2d-x
     (cow-info-dimensions
      (cow-world-the-cow w)))))

(check-equal?
 (cow-width
  (make-cow-world #f #f 2 #f #f #f #f #f #f))
 2)

;; (cow-height w) -> real?
;; w : cow-world?
(define cow-height
  (lambda (w)
    (vec2d-y
     (cow-info-dimensions
      (cow-world-the-cow w)))))

(check-equal?
 (cow-height
  (make-cow-world #f #f #f 2 #f #f #f #f #f))
 2)

;; (field-width w) -> real?
;; w : cow-world?
(define field-width
  (lambda (w)
    (vec2d-x (cow-world-pasture-dimensions w))))

(check-equal?
 (field-width
  (make-cow-world 2 #f #f #f #f #f #f #f #f))
 2)

;; (field-height w) -> real?
;; w : cow-world?
(define field-height
  (lambda (w)
    (vec2d-y (cow-world-pasture-dimensions w))))

(check-equal?
 (field-height
  (make-cow-world #f 2 #f #f #f #f #f #f #f))
 2)

;; (cow-x w) -> real?
;; w : world?
(define cow-x
  (lambda (w)
    (vec2d-x
     (cow-info-pos
      (cow-world-the-cow w)))))

(check-equal?
 (cow-x
  (make-cow-world #f #f #f #f 2 #f #f #f #f))
 2)

;; (cow-y w) -> real?
;; w : world?
(define cow-y
  (lambda (w)
    (vec2d-y
     (cow-info-pos
      (cow-world-the-cow w)))))

(check-equal?
 (cow-y
  (make-cow-world #f #f #f #f #f 2 #f #f #f))
 2)

;; (cow-ticks-until-move w) -> exact-nonnegative-integer?
;; w : cow-world?
(define cow-ticks-until-move
  (lambda (w)
    (cow-info-ticks-until-move
     (cow-world-the-cow w))))

(check-equal?
 (cow-ticks-until-move
  (make-cow-world #f #f #f #f #f #f #f #f #f))
 0)

;; (world-with-new-cow-ticks-until-move w new-time) -> cow-world?
;; w : cow-world?
;; new-time : exact-nonnegative-integer?
(define world-with-new-cow-ticks-until-move
  (lambda (w new-time)
    (struct-copy
     cow-world
     w
     [the-cow
      (struct-copy
       cow-info
       (cow-world-the-cow w)
       [ticks-until-move new-time])])))

;; (update-cow-world-clickable w bool) -> cow-world?
;; w : cow-world?
;; bool : boolean?
(define update-cow-world-clickable
  (lambda (w bool)
    (struct-copy
     cow-world
     w
     (the-cow
      (struct-copy
       cow-info
       (cow-world-the-cow w)
       (clickable
        bool))))))

;; (update-cow-world-clicked w bool) -> cow-world?
;; w : cow-world?
;; bool : boolean?
(define update-cow-world-clicked
  (lambda (w bool)
    (struct-copy
     cow-world
     w
     (the-cow
      (struct-copy
       cow-info
       (cow-world-the-cow w)
       (clicked bool))))))

;; (update-cow-world-score w) -> cow-world?
;; w : cow-world?
(define update-cow-world-score
  (lambda (w bool)
    (struct-copy
     cow-world
     w
     (the-cow
      (struct-copy
       cow-info
       (cow-world-the-cow w)
       (score
        (+ (cow-score w) 1)))))))

;; (world-with-new-cow-pos w x y) -> cow-world?
;; w : cow-world?
;; x : real?
;; y : real?
(define world-with-new-cow-pos
  (lambda (w x y)
    (struct-copy
     cow-world
     w
     [the-cow
      (struct-copy
       cow-info
       (cow-world-the-cow w)
       [pos (vec2d x y)])])))

(provide make-cow-world
         cow-world?
         cow-score
         cow-clickable
         cow-clicked
         cow-width
         cow-height
         field-width
         field-height
         cow-x
         cow-y
         cow-ticks-until-move
         world-with-new-cow-ticks-until-move
         update-cow-world-clickable
         update-cow-world-clicked
         update-cow-world-score
         world-with-new-cow-pos)