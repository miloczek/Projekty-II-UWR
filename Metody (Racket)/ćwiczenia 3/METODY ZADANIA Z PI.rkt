#lang racket
(define (identity x) x)

(define (inc x)
  (+ x 1))

(define (square x)
  (* x x))

(define (compose f g)
  (lambda (x) (f (g x))))


;; zadanie 3;;
(define (repeated p n)
  (if (= n 0)
      (lambda (x) x)
      (compose p (repeated p (- n 1)))))

;; zadanie 4;;
(define sum
  (lambda (term next s e)
    (if (> s e)
        0
        (+ (term s) (sum term next (next s) e)))))

;;rekurencyjnie;;
(define product
  (lambda (term next s e)
    (if (> s e)
        1
        (* (term s) (product term next (next s) e)))))

;; iteracyjnie;;
(define (product-iter term next s e)
  (define (iter x y)
    (if (> x e)
        y
        (iter (next x) (* (term x) y))))
  (iter s 1))

(define (pi-pro s e)
  (if (> s e)
      1
      (* (/ (* s (+ s 2)) (square (inc s)))
         (pi-pro (+ s 2) e))))

(define (pi-prov2 s e)
  (product (lambda (x) (/ (* x (+ x 2)) (square (inc x))))
           (lambda (x) (+ x 2))
           s
           e))
          

;;przyblizenie liczby pi;;
(* 4 (pi-prov2 2.0 1000000))


;; zadanie 5;;

;; rekurencyjnie;;
(define accumulate
  (lambda (combiner null-value term a next b)
    (if [> a b]
        null-value
        [combiner (term a) (accumulate combiner null-value term (next a) next b)])))
(accumulate + 0 (lambda (x) (* x 2)) 2 (lambda (x) (+ x 2)) 6)

;;iteracyjnie;;

;;(define accumulate
 ;; (lambda (combiner term a next b acc)
   ;; [if (> a b)
     ;;   acc
       ;; [accumulate combiner term (next a) next b (combiner (term a) acc)]]))

;; zadanie 6;;

(define (cont_frac num den k)
  (define (cont_frac_iter num den k n)
    (if (= k n)
        0
        (/ (num n) (+ (den n) (cont_frac_iter num den k (+ n 1))))))
  (cont_frac_iter num den k 1))

;; zadanie 7;;

(define (pi x)
  (+ 3 (cont_frac (lambda (x) (square (- (* 2 x) 1)))
                  (lambda (x) 6.0)
                  x)))

;;zadanie 8;;

(define (arctan x k)
  (define (num n)
    (if (= n 1)
        x
        (square (* x (- n 1)))))
  (define (den n)
    (- (* n 2) 1))
    (cont_frac num den k))

(arctan 1 10)