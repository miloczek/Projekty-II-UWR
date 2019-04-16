#lang racket

;;WYKŁAD 1

(require racket/contract)

(define/contract foo number? 42)

(define/contract (dist x y)
  (-> number? number? number?)
  (abs (- x y)))

(define/contract (average x y)
  (-> number? number? number?)
  (/ (+ x y) 2))

(define/contract (square x)
  (-> number? number?)
  (* x x))

;;WYKŁAD 2

(define/contract (sqrt x)
  (-> positive? positive?)
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


(define/contract (inc i)
  (-> integer? integer?)
  (+ i 1))

;; definicje złożonych kontraktów
(define natural/c (and/c integer? (not/c negative?)))
(define exact-natural/c (and/c natural/c exact?))
(define positive-natural/c (and/c integer? positive?))

;; silnia jako procedura rekurencyjna
;; jeśli damy samo natural/c, (fact 1000.0) łamie kontrakt
(define/contract (fact n)
  (-> exact-natural/c positive-natural/c)
  (if (= n 0)
      1
      (* n (fact (- n 1)))))

;; równoważność dwóch definicji przez indukcję, wymaga uogólnienia twierdzenia do
;; dla każdego n, jeśli (natural? n) to dla każdego i (= (fact (+ n i)) (fact-iter (+ n i) i (fact i)))

(define/contract (close-enough? x y)
  (-> number? number? boolean?)
  (< (dist x y) 0.00001))

;; obliczanie (przybliżonego) punktu stałego funkcji f przez iterację, let pozwala uniknąć powtarzania obliczeń
;; test kontraktu: (fix-point positive? 0)
(define/contract (fix-point f x0)
  (-> (-> number? number?) number? number?)
  (let ((x1 (f x0)))
    (if (close-enough? x0 x1)
        x0
        (fix-point f x1))))

;; próba obliczania pierwiastka kwadratowego z x jako punktu stałego funkcji y ↦ x / y zapętla się
;; stosujemy tłumienie z uśrednieniem: procedurę wyższego rzędu zwracającą procedurę jako wynik
(define/contract (average-damp f)
  (-> (-> number? number?) (-> number? number?))
  (lambda (x) (/ (+ x (f x)) 2)))

(define/contract (sqrt-ad x)
  (-> positive? number?)
  (fix-point (average-damp (lambda (y) (/ x y))) 1.0))

;; obliczanie pochodnej funkcji z definicji przyjmując dx za "odpowiednio małą" wartość (zamiast "prawdziwej" granicy)
(define/contract (deriv f)
  (-> (-> number? number?) (-> number? number?))
  (let ((dx 0.000001))
    (lambda (x) (/ (- (f (+ x dx)) (f x)) dx))))

;; przekształcenie Newtona: x ↦ x - f(x) / f'(x) pozwala obliczyć miejsce zerowe f jako punkt stały tej transformacji
(define/contract (newton-transform f)
  (-> (-> number? number?) (-> number? number?))
  (lambda (x)
    (- x
       (/ (f x)
          ((deriv f) x)))))

(define/contract (newtons-method f x)
  (-> (-> number? number?) number? number?)
  (fix-point (newton-transform f) x))

;; zastosowania
(define/contract pi positive? (newtons-method sin 3))

(define/contract (sqrt-nm x)
  (-> positive? number?)
  (newtons-method (lambda (y) (- x (square y))) 1.0))

;; funkcja identycznościowa -- zwraca argument niezmieniony
;; kontrakt gwarantuje to
(define/contract (id x)
  (let ([a (new-∀/c 'a)])
    (-> a a))
  x)

;; funkcja konkatenacji list
;; kontrakt gwarantuje, że elementami listy wyjściowej będą
;; tylko elementy list wejściowych
(define/contract (append xs ys)
  (let ([a (new-∀/c 'a)])
    (-> (listof a) (listof a) (listof a)))
  (if (null? xs)
      ys
      (cons (car xs) (append (cdr xs) ys))))

;; funkcja map
;; kontrakt gwarantuje, że funkcja f otrzyma jako parametr wyłącznie
;; elementy z listy wejściowej, zaś na liście wyjściowej znajdą się
;; wyłącznie wyniki funkcji f
(define/contract (map f xs)
  (let ([a (new-∀/c 'a)]
        [b (new-∀/c 'b)])
    (-> (-> a b) (listof a) (listof b)))
  (if (null? xs)
      null
      (cons (f (car xs))
            (map f (cdr xs)))))

;; funkcja fold
;; kontrakt gwarantuje prawidłowe użycie funkcji op
(define/contract (fold-right op nval xs)
  (let ([a (new-∀/c 'a)]
        [b (new-∀/c 'b)])
    (-> (-> a b b) b (listof a) b))
  (if (null? xs)
      nval
      (op (car xs)
          (fold-right op nval (cdr xs)))))

(require quickcheck)

;; funkcja map zachowuje długość
(quickcheck
 (property ([l (arbitrary-list arbitrary-symbol)]
            [p (arbitrary-procedure arbitrary-symbol arbitrary-symbol)])
           (eq? (length l) (length (map p l)))))

;; długość konkatenacji list to suma długości list wejściowych
(quickcheck
 (property ([l1 (arbitrary-list arbitrary-symbol)]
            [l2 (arbitrary-list arbitrary-symbol)])
           (eq? (length (append l1 l2)) (+ (length l1) (length l2)))))

;; rozdzielność append względem map
(quickcheck
 (property ([l1 (arbitrary-list arbitrary-symbol)]
            [l2 (arbitrary-list arbitrary-symbol)]
            [p (arbitrary-procedure arbitrary-symbol arbitrary-symbol)])
           (equal? (map p (append l1 l2)) (append (map p l1) (map p l2)))))

;; błędna implementacja map -- odwraca listę
;; podany kontrakt nie sprawdza kolejności
(define/contract (bad-map f xs)
  (let ([a (new-∀/c 'a)]
        [b (new-∀/c 'b)])
    (-> (-> a b) (listof a) (listof b)))
  (define (map-iter xs ys)
    (cond [(null? xs) ys]
          [else (map-iter (cdr xs) (cons (f (car xs)) ys))]))
  (map-iter xs '()))

;; błędna implementacja map nie ma własności rozdzielności względem append
(quickcheck
 (property ([l1 (arbitrary-list arbitrary-symbol)]
            [l2 (arbitrary-list arbitrary-symbol)]
            [p (arbitrary-procedure arbitrary-symbol arbitrary-symbol)])
           (equal? (bad-map p (append l1 l2)) (append (bad-map p l1) (bad-map p l2)))))



;; sygnatura słowników bez kontraktów
;(define-signature dict^
;  (dict? dict-empty? empty-dict dict-insert dict-remove dict-lookup))

;; sygnatura słowników z prostymi kontraktami
;(define-signature dict^
;  ((contracted
;    [dict?       (-> any/c boolean?)]
;    [dict-empty? (-> dict? boolean?)]
;    [empty-dict  (and/c dict? dict-empty?)]
;    [dict-insert (-> dict? string? any/c dict?)]
;    [dict-remove (-> dict? string? dict?)]
;    [dict-lookup (-> dict? string?
;                     (or/c (cons/c string? any/c) #f))])))

;; sygnatura słowników z kontraktami zależnymi
(define-signature dict^
  ((contracted
    [dict?       (-> any/c boolean?)]
    [dict-empty? (-> dict? boolean?)]
    [empty-dict  (and/c dict? dict-empty?)]
    [dict-insert (->i ([d dict?]
                       [k string?]
                       [v any/c])
                      [result (and/c dict? (not/c dict-empty?))]
                      #:post (result k v)
                      (let ((p (dict-lookup result k)))
                        (and
                          (pair? p)
                          (eq? (car p) k)
                          (eq? (cdr p) v))))]
    [dict-remove (->i ([d dict?]
                       [k string?])
                      [result dict?]
                      #:post (result k)
                      (eq? #f (dict-lookup result k)))]
    [dict-lookup (->i ([d dict?]
                       [k string?])
                     (result (or/c (cons/c string? any/c) #f))
                     #:post (result d)
                     (if (dict-empty? d) (eq? #f result) #t))])))
    
;; implementacja słowników na listach
(define-unit dict-list@
  (import)
  (export dict^)

  (define (dict? d)
    (and (list? d)
         (eq? (length d) 2)
         (eq? (car d) 'dict-list)))

  (define (dict-list d) (cadr d))
  (define (dict-cons l) (list 'dict-list l))
  
  (define (dict-empty? d)
    (eq? (dict-list d) '()))

  (define empty-dict (dict-cons '()))

  (define (dict-lookup d k) (assoc k (dict-list d)))

  (define (dict-remove d k)
    (dict-cons (remf (lambda (p) (eq? (car p) k)) (dict-list d))))

  (define (dict-insert d k v)
    (dict-cons (cons (cons k v)
                     (dict-list (dict-remove d k))))))

;; otwarcie implementacji słownika
(define-values/invoke-unit/infer dict-list@)

(define dx1 (dict-insert empty-dict "x" 1))
(define dx2 (dict-insert dx1 "x" 2))
(define dx1y2 (dict-insert dx1 "y" 2))

(require quickcheck)

;; funkcja budująca słownik z listy par
(define (list->dict l)
  (cond [(null? l) empty-dict]
        [else (dict-insert (list->dict (cdr l)) (caar l) (cdar l))]))

;; generator list klucz-wartość
(define arbitrary-dict-list
  (arbitrary-list (arbitrary-pair arbitrary-string arbitrary-integer)))

;; element po dodaniu do słownika jest w słowniku
(quickcheck
 (property
  ([l arbitrary-dict-list]
   [k arbitrary-string]
   [v arbitrary-integer])
  (let* ((d (list->dict l))
         (di (dict-insert d k v))
         (dl (dict-lookup di k)))
    (and (pair? dl)
         (eq? (car dl) k)
         (eq? (cdr dl) v)))))

