;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname circle-animation-recursive) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/image)
(require 2htdp/universe)

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
  (let ([x 25])
    (make-color (+ x (random 230)) (+ x (random 230)) (+ x (random 230)))))


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
