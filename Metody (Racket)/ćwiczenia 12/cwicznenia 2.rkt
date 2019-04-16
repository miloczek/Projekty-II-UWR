#lang typed/racket

;;zadanie 6

(: prefixes (All (A) (-> (Listof A) (Listof (Listof A)))))
(define (prefixes xs)
  (: help (All (A) (-> (Listof A) (Listof A) (Listof (Listof A)))))
  (define (help xy x)
    (if (null? xy)
        (list x)
        (cons x (help (cdr xy) (append x (list (car xy)))))))
  (help xs null))

;;zadanie 7

(define-type Leaf 'leaf)
(define-type (Node A B) (List 'node A Listof (B)))

(: node-select (All (A B) (-> (Listof (Node A B)) Integer Node (A B))))

(define (node-select node-list k)
  (if (= k 1)
      (car node-list)
      (node-select (cdr node-list) (- k 1))))


