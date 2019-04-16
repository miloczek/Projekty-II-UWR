#lang racket
;; procedury pomocnicze, uniwersalne 
(define (dist x y)
  (abs (- x y)))

(define (cube x) (* x x x))


(define (cube-root x)
  ;; procedura tworząca przybliżenia 
  (define (improve approx)
    (/ (+ [/ x (* approx approx)] [* 2 approx])
       3))
  (define (good-enough? approx)
    (< (dist x (cube approx)) 0.0001))
  (define (iter approx)
    (cond
      [(good-enough? approx) approx]
      [else (iter (improve approx))]))

  (iter 1.0))

;;testy
(cube-root 27) ;; oczekiwany wynik: 3
(cube-root 0)  ;; oczekiwany wynik: ok. 0
(cube-root 1)  ;; oczekiwany wynik: 1
(cube-root 2)  ;; oczekiwany wynik: ok.  1.2599
(cube-root 15) ;; oczekiwany wynik: ok. 2.45
(cube-root 8)  ;; oczekiwany wynik: 2
(cube-root 12245678901234567) ;; oczekiwany wynik: ok. 496435.555
