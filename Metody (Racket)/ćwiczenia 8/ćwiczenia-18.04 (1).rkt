#lang racket

(define (lcons x f)
  (cons x f))

(define (lhead l)
  (car l))

(define (ltail l)
  ((cdr l)))

(define (nats-from m)
  (lcons
   m
   (lambda () (nats-from (+ m 1)))))

(define nats
  (nats-from 0))

(define (take n l)
  (if (or (null? l) (= n 0))
      null
      (cons (lhead l)
            (take (- n 1) (ltail l)))))

(define (filter p l)
  (cond [(null? l) null]
        [(p (lhead l))
         (lcons (lhead l)
                (lambda ()
                  (filter p (ltail l))))]
        [else (filter p (ltail l))]))

(define (prime? n)
  (define (div-by m)
    (cond [(= m n) true]
          [(= (modulo n m) 0) false]
          [else (div-by (+ m 1))]))
  (if (< n 2)
      false
      (div-by 2)))

;; Zadanie 1 

(define (fib-from n k)
  (lcons n (lambda () (fib-from k (+ n k)))))

(define fibs (fib-from 0 1))


;;Zadanie 2

(define (whole-from n k)
  (cond
    [(positive? n) (lcons n (lambda () (whole-from (- 0 k) (+ 1 k))))]
    [else (lcons n (lambda () (whole-from k k)))]))

(define whole (whole-from 0 1))
