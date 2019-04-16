#lang racket

(define (square x) (* x x))

(define (<= x y)
  (or (< x y) (= x y)))

(define (make-point x y)
  (cons x y))

(define (point? p)
  (pair? p))

(define (point-x p) (car p))
 
(define (point-y p) (cdr p))

(define (display-point p)
  (display "(")
  (display (point-x p))
  (display ", ")
  (display (point-y p))
  (display ")"))

(define (make-vect pp k l)
  (cons pp (cons k l)))

(define (vect-begin v)
  (car v))

(define (vect-dir v)
  (car (cdr v)))

(define (vect-len v)
  (cdr (cdr v)))

(define (vect-scale v k)
  (make-vect (vect-begin v) (vect-dir v) (* k (vect-len v))))




;; zadanie 4

(define (reverse-r l)
  (if (null? l)
      null
      (append (reverse-r (cdr l)) (list (car l)))))



;; zadanie 5

(define (insert xs n)
  (cond
    [(null? xs) (cons n null)]
    [(< n (car xs)) (cons n xs)]
    [else (cons (car xs) (insert (cdr xs) n))]))

(define (insert_sort xs)
  (define (it_in_sort l1 l2)
    (if (null? l2)
        l1
        (it_in_sort (insert l1 (car l2)) (cdr l2))))
    (it_in_sort null xs))

(define (insert xs n i)
  (if (= 0 i) (cons n xs)
      (cons (car xs) (insert (cdr xs) n (- i 1)))))

;; zadanie 6

(define (permi xs)
  (define (loop xs acc)
    (if (null? xs)
        acc
        (loop (cdr xs) (map (ins (car xs) (car xs)) acc))))
  (loop xs (list null)))

(define (int x) (lambda (ps) (define (loop i) (cons (map (insert x i) ps) (loop (- i 1))))
                  (fletter (loop (length ps)))))           


  
  



           