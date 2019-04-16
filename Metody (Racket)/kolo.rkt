#lang racket

;;; LISTA 1

(define (power-close-to b n)
  (define (iter b n e)
    (if (> (expt b e) n)
        e
        (iter b n (+ e 1))))
  (iter b n 0))







(define (dist x y)
  (abs (- x y)))

(define (average x y)
  (/ (+ x y) 2))

(define (square x)
  (* x x))

(define (sqrt x)
  ;; lokalne definicje
  ;; poprawienie przybliżenia pierwiastka z x
  (define (improve approx)
    (average (/ x approx) approx))
  ;; nazwy predykatów zwyczajowo kończymy znakiem zapytania
  (define (good-enough? approx)
    (< (dist x (square approx)) 0.0001))
  ;; główna procedura znajdująca rozwiązanie
  (define (iter approx)
    (cond
      [(good-enough? approx) approx]
      [else                  (iter (improve approx))]))
  
  (iter 1.0))


(define (cube x)
  (* x x x))

(define (dupa x)
  (define (improve approx)
    (/ (+ (/ x (square approx)) (* 2 approx)) 3))
  (define (good-enough? approx)
    (< (dist x (cube approx)) 0.0001))
  (define (iter approx)
    (cond
      [(good-enough? approx) approx]
      [else (iter (improve approx))]))
  (iter 1.0))


;;LISTA 2

(define (inc x)
  (+ x 1))

(define (compose f g)
  (lambda (x) (f (g x))))

(define (repeated p n)
  (if (= n 1)
      (lambda (x) (p x))
      (repeated (compose p p) (- n 1))))


(define product
  (lambda (term next s e)
    (if (> s e)
        0
        (* (term s) (product term next (next s) e)))))


;;;; LISTA 3

(define (make-rat n d)
  (let ((c (gcd n d)))
    (list (/ n c) (/ d c))))

(define (rat-numer l)
  (first l))

(define (rat-denum l)
  (second l))

(define (rat? l)
  (and (list? l)
       (not (= (rat-denum l) 0))
       (= 1 (gcd (rat-numer l) (rat-denum l)))))



(define (reverse xs)
  (if (null? xs)
      null
      (append (reverse (cdr xs)) (list (car xs)))))

(define (rev-it xs)
  (define (helper xs reversed)
    (if (null? xs)
        reversed
        (helper (cdr xs) (cons (car xs) reversed))))
  (helper xs null))

(define (append xs ys)
  (if (null? xs)
      ys
      (cons (car xs) (append (cdr xs) ys))))

(define (filter p xs)
  (if (null? xs)
      null
      (if (p (car xs))
          (cons (car xs) (filter p (cdr xs)))
          (filter p (cdr xs)))))
          



(define (map f xs)
  (if (null? xs)
      null
      (cons (f (car xs)) (map f (cdr xs)))))


(define (flatten t)
  (define (flat t acc)
    (if (leaf? t)
        acc
        (flat (node-left t) (cons (node-value t) (flat (node-right t) acc)))))
  (flat t null))


(define (flat-app t)
  (if (leaf? t)
      null
      (append (flat-app (node-left t)) (cons (node-value t) (flat-app (node-right t))))))


(define l '(1 2 3 '(8 0 8 '(7 5)) 8 9 10))



(define (make-node x l r)
  (cons 'node x l r))


(define (tree? t)
  (or (leaf? t)
      (and (node? t)
           (number? (node-val t))
           (tree? (node-left t))
           (tree? (node-right t)))))

(define (bst-find x t)
  (cond [(leaf? t) false]
        [(= x (node-val t)) x]
        [(< x (node-val t)) (bst-find x (node-left-t))]
        [(> x (node-val t)) (bst-find x (node-right-t))]))


(define (bst-insert x t)
  (cond [(leaf? t) (make-node x leaf leaf)]
        [(< x (node-val t)) (make-node (node-val t) (bst-insert x (node-left t)) (node-right t))]
        [(> x (node-val t)) (make-node (node-val t) (node-left t) (bst-insert x (node-right t)))]))

(define (mirror t)
  (if (leaf? t)
      leaf
      (make-node (node-val t) (mirror (node-right t)) (mirror(node-left t)))))


(define (flatten t)
  (if (leaf? t)
      null
      (append (flatten (node-left t)) (cons (node-val t) (flatten (node-right t))))))

(define (flatten2 t)
  (define (flat t acc)
    (if (leaf? t)
        acc
        (flat (node-left t) (cons (node-val t) (flat (node-right t) acc)))))
  (flat t null))

(define (scale k t)
  (cond [(leaf? t) null]
        [(not (pair? t)) (* t k)]
        [(else (cons (scale (car t) k)
               (scale (cdr t) k)))]))
        
        




