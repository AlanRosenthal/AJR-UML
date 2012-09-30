;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname AlanRosenthal-a3) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
; Alan Rosenthal
; Assignment 3
; 19 September 2012

(require rackunit)
(require racket/contract)
(require 2htdp/image)
(require 2htdp/universe)

;; (star-display background-color star-color) -> (-> (and/c real? (not/c negative?)) image?)
;; background-color : image-color?
;; star-color : image-color?
(define star-display
  (let ([background-radius 300])
    (lambda (background-color star-color)
      (let ([background (circle background-radius "solid" background-color)])
        (lambda (side-length)
          (let ([the-star (star-polygon side-length 7 1 "solid" star-color)])
            (overlay the-star background)))))))

;; (update-star old-state the-key) -> number?
;; old-state : number?
;; the-key : string?
(define update-star 
  (lambda (old-state the-key)
    (cond [(key=? the-key "up") (+ old-state 10)]
          [(key=? the-key "down") (if (< 0 (- old-state 10)) (- old-state 10) 0)]
          [(key=? the-key "u") (* old-state 1.1)]
          [(key=? the-key "d") (* old-state 0.9)]
          [else old-state])))

(check-equal?
 (update-star 10 "up")
 20)
(check-equal?
 (update-star 11 "down")
 1)
(check-equal?
 (update-star 10 "u")
 11)
(check-equal?
 (update-star 10 "d")
 9)
(check-equal?
 (update-star 1 "down")
 0)

;; (run-game background-color star-color show-status-window?) -> (and/c real? (not/c negative?))
;; show-status-window? : boolean?
;; background-color : image-color?
;; star-color : image-color?
(define run-game
  (lambda (background-color star-color show-status-window?)
    (big-bang
     80
     (state show-status-window?)
     (to-draw (star-display background-color star-color))
     (on-key update-star)
     (check-with (and/c real? (not/c negative?))))))
