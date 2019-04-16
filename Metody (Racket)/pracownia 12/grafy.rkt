#lang racket

;; sygnatura: grafy
(define-signature graph^
  ((contracted
    [graph        (-> list? (listof edge?) graph?)]
    [graph?       (-> any/c boolean?)]
    [graph-nodes  (-> graph? list?)]
    [graph-edges  (-> graph? (listof edge?))]
    [edge         (-> any/c any/c edge?)]
    [edge?        (-> any/c boolean?)]
    [edge-start   (-> edge? any/c)]
    [edge-end     (-> edge? any/c)]
    [has-node?    (-> graph? any/c boolean?)]
    [outnodes     (-> graph? any/c list?)]
    [remove-node  (-> graph? any/c graph?)]
    )))

;; prosta implementacja grafów
(define-unit simple-graph@
  (import)
  (export graph^)

  (define (graph? g)
    (and (list? g)
         (eq? (length g) 3)
         (eq? (car g) 'graph)))

  (define (edge? e)
    (and (list? e)
         (eq? (length e) 3)
         (eq? (car e) 'edge)))

  (define (graph-nodes g) (cadr g))

  (define (graph-edges g) (caddr g))

  (define (graph n e) (list 'graph n e))

  (define (edge n1 n2) (list 'edge n1 n2))

  (define (edge-start e) (cadr e))

  (define (edge-end e) (caddr e))

  (define (has-node? g n) (not (not (member n (graph-nodes g)))))
  
  (define (outnodes g n)
    (filter-map
     (lambda (e)
       (and (eq? (edge-start e) n)
            (edge-end e)))
     (graph-edges g)))

  (define (remove-node g n)
    (graph
     (remove n (graph-nodes g))
     (filter
      (lambda (e)
        (not (eq? (edge-start e) n)))
      (graph-edges g)))))

;; sygnatura dla struktury danych
(define-signature bag^
  ((contracted
    [bag?       (-> any/c boolean?)]
    [bag-empty? (-> bag? boolean?)]
    [empty-bag  (and/c bag? bag-empty?)]
    [bag-insert (-> bag? any/c (and/c bag? (not/c bag-empty?)))]
    [bag-peek   (-> (and/c bag? (not/c bag-empty?)) any/c)]
    [bag-remove (-> (and/c bag? (not/c bag-empty?)) bag?)])))

;; struktura danych - stos
(define-unit bag-stack@
  (import)
  (export bag^)
  (define (bag? potential-bag)
    (and (list? potential-bag)
         (eq? (length potential-bag) 2)
         (eq? 'bag (car potential-bag))
         (list? (cadr potential-bag))))
  (define (bag-empty? bag)
    (eq? (length (cadr bag)) 0))
  (define empty-bag (list 'bag '()))
  (define (bag-insert bag element )
    (list 'bag (cons element (cadr bag))))
  (define (bag-peek bag) (car (cadr bag)))
  (define (bag-remove bag) (list 'bag (cdr (cadr bag))))
)

;; struktura danych - kolejka FIFO
;; do zaimplementowania przez studentów
(define-unit bag-fifo@
  (import)
  (export bag^)
  (define (bag? potential-bag)
    (and (list? potential-bag)
         (eq? (length potential-bag) 3)
         (eq? 'bag (car potential-bag))
         (list? (second potential-bag))
         (list? (third potential-bag))))
  (define (bag-empty? bag) (and (empty? (second bag)) (empty? (third bag))))
  (define empty-bag (list 'bag '() '()))
  (define (bag-insert bag element)
    (list 'bag (cons element (second bag)) (third bag)))
  (define (bag-peek bag)
    (cond
      [(empty? (third bag)) (last (second bag))]
      [else (first (third bag))]))
  (define (bag-remove bag)
    (cond
      [(empty? (third bag)) (list 'bag '() (cdr (reverse (second bag))))]
      [else (list 'bag (second bag) (cdr (third bag)))])))

;; sygnatura dla przeszukiwania grafu
(define-signature graph-search^
  (search))

;; implementacja przeszukiwania grafu
;; uzależniona od implementacji grafu i struktury danych
(define-unit/contract graph-search@
  (import bag^ graph^)
  (export (graph-search^
           [search (-> graph? any/c (listof any/c))]))
  (define (search g n)
    (define (it g b l)
      (cond
        [(bag-empty? b) (reverse l)]
        [(has-node? g (bag-peek b))
         (it (remove-node g (bag-peek b))
             (foldl
              (lambda (n1 b1) (bag-insert b1 n1))
              (bag-remove b)
              (outnodes g (bag-peek b)))
             (cons (bag-peek b) l))]
        [else (it g (bag-remove b) l)]))
    (it g (bag-insert empty-bag n) '()))
  )

;; otwarcie komponentu grafu
(define-values/invoke-unit/infer simple-graph@)

;; graf testowy
(define test-graph
  (graph
   (list 1 2 3 4)
   (list (edge 1 3)
         (edge 1 2)
         (edge 2 4))))

(define test-circular-graph
  (graph
   (list 1 2 3 4)
   (list (edge 1 2)
         (edge 2 3)
         (edge 3 4)
         (edge 4 1))))

(define deep-graph
  (graph
   (list 1 2 3 4 5 6 7 8)
   (list (edge 1 2)
         (edge 2 3)
         (edge 2 4)
         (edge 2 5)
         (edge 5 6)
         (edge 5 7)
         (edge 5 8)
         (edge 8 2))))

;; TODO: napisz inne testowe grafy!

;; otwarcie komponentu stosu
(define implementation-is-stack? #t)
(define-values/invoke-unit/infer bag-stack@)
;; opcja 2: otwarcie komponentu kolejki
; (define-values/invoke-unit/infer bag-fifo@)

;; testy w Quickchecku
(require quickcheck)

;; test przykładowy: jeśli do pustej struktury dodamy element
;; i od razu go usuniemy, wynikowa struktura jest pusta
(quickcheck
 (property ([s arbitrary-symbol])
           (bag-empty? (bag-remove (bag-insert empty-bag s)))))

 ; test dla stosu
 ; ostatnio dodany element ma być pokazany przez bag-peek


; test dla kolejki
; pierwszy dodany element ma być pokazany przez bag-peek



;; TODO: napisz inne własności do sprawdzenia!
;; jeśli jakaś własność dotyczy tylko stosu lub tylko kolejki,
;; wykomentuj ją i opisz to w komentarzu powyżej własności

;; otwarcie komponentu przeszukiwania
(define-values/invoke-unit/infer graph-search@)

;; uruchomienie przeszukiwania na przykładowym grafie

(require rackunit)
;; dla kolejki
;(unless implementation-is-stack?
;  (quickcheck
;   (property ([s1 arbitrary-symbol]
;              [s2 arbitrary-symbol]
;              [s3 arbitrary-symbol])
;             (and
;              (equal? (bag-peek (bag-insert (bag-insert (bag-insert empty-bag s1) s2) s3)) s1)
;              (equal? (bag-peek (bag-remove (bag-insert (bag-insert (bag-insert empty-bag s1) s2) s3)))
;                      s2))))
;  (check-equal? (search test-graph 1) '(1 3 2 4))
;  (check-equal? (search test-graph 2) '(2 4))
;  (check-equal? (search test-graph 3) '(3))
;  (check-equal? (search test-graph 4) '(4))
;  (check-equal? (search test-circular-graph 1) '(1 2 3 4))
;  (check-equal? (search test-circular-graph 2) '(2 3 4 1))
;  (check-equal? (search test-circular-graph 3) '(3 4 1 2))
;  (check-equal? (search test-circular-graph 4) '(4 1 2 3))
;  (check-equal? (search deep-graph 1) '(1 2 3 4 5 6 7 8))
;  (check-equal? (search deep-graph 2) '(2 3 4 5 6 7 8))
;  (check-equal? (search deep-graph 3) '(3))
;  (check-equal? (search deep-graph 4) '(4))
;  (check-equal? (search deep-graph 5) '(5 6 7 8 2 3 4))
;  (check-equal? (search deep-graph 6) '(6))
;  (check-equal? (search deep-graph 7) '(7))
;  (check-equal? (search deep-graph 8) '(8 2 3 4 5 6 7)))
;
;;; dla stosu
;(when implementation-is-stack?
;  (quickcheck
;   (property ([s1 arbitrary-symbol]
;              [s2 arbitrary-symbol]
;              [s3 arbitrary-symbol])
;             (and
;              (equal? (bag-peek (bag-insert (bag-insert (bag-insert empty-bag s1) s2) s3)) s3)
;              (equal? (bag-remove (bag-insert (bag-insert (bag-insert empty-bag s1) s2) s3))
;                      (bag-insert (bag-insert empty-bag s1) s2)))))
;  (check-equal? (search test-graph 1) '(1 2 4 3))
;  (check-equal? (search test-graph 2) '(2 4))
;  (check-equal? (search test-graph 3) '(3))
;  (check-equal? (search test-graph 4) '(4))
;  (check-equal? (search test-circular-graph 1) '(1 2 3 4))
;  (check-equal? (search test-circular-graph 2) '(2 3 4 1))
;  (check-equal? (search test-circular-graph 3) '(3 4 1 2))
;  (check-equal? (search test-circular-graph 4) '(4 1 2 3))
;  (check-equal? (search deep-graph 1) '(1 2 5 8 7 6 4 3))
;  (check-equal? (search deep-graph 2) '(2 5 8 7 6 4 3))
;  (check-equal? (search deep-graph 3) '(3))
;  (check-equal? (search deep-graph 4) '(4))
;  (check-equal? (search deep-graph 5) '(5 8 2 4 3 7 6))
;  (check-equal? (search deep-graph 6) '(6))
;  (check-equal? (search deep-graph 7) '(7))
;  (check-equal? (search deep-graph 8) '(8 2 5 7 6 4 3)))
