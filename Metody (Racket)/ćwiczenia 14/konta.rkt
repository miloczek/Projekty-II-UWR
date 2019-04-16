#lang racket

;;; rozdział 3.1.1

(define balance 100)

(define (withdraw amount)
  (if (>= balance amount)
      (begin (set! balance (- balance amount))
             balance)
      "Insufficient funds"))

;: (withdraw 25)
;: (withdraw 25)
;: (withdraw 60)
;: (withdraw 15)

(define new-withdraw
  (let ((balance 100))
    (lambda (amount)
      (if (>= balance amount)
          (begin (set! balance (- balance amount))
                 balance)
          "Insufficient funds"))))


(define (make-withdraw balance)
  (lambda (amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds")))


;: (define W1 (make-withdraw 100))
;: (define W2 (make-withdraw 100))
;: (W1 50)
;: (W2 70)
;: (W2 40)
;: (W1 40)

(define (make-account balance password)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch pass m)
    (if (eq? pass password)
    (cond ((eq? m 'withdraw) withdraw)
          ((eq? m 'deposit) deposit)
          (else (error "Unknown request -- MAKE-ACCOUNT"
                       m)))
    (lambda (x) 'incorrect-password)))
  dispatch)

;: (define acc (make-account 100))

;: ((acc 'withdraw) 50)
;: ((acc 'withdraw) 60)
;: ((acc 'deposit) 40)
;: ((acc 'withdraw) 60)

;;; rozdział 3.1.3

(define (make-simplified-withdraw balance)
  (lambda (amount)
    (set! balance (- balance amount))
    balance))


;: (define W (make-simplified-withdraw 25))
;: (W 20)
;: (W 10)


(define (make-decrementer balance)
  (lambda (amount)
    (- balance amount)))

;: (define D (make-decrementer 25))
;: (D 20)
;: (D 10)

;: ((make-decrementer 25) 20)
;: ((lambda (amount) (- 25 amount)) 20)
;: (- 25 20)

;: ((make-simplified-withdraw 25) 20)

;: ((lambda (amount) (set! balance (- 25 amount)) 25) 20)
;: (set! balance (- 25 20)) 25

;;; Toższamość obiektów

;: (define D1 (make-decrementer 25))
;: (define D2 (make-decrementer 25))
;: 
;: (define W1 (make-simplified-withdraw 25))
;: (define W2 (make-simplified-withdraw 25))
;: 
;: (W1 20)
;: (W1 20)
;: (W2 20)

;: (define peter-acc (make-account 100))
;: (define paul-acc (make-account 100))
;: 
;: (define peter-acc (make-account 100))
;: (define paul-acc peter-acc)

;;; Kłopoty z programowaniem imperatywnym

(define (factorial n)
  (define (iter product counter)
    (if (> counter n)
        product
        (iter (* counter product)
              (+ counter 1))))
  (iter 1 1))

(define (factorial2 n)
  (let ((product 1)
        (counter 1))
    (define (iter)
      (if (> counter n)
          product
          (begin (set! product (* counter product))
                 (set! counter (+ counter 1))
                 (iter))))
    (iter)))


;; Zadanie 2


(define (make-cycle l)
  (define (help acc)
    (if (null? mcdr acc)
        (set-mcdr! acc l)
        (help (mcdr acc))))
  (help l))

;; Zadanie 5

(define (bucket-sort xs)
  (define v (make-vector (+ (apply max (map car xs)) 1) null))
  (for-each (lambda (n) (vector-set! v (car n) (cons n (vector-ref v (car n))))) xs)
  (apply append (map reverse (vector->list v))))
 
;; make-vector = stwórz wektor o tylu komórkach i takim symbolu startowym
;; for-each = dla każdego elementu listy wykonaj
;; vector-set! w jakim wektorze, którą pozycję, podmień na co
;; vector-ref w jakim wektorze, uzyskaj którą pozycję
;; vector->list zmień wektor w listę

  