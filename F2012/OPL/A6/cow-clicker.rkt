#lang racket

(require rackunit)
(require 2htdp/image)
(require 2htdp/universe)

(require "cow-world.rkt")
(require "cow-world-operations.rkt")

;; (handle-click w mouse-x mouse-y the-event) -> cow-world?
;; w : cow-world?
;; mouse-x : integer?
;; mouse-y : integer?
;; the-event : mouse-event?
(define handle-click
  (lambda (w x y the-event)
    (if
     (and
      (mouse=? the-event "button-down")
      (cow-clickable w)
      (> x (- (cow-x w) (/ (cow-width w) 2)))
      (< x (+ (cow-x w) (/ (cow-width w) 2)))
      (> y (- (cow-y w) (/ (cow-height w) 2)))
      (< y (+ (cow-y w) (/ (cow-height w) 2))))
     (update-cow-world-clicked
      (update-cow-world-score 
       (update-cow-world-clickable w #f)
       w) #t)
     w)))

;; (update-cow-world-on-tick w) -> cow-world?
;; w : cow-world?
(define update-cow-world-on-tick
  (lambda (w)
    (decrement-time-to-move
     w
     (if
      (and 
       (= (cow-ticks-until-move w) 0)
       (cow-clickable w)
       (not (cow-clicked w)))
      0
      500))))

(let ([old-world
       (make-cow-world 60 40 60 40 30 20 #f 10 #f)])
  (let
      ([new-world
        (update-cow-world-on-tick old-world)])
    (check-equal?
     (cow-ticks-until-move new-world)
     500)))

;; (new-world-w-random-field-coordinates w) -> vec2d?
;; w : cow-world?
(define new-world-w-random-field-coordinates
  (lambda (w)
    (let ([a-fun
           (lambda (cow-d field-d)
             (+
              (/ cow-d 2)
              (/
               (* 
                (random 100)
                (-
                 field-d
                 cow-d))
               100)))])
      (world-with-new-cow-pos
       w
       (a-fun
        (cow-width w)
        (field-width w))
       (a-fun
        (cow-height w)
        (field-height w))))))

(let ([old-world
       (make-cow-world 60 40 60 40 30 20 #f 10 #f)])
  (let
      ([new-world
        (new-world-w-random-field-coordinates old-world)])
    (check-equal?
     new-world
     old-world)))


;; (move-cow w) -> cow-world?
;; w : cow-world?
(define move-cow
  (lambda (w)
    (if
     (cow-clicked w)
     (new-world-w-random-field-coordinates (update-cow-world-clicked w #f))
     w
     )))

(let ([old-world
       (make-cow-world 60 40 60 40 30 20 #f 10 #f)])
  (let
      ([new-world
        (move-cow old-world)])
    (check-equal?
     old-world
     new-world)))


;; (change-world w) -> cow-world?
;; w : cow-world?
(define change-world
  (lambda (w)
    (let ([new-w (update-cow-world-on-tick w)])
      (move-cow
       (update-cow-world-clickable
        new-w
        (if
         (and
          (= (cow-ticks-until-move new-w) 0)
          (not (cow-clicked new-w)))
         #t
         #f))))))

;; (draw-pasture w) -> image?
;; w : cow-world?
(define draw-pasture
  (lambda (w)
    (place-image
     (text (string-append "You have clicked your cow " (number->string (cow-score w)) " times!") 12 "black")
     (/ (field-width w) 2)
     (- (field-height w) 40)
     (place-image
      (text (string-append "You have " (number->string (cow-ticks-until-move w)) " ticks left until you can click your cow!") 12 "black")
      (/ (field-width w) 2)
      (- (field-height w) 20)
      (place-image
       (if (cow-clickable w)
           (overlay
            (text "Moo" 16 "olive")
            (ellipse
             (cow-width w)
             (cow-height w)
             "solid"
             "gold"))
           (overlay
            (text "Moo" 16 "olive")
            (ellipse
             (cow-width w)
             (cow-height w)
             "solid"
             "pink")))
       (cow-x w)
       (cow-y w)
       (rectangle
        (field-width w)
        (field-height w)
        "solid"
        "green"))))))

; Clickable Test
(let ([w (make-cow-world 400 500 150 100 200 250 #t 0 #f)]
      [field-width 400]
      [field-height 500]
      [cow-width 150]
      [cow-height 100]
      [cow-x 200]
      [cow-y 250])
  (check-equal?
   (draw-pasture w)
   (place-image
    (text  "You have clicked your cow 0 times!" 12 "black")
    (/ field-width 2)
    (- field-height 40)
   (place-image
    (text "You have 0 ticks left until you can click your cow!" 12 "black")
    (/ field-width 2)
    (- field-height 20)
    (place-image
     (overlay
      (text "Moo" 16 "olive")
      (ellipse
       cow-width
       cow-height
       "solid"
       "gold"))
     cow-x
     cow-y
     (rectangle
      field-width
      field-height
      "solid"
      "green"))))))

;; (cow-clicker show-status-window?) -> cow-world?
;; show-status-window? : boolean?
(define cow-clicker
  (let ([field-width 400]
        [field-height 500])
    (let ([initial-x
           (/ field-width 2)]
          [initial-y
           (/ field-height 2)]
          [cow-width 100]
          [cow-height 50])
      (lambda
          (show-status-window?)
        (big-bang
         (make-cow-world
          field-width
          field-height
          cow-width
          cow-height
          initial-x
          initial-y
          #f
          0
          #f)
         (state show-status-window?)
         (to-draw draw-pasture)
         (on-tick change-world)
         (on-mouse handle-click)
         (check-with cow-world?))))))