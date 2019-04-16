#lang racket

(define (append xs ys)
  (if (null? xs)
      ys
      (cons (car xs) (append (cdr xs) ys))))

(define (reverse xs)
  (if (null? xs)
      null
      (append (reverse (cdr xs)) (list (car xs)))))

(define (flatten t)
  (if (leaf? t)
      null
      (append (flatten (node-left t)) (cons (node-val t) (flatten (node-right t))))))

(define (flatt t)
  (define (flat t acc)
    (if (leaf? t)
        acc
        (flat (node-left t) (cons (node-val t) (flat (node-right t) acc)))))
  (flat t null))

(define (map f xs)
  (if (null? xs)
      null
      (cons (f (car xs)) (map f (cdr xs)))))

(define (foldr op nval xs)
  (if (null? xs)
      nval
      (op (car xs) (foldr op nval (cdr xs)))))

(define (concatmap f xs)
  (if (null? xs)
      null
      (append (f (car xs)) (concatmap f (cdr xs)))))

(define (bst-search x t)
  (cond [(leaf? t) #f]
        [(= x (node-val t)) x]
        [(< x (node-val t)) (bst-search x (node-left t))]
        [(> x (node-val t)) (bst-search x (node-right t))]))

(define (bst-insert x t)
  (cond [(leaf? t) (make-node x 'leaf 'leaf)]
        [(< x (node-val t)) (make-node (node-val t) (bst-insert x (node-left t)) (node-right t))]
        [(> x (node-val t)) (make-node (node-val t) (node-left t) (bst-insert x (node-right t)))]))

(define (mirror t)
  (if (leaf? t)
      'leaf
      (make-node (node-val t) (mirror(node-right)) (mirror (node-left t)))))

(define (st-app f x y)
  (lambda (i)
    (let* ([rx (x i)]
           [ry (y (res-state rx))])
      (res (f (res-value rx) (res-value ry))
           (res-state ry)))))
      

