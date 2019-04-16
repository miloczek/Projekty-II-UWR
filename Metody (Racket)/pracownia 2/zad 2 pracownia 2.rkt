#lang racket

;;procedury z wykładu
(define (dist x y)
  (abs (- x y)))
 
(define (close-enough? x y)
  (< (dist x y) 0.00001))
 
(define (fix-point f x0)
  (let ((x1 (f x0)))
    (if (close-enough? x0 x1)
        x0
        (fix-point f x1))))

(define (average-damp f)
  (lambda (x) (/ (+ x (f x)) 2)))

;;procedury z ćwiczeń 
(define (compose f g)
  (lambda (x) (f (g x))))
 
(define (repeated p n)
  (if (< n 1)
      (lambda (x) x)
      (compose p (repeated p (- n 1)))))

;; z treści zadania i z wykładu:
;; dla pierwiastka 2 i 3 potrzebne jest jednokrotne tłumienie

;; sprawdzam co z pierwiastkiem 4 stopnia:

(define (4th x)
  (fix-point (average-damp (average-damp (lambda (y) (/ x (* y y y))))) 1.0))

(4th 16)

;; wychodzi 2 tj. prawidłowo, zatem należy zastosować podwójne tłumienie

;; dla pierwiastka stopnia 8:

(define (8th x)
  (fix-point (average-damp (average-damp (average-damp (lambda (y) (/ x (expt y 7)))))) 1.0))

(8th 254)

;; znów dwójka, po kilku innych próbach i błędach wnioskuje że należy złożyć z sobą funkcję average-damp log o podstawie 2 z n razy, czyli stopnia pierwiastka
 
 
(define (nth-root x n)
  (if (= n 0)
      1
  (fix-point ((repeated average-damp (log n 2)) (lambda (y) (/ x (expt y (- n 1))))) 1.0)))
 
 
(nth-root 27 3)
(nth-root 1 7)
(nth-root 2 3)
(nth-root 7 9)
(nth-root -27 3)
(nth-root 256 4)
(nth-root 4555 5)
(nth-root 2222222 6)