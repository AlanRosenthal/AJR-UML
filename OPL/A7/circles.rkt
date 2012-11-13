#lang racket

(require 2htdp/image)
(require 2htdp/universe)
(require rackunit)

;; radius : (and/c real? (not/c negative?))
;; color : color?
;; x : real?
;; y : real?
;; deltax : real?
;; deltay : real?
(struct circle-info (radius color x y deltax deltay))

;; the width and height of the background
(define WIDTH 600)
(define HEIGHT 500)

;; (get-pos-and-delta coord size delta limit)
;;   -> real? real?
;; coord : real?
;; size : real?
;; delta : real?
;; limit : real?
(define get-pos-and-delta
  (let ([damping-factor 0.95])
    (lambda (coord size delta limit)
      (if (< coord size)
          (values 
           size
           (* damping-factor (- delta)))
          (if (> coord (- limit size))
              (values
               (- limit size)
               (* damping-factor (- delta)))
              (values
               coord
               delta))))))

;; (translate-circles w) -> (listof circle-info)
;; w : (listof circle-info)
(define translate-circles
  (lambda (w)
    (map
     (lambda (e)
       (let ([cur-y (circle-info-y e)]
             [cur-x (circle-info-x e)]
             [cur-deltay (circle-info-deltay e)]
             [cur-deltax (circle-info-deltax e)]
             [radius (circle-info-radius e)])
         (let ([cur-x (+ cur-deltax cur-x)]
               [cur-y (+ cur-deltay cur-y)]
               [cur-deltay (+ cur-deltay 0.05)])
           (let-values ([(cur-x cur-deltax)
                         (get-pos-and-delta
                          cur-x
                          radius
                          cur-deltax
                          WIDTH)]
                        [(cur-y cur-deltay)
                         (get-pos-and-delta
                          cur-y
                          radius
                          cur-deltay
                          HEIGHT)])
             (struct-copy
              circle-info
              e
              [x cur-x]
              [y cur-y]
              [deltax cur-deltax]
              [deltay cur-deltay])))))
     w)))


;; (handle-click w x y the-event) -> (listof circle-info?)
;; w : (listof circle-info?)
;; x : integer?
;; y : integer?
;; the-event : mouse-event?
(define handle-click
  (lambda (w x y the-event)
    (if (mouse=? the-event "button-down")
        (if (empty? w)
            (cons (circle-info
                   (+ (random 20) 20)
                   (make-color (random 256) (random 256) (random 256) (random 256))
                   x
                   y
                   (* (cos (* (random) 2 pi)) 2)
                   (* (sin (* (random) 2 pi)) 2))
                  empty)
            (append
             w
             (cons (circle-info
                    (+ (random 20) 20)
                    (make-color (random 256) (random 256) (random 256) (random 256))
                    x
                    y
                    (* (cos (* (random) 2 pi)) 2)
                    (* (sin (* (random) 2 pi)) 2))
                   empty)))
        
        w)))

(check-equal?
 1
 (length (handle-click empty 10 10 "button-down")))
(check-equal?
 0
 (length (handle-click empty 10 10 "button-up")))

;; (draw-circle circles) -> image?
;; circles : (listof circle-info?)
(define draw-circles
  (lambda (circles)
    (foldr
     (lambda (the-circle img)
       (overlay/xy
        (circle
         (circle-info-radius the-circle)
         "solid"
         (circle-info-color the-circle))
        (* -1 (circle-info-x the-circle))
        (* -1 (circle-info-y the-circle))
        img))
     (rectangle WIDTH HEIGHT "solid" "black")
     circles)))
(check-equal?
 (rectangle WIDTH HEIGHT "solid" "black")
 (draw-circles empty))
(check-equal?
 (overlay/xy (circle 20 "solid" "blue") -20 -30 (rectangle WIDTH HEIGHT "solid" "black"))
 (draw-circles (cons (circle-info 20 "blue" 20 30 0 0) empty))
 )
;; (handle-key-press w) -> (listof circle-info?)
;; w : (listof circle-info?)
(define handle-key-press
  (lambda (w k)
    (cond
      [(key=? k "R")
       (foldr
        (lambda (the-circle the-list)
          (let ([the-color (circle-info-color the-circle)])
            (if (> (color-red the-color) (+ (color-blue the-color) (color-green the-color)))
                (append (cons the-circle empty) the-list)
                the-list)))
        empty
        w)]
      [(key=? k "G")
       (foldr
        (lambda (the-circle the-list)
          (let ([the-color (circle-info-color the-circle)])
            (if (> (color-green the-color) (+ (color-blue the-color) (color-red the-color)))
                (append (cons the-circle empty) the-list)
                the-list)))
        empty
        w)]
      [(key=? k "B")
       (foldr
        (lambda (the-circle the-list)
          (let ([the-color (circle-info-color the-circle)])
            (if (> (color-blue the-color) (+ (color-red the-color) (color-green the-color)))
                (append (cons the-circle empty) the-list)
                the-list)))
        empty
        w)]
      [else w])))
(check-equal?
 empty
 (handle-key-press empty "R"))
(check-equal?
 empty
 (handle-key-press empty "G"))
(check-equal?
 empty
 (handle-key-press empty "B"))
(check-equal?
 empty
 (handle-key-press
  (list
   (circle-info 1 (make-color 0 0 255 0) 0 0 0 0) 
   (circle-info 1 (make-color 0 0 255 0) 0 0 0 0) 
   (circle-info 1 (make-color 0 0 255 0) 0 0 0 0) 
   (circle-info 1 (make-color 0 0 255 0) 0 0 0 0) 
   (circle-info 1 (make-color 0 0 255 0) 0 0 0 0))
  "R"))
(check-equal?
 1
 (length
  (handle-key-press
   (list
    (circle-info 1 (make-color 0 0 255 0) 0 0 0 0) 
    (circle-info 1 (make-color 0 255 0 0) 0 0 0 0) 
    (circle-info 1 (make-color 0 255 0 0) 0 0 0 0) 
    (circle-info 1 (make-color 255 0 0 0) 0 0 0 0) 
    (circle-info 1 (make-color 255 0 0 0) 0 0 0 0))
   "B")))
(check-equal?
 2
 (length
  (handle-key-press
   (list
    (circle-info 1 (make-color 0 0 255 0) 0 0 0 0) 
    (circle-info 1 (make-color 0 255 0 0) 0 0 0 0) 
    (circle-info 1 (make-color 0 255 0 0) 0 0 0 0) 
    (circle-info 1 (make-color 255 0 0 0) 0 0 0 0) 
    (circle-info 1 (make-color 255 0 0 0) 0 0 0 0))
   "R")))
(check-equal?
 2
 (length
  (handle-key-press
   (list
    (circle-info 1 (make-color 0 0 255 0) 0 0 0 0) 
    (circle-info 1 (make-color 0 255 0 0) 0 0 0 0) 
    (circle-info 1 (make-color 0 255 0 0) 0 0 0 0) 
    (circle-info 1 (make-color 255 0 0 0) 0 0 0 0) 
    (circle-info 1 (make-color 255 0 0 0) 0 0 0 0))
   "G")))

;; (circles show-status-window?) -> (listof circle-info?)
;; show-status-window? : boolean?
(define circles
  (lambda (show-status-window?)
    (big-bang
     empty
     (state show-status-window?)
     (on-mouse handle-click)
     (on-tick translate-circles)
     (on-key handle-key-press)
     (check-with (listof circle-info?))
     (to-draw draw-circles))))