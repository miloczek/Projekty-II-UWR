#lang racket

(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (modulo a b))))

(define (make-rat n d)
  (let ((g (gcd n d)))
    (cons (/ n g) (cons (/ d g) null))))

(define (rat-num x)
  (car x))

(define (rat-denom x)
  (car (cdr x)))

(define (rat? x)
  (define (list? a)
    (or (null? a)
        (and (pair? a)
             (list (cdr a)))))
  (and (list? x)
       (not (= (rat-denom x) 0))
       (= 1 (gcd (rat-num x) (rat-denom x)))))

(define (add-rat x y)
  (make-rat (+ (* (rat-num x) (rat-denom y))
               (* (rat-num y) (rat-denom x)))
            (* (rat-denom x) (rat-denom y))))

(define (sub-rat x y)
  (make-rat (- (* (rat-num x) (rat-denom y))
               (* (rat-num y) (rat-denom x)))
            (* (rat-denom x) (rat-denom y))))

(define (mul-rat x y)
  (make-rat (* (rat-num x) (rat-num y))
            (* (rat-denom x) (rat-denom y))))

(define (div-rat x y)
  (make-rat (* (rat-num x) (rat-denom y))
            (* (rat-denom x) (rat-num y))))

(define (equal-rat? x y)
  (= (* (rat-num x) (rat-denom y))
     (* (rat-num y) (rat-denom x))))
  

