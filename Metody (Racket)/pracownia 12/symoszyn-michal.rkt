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

  (define (bag? xs)
    (and (list? xs)
         (eq? (length xs) 2)
         (eq? (car xs) 'stack)))

  (define (bag-empty? xs)
    (null? (second xs)))

  (define empty-bag (list 'stack null))

  

  (define (bag-insert xs x)
    (list 'stack (cons x (second xs))))

  (define (bag-peek xs)
    (car (second xs)))

  (define (bag-remove xs)
    (list 'stack (cdr (second xs))))
    
)

;; struktura danych - kolejka FIFO
;; do zaimplementowania przez studentów
(define-unit bag-fifo@
  (import)
  (export bag^)

  (define (bag? xs)
    (and (list? xs)
         (eq? (length xs) 3)
         (eq? (car xs) 'fifo)
         (list? (second xs))
         (list? (third xs))))

  (define (bag-empty? xs)
    (and
     (empty? (second xs))
     (empty? (third xs))))



  (define empty-bag (list 'fifo null null))

  

  (define (bag-insert xs x)
    (list 'fifo (cons x (second xs)) (third xs)))

  (define (bag-peek xs)
    (if (null? (third xs)) (last (second xs))
        (car (third xs))))

  (define (bag-remove xs)
    (if (null? (third xs)) (list 'fifo null (cdr (reverse (second xs))))
        (list 'fifo (second xs) (cdr (third xs)))))
    
 )

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

(define test-graph1
  (graph
   (list 1 2 3 4 5)
   (list (edge 1 2)
         (edge 1 3)
         (edge 1 4)
         (edge 1 5))))

(define test-graph2
  (graph
   (list 1 2 3 4 5 6 7)
   (list (edge 1 2)
         (edge 2 3)
         (edge 2 4)
         (edge 4 5)
         (edge 4 6)
         (edge 6 7))))

(define test-graph3
  (graph
   (list 1 2 3 4 5)
   (list (edge 1 2)
         (edge 2 3)
         (edge 3 4)
         (edge 4 5)
         (edge 5 1))))


;; otwarcie komponentu stosu
(define-values/invoke-unit/infer bag-stack@)
;; opcja 2: otwarcie komponentu kolejki (tutaj zmieniamy komentarz aby sprawdzić fifo)
;(define-values/invoke-unit/infer bag-fifo@)

;; testy w Quickchecku
(require quickcheck)

;; test przykładowy: jeśli do pustej struktury dodamy element
;; i od razu go usuniemy, wynikowa struktura jest pusta
(quickcheck
 (property ([s arbitrary-symbol])
           (bag-empty? (bag-remove (bag-insert empty-bag s)))))

;; jeśli jakaś własność dotyczy tylko stosu lub tylko kolejki,
;; wykomentuj ją i opisz to w komentarzu powyżej własności

;; otwarcie komponentu przeszukiwania
(define-values/invoke-unit/infer graph-search@)

;; uruchomienie przeszukiwania na przykładowym grafie
(search test-graph 1)
(require rackunit)

;;Testy dla stosu:
(quickcheck
 (property ([x arbitrary-symbol]
            [y arbitrary-symbol]
            [z arbitrary-symbol])
           (and
            (equal? (bag-peek (bag-insert (bag-insert (bag-insert empty-bag x) y) z)) z) ;;czy ostatnio dodany element jest na pewno pierwszy z góry (z właściwości stosu)
            (equal? (bag-remove (bag-insert (bag-insert (bag-insert empty-bag x) y) z))
                      (bag-insert (bag-insert empty-bag x) y))))) ;;gdy zdejmuję element ze stosu, czy reszta zostaje?

(check-equal? (search test-graph 1) '(1 2 4 3))
(check-equal? (search test-graph 3) '(3))
(check-equal? (search test-graph 2) '(2 4))

(check-equal? (search test-graph1 1) '(1 5 4 3 2))
(check-equal? (search test-graph1 5) '(5))
(check-equal? (search test-graph1 4) '(4))

(check-equal? (search test-graph2 3) '(3))
(check-equal? (search test-graph2 2) '(2 4 6 7 5 3))
(check-equal? (search test-graph2 6) '(6 7))

(check-equal? (search test-graph3 4) '(4 5 1 2 3))
(check-equal? (search test-graph3 1) '(1 2 3 4 5))
(check-equal? (search test-graph3 5) '(5 1 2 3 4))

;;Testy dla kolejki: (należy odkomentować test oraz zmienić komentarz przy invoke. Zamiast stack, wybrać opcję 2 czyli fifo
;(quickcheck
;   (property ([x arbitrary-symbol]
;              [y arbitrary-symbol]
;              [z arbitrary-symbol])
;             (and
;              (equal? (bag-peek (bag-insert (bag-insert (bag-insert empty-bag x) y) z)) x) ;czy pierwszy dodany element jest wskazany przez bag-peek
;              (equal? (bag-peek (bag-remove (bag-insert (bag-insert (bag-insert empty-bag x) y) z))) ; czy lista wyjściowa odwaraca się przy bag-remove?
;                      y))))
;
;(check-equal? (search test-graph 1) '(1 3 2 4))
;(check-equal? (search test-graph 2) '(2 4))
;(check-equal? (search test-graph 4) '(4))
;
;(check-equal? (search test-graph1 1) '(1 2 3 4 5))
;(check-equal? (search test-graph1 4) '(4))
;(check-equal? (search test-graph1 3) '(3))
;
;(check-equal? (search test-graph2 5) '(5))
;(check-equal? (search test-graph2 4) '(4 5 6 7))
;(check-equal? (search test-graph2 2) '(2 3 4 5 6 7))
;
;(check-equal? (search test-graph3 4) '(4 5 1 2 3))
;(check-equal? (search test-graph3 1) '(1 2 3 4 5))
;(check-equal? (search test-graph3 5) '(5 1 2 3 4))


;; Zadanie wykonane w współpracy z Pauliną Landkocz i Adamem Sibik












