#lang racket

;; pomocnicze
(define (square x) (* x x))

;; wektory
(define (make-vect begin end)
  (cons begin end))

(define (vect? v)
  (and (pair? v)
       (pair? (vect-begin v))
       (pair? (vect-end v))))
  
(define (vect-begin v)
  (car v))

(define (vect-end v)
  (cdr v))

(define (display-vect v)
  (display "[")
  (display-point (vect-begin v))
  (display ", ")
  (display-point (vect-end v))
  (display "]"))
         

;; punkty

(define (make-point x y)
  (cons x y))

(define (point? p)
  (pair? p))

(define (point-x p)
  (car p))

(define (point-y p)
  (cdr p))

(define (display-point p)
  (display "(")
  (display (point-x p))
  (display ", ")
  (display (point-y p))
  (display ")"))


;; operacje

(define (vect-length v)
  ;; obliczam za pomocą pitagorasa, długości przeciwprostokątnej
  (sqrt
   (+
    (square (- (point-x (vect-end v)) (point-x (vect-begin v))))
    (square (- (point-y (vect-end v)) (point-y (vect-begin v)))))))

;; skomplikowane 

(define (vect-scale v k)
  (make-vect (vect-begin v)
             ;; obliczam różnice pomiędzy składowymi x'=(x2-x1), y'=(y2-y1)
             ;; mnożę nowe składowe razy k i przesuwam względem punktu zaczepienia wektora
             (make-point (+
                          (point-x (vect-begin v)) (* k (- (point-x (vect-end v)) (point-x (vect-begin v)))))
                         (+
                          (point-y (vect-begin v)) (* k (- (point-y (vect-end v)) (point-y (vect-begin v))))))))

;; obliczam różnicę pomiędzy punktem p, a pierwszą współrzędną, potem
;; odpowiednio dodaję ją do drugiej współrzędnej

(define (vect-translate v p)
  (make-vect p (make-point
                (+ (point-x (vect-end v))
                   (- (point-x p) (point-x (vect-begin v))))
                (+ (point-y (vect-end v))
                   (- (point-y p) (point-y (vect-begin v)))))))

;; testy

(vect-length (make-vect (make-point 0 0) (make-point 15 20)))
(display-vect (make-vect (make-point 3 5) (make-point 24 47)))
(display-vect (vect-translate (make-vect (make-point 3 5) (make-point 24 47)) (make-point 15 34)))


