#lang racket
;; procedury pomocnicze
(define (square x)
  (* x x))

(define (inc x)
  (+ x 1))

(define (dist x y)
  (abs (- x y)))



;; główna funkcja licząca przybliżenia za pomocą ułamków łańcuchowych 
(define (approximation N D)
  (define (good-enough? x y)
    (< (dist x y) 0.000001))
  (define (find-iter fk-1 Ak-1 Ak-2 Bk-1 Bk-2 k)
    (define Ak (+ (* (D k) Ak-1) (* (N k) Ak-2)))
    (define Bk (+ (* (D k) Bk-1) (* (N k) Bk-2)))
    ;; wyliczam nowe przybliżenie i porównuję z fk-1
    (define fk (/ Ak Bk))
    (if (good-enough? fk-1 fk)
        fk
        (find-iter fk Ak Ak-1 Bk Bk-1 (inc k))))
  (find-iter 0 0 1 1 0 1))
    

;; testy

;;arctg (z zadania 8)
(define (arctg-approx x)
  (define (N n)
    (square (* x n)))
  (define (D n)
    (+ (* 2 n) 1))
  (/ x (+ 1.0 (approximation N D))))

(arctg-approx 4)
(atan 4) ;;dla porównania 

;;liczba pi (z zadania 7) (około 3,14159)
(define (pi-approx)
  (define (N n)
    (square (- (* 2 n) 1.0)))
  (define (D n)
    6.0)
  (+ 3 (approximation N D)))

(pi-approx)

;;ułamek łańcuchowy z zadania 6
(approximation (lambda (i) 1.0) (lambda (i) 1.0))
