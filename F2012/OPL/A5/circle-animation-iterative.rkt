; Alan Rosenthal
; Assignment 5
; 10/2/2012

#lang racket

(require 2htdp/image)
(require 2htdp/universe)
(require rackunit)

;; (show-circles show-satatus-window?) -> image?
;; show-status-window? : boolean
(define show-circles
  (let ([background
         (rectangle 500 300 "solid" "black")])
    (lambda (show-status-window?)
      (big-bang
       background
       (state show-status-window?)
       (on-mouse (place-circles background 30))
       (to-draw (lambda (x) x))
       (check-with image?)))))

;; (place-circlesbackground increment) -> (-> image? real? real? mouse-event? image?)
;; background : image?
;; increment : real?
(define place-circles
  (lambda (background increment)
    (let ([max-radius (sqrt (+ (expt (image-width background) 2) (expt (image-height background) 2)))])
      (lambda (w x y event)
        (cond [(mouse=? event "button-up")
               (place-image
                (concentric-circles max-radius increment)
                x
                y
                background)]
              [else w])))))
;; (random-color) -> image-color?
(define random-color
  (lambda ()
    (let ([x 25])
      (make-color (+ x (random 230)) (+ x (random 230)) (+ x (random 230))))))


;; (concentric-circles max-radius increment) -> image?
;; max-radius : real?
;; increment : real?
(define concentric-circles
  (lambda (max-radius increment)
    (let ([a-color (random-color)])
      (letrec
          ((lots-of-circles
            (lambda (img radius)
              (if (> radius max-radius increment)
                  img
                  (lots-of-circles (overlay img (circle radius "outline" a-color)) (+ radius increment))))))
        (lots-of-circles empty-image 1)))))

;Checks concentric-circles
(check-equal?
 (* (+ 1 10 10) 2)
 (image-width (concentric-circles 30 10)))