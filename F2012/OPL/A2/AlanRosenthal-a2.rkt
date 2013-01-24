;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname AlanRosenthal-a2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;Alan Rosenthal
;Assignment 2
;18 September 2012

(require 2htdp/image)
(require 2htdp/universe)
(require rackunit)

;; (rad-to-deg rad) -> number?
;; rad : number?
(define rad-to-deg
  (lambda (rad)
    (* 360 1/2 (/ 1 pi) rad)
    )
  )
(let ([rad pi])
  (check-equal?
   (rad-to-deg pi)
   #i180
   )
  )

;;(deg-to-rad deg) -> number?
;; deg : number?
(define deg-to-rad
  (lambda (deg)
    (* 2 pi 1/360 deg)
    )
  )

(let ([deg 180])
  (check-equal?
   (deg-to-rad deg)
   pi
   )
  )

;; (make-takeoff angle) -> (-> natural-number/c image?)
;; angle: exact-integer?
(define make-takeoff
  (lambda (angle)
    (let ([side-length 400])
      (let ([the-background (square side-length "solid" "white")]
            [the-rocket (bitmap/url "http://www.ccs.neu.edu/home/matthias/HtDP2e/rocket-s.jpg")]
            [the-velocity (/ side-length 100)]
            )
        (lambda (frame)
          (place-image (rotate angle the-rocket)
                       (+ (/ side-length 2) (* (cos (deg-to-rad (+ angle 90))) frame the-velocity))
                       (- side-length (image-height the-rocket) (* (sin (deg-to-rad (+ angle 90))) frame the-velocity))
                       the-background
                       )
          )
        )
      )
    )
  )
(let ([side-length 400]
      [the-rocket (bitmap/url "http://www.ccs.neu.edu/home/matthias/HtDP2e/rocket-s.jpg")]
      [the-angle 45]
      )
  (check-equal?
   ((make-takeoff the-angle) 0)
   (place-image
    (rotate the-angle the-rocket)
    (/ side-length 2)
    (- side-length (image-height the-rocket))
    (square side-length "solid" "white")
    )
   )
  )


;; (rocket-movie angle) -> natural-number/c
;; angle : exact-integer?
(define rocket-movie
  (lambda (angle)
    (animate (make-takeoff angle))
    )
  )

