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
  
  (define (bag? x)
    (and (list? x)
         (eq? (length x) 2)
         (eq? (car x) 'stack)))

  (define (bag-empty? x)
   (null? (second x)))

  (define empty-bag (list 'stack null))
  
  (define (bag-insert lst x)
    (list 'stack (cons x (second lst))))

  (define (bag-peek lst)
    (car (second lst)))

  (define (bag-remove lst)
   (list 'stack (cdr (second lst)))))

;; struktura danych - kolejka FIFO

(define-unit bag-fifo@
  (import)
  (export bag^)

  (define (bag? x)
    (and (list? x)
         (eq? (length x) 3)
         (eq? (car x) 'fifo)))


  (define (bag-empty? x)
   (and (empty? (second x)) (empty? (third x))))
  
  (define empty-bag (list 'fifo '() '()))


  (define (bag-insert qu x)
    (list 'fifo (cons x (second qu)) (third qu)))

  (define (bag-peek qu)
    (if (null? (third qu)) (last (second qu))
        (car (third qu))))


  (define (bag-remove qu)
    (if (null? (third qu)) (list 'fifo null (cdr (reverse (second qu))))
        (list 'fifo (second qu) (cdr (third qu))))))

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

(define grafek
  (graph (list 1 2 3 4 5 6)
         (list (edge 1 2)
               (edge 2 5)
               (edge 5 4)
               (edge 4 1)
               (edge 1 3)
               (edge 3 4)
               (edge 3 6)
               (edge 2 4))))

(define grafek2
  (graph (list 1 2 3 4)
         (list (edge 1 2)
               (edge 1 4)
               (edge 1 3)
               (edge 2 3)
               (edge 2 4))))

(define grafek3
  (graph (list 1 2 3 4 5 6 7)
         (list (edge 2 1)
               (edge 2 7)
               (edge 7 4)
               (edge 2 4)
               (edge 3 2)
               (edge 4 3)
               (edge 5 4)
               (edge 5 6)
               (edge 6 5))))
               

;; otwarcie komponentu stosu

(define-values/invoke-unit/infer bag-stack@)

;; opcja 2: otwarcie komponentu kolejki
; (define-values/invoke-unit/infer bag-fifo@)

;; testy w Quickchecku
(require quickcheck)

;; jeśli jakaś własność dotyczy tylko stosu lub tylko kolejki,
;; wykomentuj ją i opisz to w komentarzu powyżej własności

;; otwarcie komponentu przeszukiwania
(define-values/invoke-unit/infer graph-search@)


;;TESTY
(require rackunit)
(define good? #t)


;; dla stosu
(when good?
  (quickcheck
   (property ([a arbitrary-symbol]
              [b arbitrary-symbol]
              [c arbitrary-symbol])
             (and
              ;;ostatni dodany element musi być pokazywany przez procedurę bag-peek
              (equal? (bag-peek (bag-insert (bag-insert (bag-insert empty-bag a) b) c))
                       c)
              ;;gdy zdejmuję element ze stosu upewniam się, że reszta tam pozostaje
              (equal? (bag-remove (bag-insert (bag-insert (bag-insert empty-bag a) b) c))
                      (bag-insert (bag-insert empty-bag a) b))
              ;; test przykładowy: jeśli do pustej struktury dodamy element
              ;; i od razu go usuniemy, wynikowa struktura jest pusta
              (bag-empty? (bag-remove (bag-insert empty-bag a))))))

  ;;używane dzięki rackunit:

  ;;dla grafu dołączonego do szablonu:
  (check-equal? (search test-graph 4) '(4))
  (check-equal? (search test-graph 3) '(3))
  (check-equal? (search test-graph 2) '(2 4))
  (check-equal? (search test-graph 1) '(1 2 4 3))
  ;;dla grafu "grafek"
  (check-equal? (search grafek 1) '(1 3 6 4 2 5))
  (check-equal? (search grafek 2) '(2 4 1 3 6 5))
  (check-equal? (search grafek 3) '(3 6 4 1 2 5))
  (check-equal? (search grafek 4) '(4 1 3 6 2 5))
  (check-equal? (search grafek 5)'(5 4 1 3 6 2))
  (check-equal? (search grafek 6) '(6))
  ;;"grafek2"
  (check-equal? (search grafek2 1) '(1 3 4 2))
  (check-equal? (search grafek2 2) '(2 4 3))
  (check-equal? (search grafek2 3) '(3))
  (check-equal? (search grafek2 4) '(4))
  ;;"grafek3"
  (check-equal? (search grafek3 1) '(1))
  (check-equal? (search grafek3 2) '(2 4 3 7 1))
  (check-equal? (search grafek3 3) '(3 2 4 7 1))
  (check-equal? (search grafek3 4) '(4 3 2 7 1))
  (check-equal? (search grafek3 5) '(5 6 4 3 2 7 1))
  (check-equal? (search grafek3 6) '(6 5 4 3 2 7 1))
  (check-equal? (search grafek3 7) '(7 4 3 2 1)))

;;dla kolejki:


(unless good?
  (quickcheck
   (property ([a arbitrary-symbol]
              [b arbitrary-symbol]
              [c arbitrary-symbol])
             (and
              ;;pierwszy dodany element musi być wskazany przez bag-peek
              (equal? (bag-peek (bag-insert (bag-insert (bag-insert empty-bag a) b) c))
                       a)
              ;;odwracanie listy wyjściowej przy bag-remove
              (equal? (bag-peek (bag-remove (bag-insert (bag-insert (bag-insert empty-bag a) b) c)))
                      b)
              ;; test przykładowy: jeśli do pustej struktury dodamy element
              ;; i od razu go usuniemy, wynikowa struktura jest pusta
              (bag-empty? (bag-remove (bag-insert empty-bag a))))))
  
  ;;przy rackunit dla kolejki
  ;;dla grafu testowego, dołączonego do szablonu
  (check-equal? (search test-graph 4) '(4))
  (check-equal? (search test-graph 3) '(3))
  (check-equal? (search test-graph 2) '(2 4))
  (check-equal? (search test-graph 1) '(1 3 2 4))
   ;;dla grafu "grafek"
  (check-equal? (search grafek 1) '(1 2 3 5 4 6))
  (check-equal? (search grafek 2) '(2 5 4 1 3 6))
  (check-equal? (search grafek 3) '(3 4 6 1 2 5))
  (check-equal? (search grafek 4) '(4 1 2 3 5 6))
  (check-equal? (search grafek 5) '(5 4 1 2 3 6))
  (check-equal? (search grafek 6) '(6))
  ;;"grafek2"
  (check-equal? (search grafek2 1) '(1 2 4 3))
  (check-equal? (search grafek2 2) '(2 3 4))
  (check-equal? (search grafek2 3) '(3))
  (check-equal? (search grafek2 4) '(4))
  ;;"grafek3"
  (check-equal? (search grafek3 1) '(1))
  (check-equal? (search grafek3 2) '(2 1 7 4 3))
  (check-equal? (search grafek3 3) '(3 2 1 7 4))
  (check-equal? (search grafek3 4) '(4 3 2 1 7))
  (check-equal? (search grafek3 5) '(5 4 6 3 2 1 7))
  (check-equal? (search grafek3 6) '(6 5 4 3 2 1 7))
  (check-equal? (search grafek3 7) '(7 4 3 2 1)))

