#lang racket
 
;; pomocnicza funkcja dla list tagowanych o określonej długości
 
(define (tagged-tuple? tag len p)
  (and (list? p)
       (= (length p) len)
       (eq? (car p) tag)))
 
(define (tagged-list? tag p)
  (and (pair? p)
       (eq? (car p) tag)
       (list? (cdr p))))
 
;;
;; WHILE
;;
 
; memory
 
(define empty-mem
  null)
 
(define (set-mem x v m)
  (cond [(null? m)
         (list (cons x v))]
        [(eq? x (caar m))
         (cons (cons x v) (cdr m))]
        [else
         (cons (car m) (set-mem x v (cdr m)))]))
 
(define (get-mem x m)
  (cond [(null? m) 0]
        [(eq? x (caar m)) (cdar m)]
        [else (get-mem x (cdr m))]))
 
; arith and bool expressions: syntax and semantics
 
(define (const? t)
  (number? t))
 
(define (true? t)
  (eq? t 'true))
 
(define (false? t)
  (eq? t 'false))
 
(define (op? t)
  (and (list? t)
       (member (car t) '(+ - * / = > >= < <= not and or mod rand))))
 
(define (op-op e)
  (car e))
 
(define (op-args e)
  (cdr e))
 
(define (op->proc op)
  (cond [(eq? op '+) +]
        [(eq? op '*) *]
        [(eq? op '-) -]
        [(eq? op '/) /]
        [(eq? op '=) =]
        [(eq? op '>) >]
        [(eq? op '>=) >=]
        [(eq? op '<)  <]
        [(eq? op '<=) <=]
        [(eq? op 'not) not]
        [(eq? op 'and) (lambda x (andmap identity x))]
        [(eq? op 'or) (lambda x (ormap identity x))]
        [(eq? op 'mod) modulo]
        ;[(eq? op 'rand) (lambda (max) (min max 4))])) ; chosen by fair dice roll.
                                                      ; guaranteed to be random.
        ))
 
(define (var? t)
  (symbol? t))
 
(define (eval-arith e m st)
  (cond [(true? e) (res true st)]
        [(false? e) (res false st)]
        [(rand? e)
         (define val-and-st (eval-arith (second e) m st))
         ((rand (res-val val-and-st)) (res-state val-and-st))]
        [(var? e) (res (get-mem e m) st)]
        [(op? e)
         (define (op-helper op-args acc)
           ;; Procedura op-helper oblicza pierwszy element listy op-args,
           ;; a nastepnie stosuje operator na obliczonym (first (op-args)) i acc,
           ;; przenosi wynik do acc, po czym przechodzi dalej po liscie argumentow,
           ;; az ona sie nie skonczy.
           (if (null? op-args)
               acc
               (let* ([old-res (eval-arith (first op-args) m (res-state acc))]
                      [new-res (res ((op->proc (op-op e)) (res-val acc) (res-val old-res))
                                    (res-state old-res))])
                  (op-helper (cdr op-args) new-res))))
         (define (special-op-helper op-args acc pred?)
           ;; Procedura dla procedur specjalnych jak and i or.
           ;; Jesli lista argumentow jest pusta LUB jesli spelniony jest predykat (np. dla and -- napotkanie #f)
           ;; to zakoncz procedure. W p.p. dziala tak samo jak op-helper
           (if (or (null? op-args) (pred? (res-val acc)))
               acc
               (let* ([old-res (eval-arith (first op-args) m (res-state acc))]
                      [new-res (res ((op->proc (op-op e)) (res-val acc) (res-val old-res))
                                    (res-state old-res))])
                 (special-op-helper (cdr op-args) new-res pred?))))
         (cond ;; Jesli brak argumentow to wywolaj po prostu ((procedura) . stan).
               [(= 0 (length e)) (res ((op->proc (op-op e))) st)]
               ;; Jesli jest tylko jeden argument, to oblicz argument i zastosuj na nim operator.
               [(= 1 (length (cdr e)))
                (define val-and-st (eval-arith (second e) m st))
                (res ((op->proc (op-op e)) (res-val val-and-st)) (res-state val-and-st))]
               ;; W przeciwnym wypadku uzyj procedury op-helper,
               ;; ktorej pierwszym argumentem jest lista argumentow od drugiego wlacznie,
               ;; a drugim jest obliczony pierwszy argument.
               [(eq? (op-op e) 'and) (special-op-helper (cddr e) (eval-arith (second e) m st) (lambda (x) (eq? x #f)))]
               [(eq? (op-op e) 'or)  (special-op-helper (cddr e) (eval-arith (second e) m st) (lambda (x) (eq? x #t)))]
               [else (op-helper (cddr e) (eval-arith (second e) m st))])]
         
        [(const? e) (res e st)]))
 
(define (rand? t)
  (tagged-tuple? 'rand 2 t))
 
;; syntax of commands
 
(define (assign? t)
  (and (list? t)
       (= (length t) 3)
       (eq? (second t) ':=)))
 
(define (assign-var e)
  (first e))
 
(define (assign-expr e)
  (third e))
 
(define (if? t)
  (tagged-tuple? 'if 4 t))
 
(define (if-cond e)
  (second e))
 
(define (if-then e)
  (third e))
 
(define (if-else e)
  (fourth e))
 
(define (while? t)
  (tagged-tuple? 'while 3 t))
 
(define (while-cond t)
  (second t))
 
(define (while-expr t)
  (third t))
 
(define (block? t)
  (list? t))
 
;; state
 
(define (res v s)
  (cons v s))
 
(define (res-val r)
  (car r))
 
(define (res-state r)
  (cdr r))
 
;; psedo-random generator
 
(define initial-seed
  123456789)
 
(define (rand max)
  (lambda (i)
    (let ([v (modulo (+ (* 1103515245 i) 12345) (expt 2 32))])
      (res (modulo v max) v))))
 
;; WHILE interpreter
 
(define (old-eval e m st)
  ;; Wynikiem kazdego z dzialan jest para (wartosc . stan).
  ;; W przypadku old-eval wartoscia jest pamiec.
  ;; W przypadku eval-arith wartoscia jest wartosc obliczonego wyrazenia.
  (cond [(assign? e)
         (define val-and-st (eval-arith (assign-expr e) m st))
         (res (set-mem (assign-var e)
                        (res-val val-and-st)
                        m)
               (res-state val-and-st))]
        [(if? e)
         (define val-and-st (eval-arith (if-cond e) m st))
         (if (res-val val-and-st)
             (old-eval (if-then e) m (res-state val-and-st))
             (old-eval (if-else e) m (res-state val-and-st)))]
        [(while? e)
         (define val-and-st (eval-arith (while-cond e) m st))
         (if (res-val val-and-st)
             (let ([mem-and-st (old-eval (while-expr e) m (res-state val-and-st))])            
               (old-eval e (res-val mem-and-st) (res-state mem-and-st)))
             (res m (res-state val-and-st)))]
        [(block? e)
         (if (null? e)
             (cons m st)
             (let ([mem-and-st (old-eval (car e) m st)])
               (old-eval (cdr e) (res-val mem-and-st) (res-state mem-and-st))))]))
 
(define (eval e m seed)
  (old-eval e m seed))
 
(define (run e)
  (eval e empty-mem initial-seed))
 
;;
 
(define fermat-test
  `( (composite := false)
     (while (and (> k 0) (not composite)) ;; dopoki licznik jest wiekszy od 0 i zlozonosc n nie jest potwierdzona
            ( (a := (+ 2 (rand (- n 2)))) ;; losujemy losowa wartosc z zakresu [2,(n - 2)]
              (pow := (- n 1))            ;; pow to wykladnik
              (x := 1)                    ;; x to wynik potegowania
              (while (> pow 0)            ;; mnozymy x * a dopoki x != a^(n - 1)
                     ( (x := (* x a))
                       (pow := (- pow 1))))
              ;; sprawdzamy czy a^(n-1) - 1 jest podzielne przez n
              ;; jesli tak to n nie jest liczba pierwsza
              ;; w p.p. iterujemy jeszcze raz
              (if (not (= (mod (- x 1) n) 0))
                  (composite := true)
                  () )
              (k := (- k 1)) ))))
 
(define (probably-prime? n k) ; check if a number n is prime using
                              ; k iterations of Fermat's primality
                              ; test
  (let ([memory (set-mem 'k k
                (set-mem 'n n empty-mem))])
    (not (get-mem
           'composite
           (res-val (eval fermat-test memory initial-seed))))))
 
 
(define (primes-from-to f t)
  (if (< f t)
      ;; wypisujemy liczbe jesli jest ona pierwsza
      (if (probably-prime? f 20)
          (begin (display f) (display " ") (primes-from-to (+ f 1) t))
          (begin (display "") (primes-from-to (+ f 1) t)))
      (displayln "Done!")))
 
(primes-from-to 3 100)
 
#|
(define test1
  `( (a := (+ (rand 10) (rand 10))))) ;; powinno wyjsc 9
(run test1)
 
(define test2
  `( (a := (rand 10))
     (b := (rand 10))
     (c := (+ a b)))) ;; tez powinno wyjsc 9
(run test2)
 
(define test3
  `( (a := (rand (rand 7))))) ;; powinno wyjsc 5
(run test3)
 
(define test4 ;; test and-ow i or-ow
  `( (a := (and (= 1 1) (= 1 1) (= 1 1) (= 1 1)))
     (b := (and (= 1 1) (= 1 2) (/ 1 0)))
     (c := (and (= 1 2) (/ 1 0)))
     (d := (or (= 1 2) (= 1 2) (= 1 1)))
     (e := (or (= 1 1) (/ 1 0)))
     (f := (or (= 1 2) (= 1 1) (/ 1 0)))))
(run test4)|#