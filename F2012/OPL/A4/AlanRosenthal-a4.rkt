;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname AlanRosenthal-a4) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
; Alan Rosenthal
; Assignment 4
; 25 September 2012


(require 2htdp/image)
(require rackunit)


;the amount of grout in each tile, default: 5
(define grout-percent 5)

;; (make-a-tile tile-color grout-color side) -> image?
;; tile-color : image-color?
;; grout-color : image-color?
;; side : (and/c real? (not/c negative?))
(define make-a-tile
  (lambda (tile-color grout-color side)
    (let ((grout-width (* side grout-percent 0.01)))
      (let ([top-bottom (rectangle side (/ grout-width 2) "solid" grout-color)]
            [left-right (rectangle (* .5 grout-width) (- side grout-width) "solid" grout-color)]
            [weave (rectangle (- (/ side 3) grout-width) (- side grout-width) "solid" tile-color)]
            [middle (rectangle (* grout-width) (- side grout-width) "solid" grout-color)])
        (above
         top-bottom
         (beside left-right weave middle weave middle weave left-right)
         top-bottom)))))

;; (make-tiling a-tile) -> (-> (and/c integer? positive?) image?)
;; a-square : image?
(define make-tiling
  (lambda (a-square)
    (lambda (n)
      (if (= n 0)
          a-square
          ((make-tiling
            (let ([imgrot (rotate 90 a-square)])
              (let ([topbottom (beside a-square imgrot a-square)])
                (above topbottom (beside imgrot a-square imgrot) topbottom)))) (- n 1))))))


;; (make-floor tile-color grout-color side) -> (-> (and/c integer? positive?) image?)
;; tile-color : image-color?
;; grout-color : image-color?
;; side : (and/c real? (not/c negative?))
(define make-floor
  (lambda (tile-color grout-color side)
    (lambda (n)
      ((make-tiling
        (make-a-tile tile-color grout-color side))
       n))))

;test of make-tiling
(let ([side 30]
      [color "green"])
  (check-equal?
   ((make-tiling (square side "solid" color)) 1)
   (square (* side 3) "solid" color)))

;test of make-a-tile
;Please note: This test fails and I don't know why.  It shouldn't fail since both images are the same height, width and color.
(let ([side 100]
      [color "green"])
  (check-equal?
   (image-width (make-a-tile color color side))
   (image-width (square side "solid" color))))
(let ([side 100]
      [color "green"])
  (check-equal?
   (image-height (make-a-tile color color side))
   (image-height (square side "solid" color))))
(let ([side 100]
      [color "green"])
  (check-equal?
   (make-a-tile color color side)
   (square side "solid" color)))