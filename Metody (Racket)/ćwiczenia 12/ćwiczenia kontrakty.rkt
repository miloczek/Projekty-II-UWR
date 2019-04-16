#lang racket
;;contacty to dynamiczny system typów, własności są sprawdzane dopiero przy konieczności
;;system typów w rackecie typowanym to system statyczny- typy  sprawdzane po napisaniu przed
;;wywołaniem.
 
(require racket/contract)
 
;;zadanie 1
 
(define/contract (suffixes xs)
  (let (( a (new-∀/c 'a)))
    (-> (listof a) (listof (listof a))))
  (if (null? xs) (list null)
      (cons xs (suffixes (cdr xs)))))
 
;;zadanie 2
 
(define (dist x y)
  (abs (- x y)))
 
(define (average x y)
  (/ (+ x y) 2))
 
(define (square x)
  (* x x))
 
(define/contract (sqrt x)
  (->i ([argument (>/c 0)])
       [result (argument) (and/c (λ (result) (if (>= argument 1) (< result argument)
                                                 (> result argument)))
                                 (λ (result) (> result 0)))])
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
 
;;zadanie 3
 
(define/contract (filter pred seq)
  (let ((a (new-∀/c 'a)))
    (-> (-> a boolean?) (listof a) (listof a)))
  (cond [(null? seq) null]
        [(pred (car seq)) (cons (car seq) (filter pred (cdr seq)))]
        [else  (filter pred (cdr seq))]))
 
(define/contract (filter2 pred seq)
  (and/c (let ((a (new-∀/c 'a)))
           (-> (-> a boolean?) (listof a) (listof a)))
         (->i ([pred (-> any/c boolean?)]
               [seq list?])
              [result (seq pred) (λ (result) (<= (length result) (length seq)))]))
                                             
  (cond [(null? seq) null]
        [(pred (car seq)) (cons (car seq) (filter pred (cdr seq)))]
        [else  (filter pred (cdr seq))]))

;;zadanie 4
 
 
(define-signature  monoid^
  ((contracted
     [elem? (-> any/c boolean?)]
     [neutral  elem?]
     [oper (-> elem? elem? elem?)])))
 
;;czby całkowite z zerem i dodawaniem,
 
(define-unit monoid-integ@
  (import)
  (export monoid^)
 
  (define neutral 0)
  (define (elem? x)
    (integer? x))
  (define (oper x y)
    (+ x y)))
 
;;listy  z  listą  pustą  i scalaniem list.
 
 
(define-unit monoid-lists@
  (import)
  (export monoid^)
 
  (define neutral null)
 
  (define (elem? x)
    (list? x))
 
  (define (oper xs ys)
    (append xs ys)))

;;zadanie 5

(quickcheck
 (property
  ([l (arbitrary-list arbitrary-string)])
  (and [equal? l {oper neutral l}]
       [equal? l {oper l neutral}])))

(quickcheck
 (property
  ([l1 (arbitrary-list arbitrary-boolean)]
   [l2 (arbitrary-list arbitrary-integer)]
   [l3 (arbitrary-list arbitrary-string)])
  (equal? [oper {oper l1 l2} l3]
          [oper l1 {oper l2 l3}])))
   
  