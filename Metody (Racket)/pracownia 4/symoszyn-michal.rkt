#lang racket

(define (inc n)
  (+ n 1))

;;; ordered elements
(define (make-elem pri val) ;; element składa się z priorytetu i wartości
  (cons pri val))

(define (elem-priority x) ;; selektor priorytetu
  (car x))

(define (elem-val x) ;; selektor-wartości
  (cdr x))

;;; leftist heaps (after Okasaki)

;; data representation


(define leaf 'leaf)

(define (leaf? h) (eq? 'leaf h))

(define (hnode? h)
  (and (list? h)
       (= 5 (length h))
       (eq? (car h) 'hnode)
       (natural? (caddr h)))) ;; predykat sprawdzający czy jest korzeniem drzewa lewicowego

(define (make-node elem heap-a heap-b)          ;; konstruuje odpowiedni korzeń
  (define rank_count
    (if (or (leaf? heap-a) (leaf? heap-b))     ;; rank_count liczy rangę naszego drzew, jeśli któreś z danych jest puste- zwraca 1
        1
        (inc (max (rank heap-a) (rank heap-b)))))  ;; w przeciwnym przypadku bierze rangę większego z nich i zwiększa o 1
  (cond [(> (rank heap-a) (rank heap-b)) (list 'hnode elem rank_count heap-a heap-b)]
        [else                            (list 'hnode elem rank_count heap-b heap-a)]))

(define (node-elem h) ;; selektor elementu
  (second h))

(define (node-left h) ;; selektor lewego poddrzewa
  (fourth h))

(define (node-right h) ;;selektor prawego poddrzewa
  (fifth h))

(define (hord? p h)
  (or (leaf? h)
      (<= p (elem-priority (node-elem h))))) ;;  predykat sprawdzjący porządek, czy nowy

(define (heap? h)
  (or (leaf? h)
      (and (hnode? h)
           (heap? (node-left h))
           (heap? (node-right h))
           (<= (rank (node-right h))
               (rank (node-left h)))
           (= (rank h) (inc (rank (node-right h))))
           (hord? (elem-priority (node-elem h))
                  (node-left h))
           (hord? (elem-priority (node-elem h))
                  (node-right h)))))

(define (rank h)
  (if (leaf? h)
      0
      (third h)))

;; operations

(define empty-heap leaf)

(define (heap-empty? h)
  (leaf? h))

(define (heap-insert elt heap)
  (heap-merge heap (make-node elt leaf leaf)))

(define (heap-min heap)
  (node-elem heap))

(define (heap-pop heap)
  (heap-merge (node-left heap) (node-right heap)))

(define (heap-merge h1 h2) 
  (cond
    [(leaf? h1) h2]
    [(leaf? h2) h1]
    [else
     (define minimum_h1 (elem-val (heap-min h1))) ;; będziemy używać minimalnego elementu z obu danych kopców
     (define minimum_h2 (elem-val (heap-min h2)))
     (let ((e (if (> minimum_h1 minimum_h2)   ;; e jest mniejszym elementem, z najmniejszych elementów obu kopców
                  (node-elem h2)
                  (node-elem h1)))
           (hl (if (> minimum_h1 minimum_h2) ;; hl to lewe poddrzewo kopca z którego jest e
                   (node-left h2)
                   (node-left h1)))
           (hr (if (> minimum_h1 minimum_h2) ;; hr to prawe poddrzewo tego kopca
                   (node-right h2)
                   (node-right h1)))
           (h (if (> minimum_h1 minimum_h2) ;; h to ten drugi kopiec, którego e nie jest elementem
                  h1
                  h2)))
           (let ((res (heap-merge hr h))) ;; res jest scaleniem hr i h
             (make-node e hl res)))]))


;;; heapsort. sorts a list of numbers.
(define (heapsort xs)
  (define (popAll h)
    (if (heap-empty? h)
        null
        (cons (elem-val (heap-min h)) (popAll (heap-pop h)))))
  (let ((h (foldl (lambda (x h)
                    (heap-insert (make-elem x x) h))
            empty-heap xs)))
    (popAll h)))

;;; check that a list is sorted (useful for longish lists)
(define (sorted? xs)
  (cond [(null? xs)              true]
        [(null? (cdr xs))        true]
        [(<= (car xs) (cadr xs)) (sorted? (cdr xs))]
        [else                    false]))

;;; generate a list of random numbers of a given length
(define (randlist len max)
  (define (aux len lst)
    (if (= len 0)
        lst
        (aux (- len 1) (cons (random max) lst))))
  (aux len null))



;; TESTY


(display "Test na pustej liście:  ") (display (randlist 0 20))

(display "Sorted? ") (sorted? (randlist 0 20))

(define lista1 (randlist 20 100))
(define lista2 (randlist 50 10000000))

(display "Lista1:") (display lista1)(sorted? lista1)
(display "Posortowana") (display (heapsort lista1))(display (sorted?(heapsort lista1)))

(display "Lista2:") (display lista2)(sorted? lista2)
(display "Posortowana") (display (heapsort lista2))(display (sorted?(heapsort lista2)))


