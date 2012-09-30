;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname |Alan Rosenthal - a1|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
; Alan Rosenthal
; Assignment 1
; 11 September 2012


(require 2htdp/image)
(require rackunit)


;the amount of grout in each tile, default: 5
(define grout-percent 5)

;; (make-tile tile-color grout-color side) -> image?
;; tile-color : image-color?
;; grout-color : image-color?
;; side : (and/c real? (not/c negative?))
(define make-tile
  (lambda (tile-color grout-color side)
    (let ((grout-width (* side grout-percent 0.01)))
      (let ([top-bottom (rectangle side (/ grout-width 2) "solid" grout-color)]
            [left-right (rectangle (* .5 grout-width) (- side grout-width) "solid" grout-color)]
            [weave (rectangle (- (/ side 3) grout-width) (- side grout-width) "solid" tile-color)]
            [middle (rectangle (* grout-width) (- side grout-width) "solid" grout-color)]
            )
        (above
         top-bottom
         (beside left-right weave middle weave middle weave left-right)
         top-bottom
         )
        )
      )
    )
  )

;; (make-9 img) -> image?
;; img : image?
(define make-9
  (lambda (img)
    (let ([imgrot (rotate 90 img)])
      (let ([topbottom (beside img imgrot img)])
        (above topbottom (beside imgrot img imgrot) topbottom)
        )
      )
    )
  )


;; (make-floorl tile-color grout-color side) -> image?
;; tile-color : image-color?
;; grout-color : image-color?
;; side : (and/c real? (not/c negative?))
(define make-floor
  (lambda (tile-color grout-color side)
    (make-9 (make-9 (make-tile tile-color grout-color side)))
    )
  )



;checks to make sure make-9 creates a square with 9 tiles inside
(let ([side 30]
      [color "green"]
      )
  (check-equal?
   (make-9 (square side "solid" color))
   (square (* side 3) "solid" color)
   )
  )

(make-floor "Yellow" "black" 100)