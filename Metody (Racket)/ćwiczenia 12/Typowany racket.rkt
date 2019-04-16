#lang typed/racket

;; WYKŁAD 1

(: dist (-> Real Real Real))
(define (dist x y)
  (abs (- x y)))

(: average (-> Real Real Real))
(define (average x y)
  (/ (+ x y) 2))

(: square (-> Real Real))
(define (square x)
  (* x x))

(: sqrt (-> Real Real))
(define (sqrt x)
  ;; lokalne definicje
  ;; poprawienie przybliżenia pierwiastka z x
  (: improve (-> Real Real))
  (define (improve approx)
    (average (/ x approx) approx))
  ;; nazwy predykatów zwyczajowo kończymy znakiem zapytania
  (: good-enough? (-> Real Boolean))
  (define (good-enough? approx)
    (< (dist x (square approx)) 0.0001))
  ;; główna procedura znajdująca rozwiązanie
  (: iter (-> Real Real))
  (define (iter approx)
    (cond
      [(good-enough? approx) approx]
      [else                  (iter (improve approx))]))
  
  (iter 1.0))

;; FUNKCJE NA LISTACH

(: length (-> (Listof Any) Nonnegative-Integer))
(define (length xs)
  (if (null? xs)
      0
      (+ 1 (length (cdr xs)))))

(: append (All (A) (-> (Listof A) (Listof A) (Listof A))))
(define (append xs ys)
  (if (null? xs)
      ys
      (cons (car xs) (append (cdr xs) ys))))

(: map (All (A B) (-> (-> A B) (Listof A) (Listof B))))
(define (map f xs)
  (if (null? xs)
      null
      (cons (f (car xs))
            (map f (cdr xs)))))

(: fold-right (All (A B) (-> (-> A B B) B (Listof A) B)))
(define (fold-right op nval xs)
  (if (null? xs)
      nval
      (op (car xs)
          (fold-right op nval (cdr xs)))))

;; LICZBY WYMIERNE

;; definiujemy reprezentację liczb wymiernych
(define-type Rat (Pairof Integer Integer))

(: make-rat (-> Integer Integer Rat))
(define (make-rat n d)
  (let ((c (gcd n d)))
    (cons (quotient n c) (quotient d c))))

(: rat-numer (-> Rat Integer))
(define (rat-numer l)
  (car l))

(: rat-denum (-> Rat Integer))
(define (rat-denum l)
  (cdr l))

;; tak zdefiniowany predykat nie zawęża typu
;(: rat? (-> Any Boolean))
;(define (rat? x)
;  (and (pair? x) (integer? (car x)) (integer? (cdr x))))

;; automatyczne definiowanie predykatu z zawężaniem
(define-predicate rat? Rat)
; (:print-type rat?)
; (-> Any Boolean : Rat)

;; i pakiet operacji dla użytkownika
(: integer->rational (-> Integer Rat))
(define (integer->rational n)
  (make-rat n 1))

(: div-rat (-> Rat Rat Rat))
(define (div-rat l1 l2)
  (let ((n (* (rat-numer l1) (rat-denum l2)))
        (d (* (rat-denum l1) (rat-numer l2))))
    (make-rat n d)))

;; wypisywanie liczb wymiernych w formie czytelnej dla człowieka
(: print-rat (-> Rat Void))
(define (print-rat l)
  (display (rat-numer l))
  (display "/")
  (display (rat-denum l)))

;; konwersja wartości jednego z typów na liczbę wymierną
;; wymagane zawężenie typu!
(: to-rat (-> (U Integer Rat) Rat))
(define (to-rat n)
  (cond [(integer? n) (integer->rational n)]
        [(rat? n) n]))

;;; drzewa binarne

(define-type Leaf 'leaf)
(define-type (Node A B) (List 'node A B B))
(define-type (Tree A) (U Leaf (Node A (Tree A))))

(define-predicate leaf? Leaf)
(define-predicate node? (Node Any Any))
(define-predicate tree? (Tree Any))

(: leaf Leaf)
(define leaf 'leaf)

(: node-val (All (A B) (-> (Node A B) A)))
(define (node-val x)
  (cadr x))

(: node-left (All (A B) (-> (Node A B) B)))
(define (node-left x)
  (caddr x))

(: node-right (All (A B) (-> (Node A B) B)))
(define (node-right x)
  (cadddr x))

(: make-node (All (A B) (-> A B B (Node A B))))
(define (make-node v l r)
  (list 'node v l r))

;;; wyszukiwanie i wstawianie w drzewach przeszukiwań binarnych

(: bst-find (-> Integer (Tree Integer) Boolean))
(define (bst-find x t)
  (cond [(leaf? t)          false]
        [(= x (node-val t)) true]
        [(< x (node-val t)) (bst-find x (node-left t))]
        [else (bst-find x (node-right t))]))

(: bst-insert (-> Integer (Tree Integer) (Tree Integer)))
(define (bst-insert x t)
  (cond [(leaf? t)
         (make-node x leaf leaf)]
        [(< x (node-val t))
         (make-node (node-val t)
                    (bst-insert x (node-left t))
                    (node-right t))]
        [else
         (make-node (node-val t)
                    (node-left t)
                    (bst-insert x (node-right t)))]))

;; definicja typu wyrażeń

(define-type BinopNum (U '+ '- '*))
(define-type BinopRel (U '= '>))
(define-type BinopBool (U 'and 'or))
(define-type BinopSym (U BinopNum BinopRel BinopBool))
(struct expr-binop ([op : BinopSym] [l : Expr] [r : Expr]))
(struct expr-if ([c : Expr] [t : Expr] [f : Expr]))
(struct expr-let ([var : Symbol] [def : Expr] [expr : Expr]))
(define-type Literal (U Integer Boolean))
(define-type Expr (U Symbol Literal expr-binop expr-if expr-let))

(define-predicate literal? Literal)
(define-predicate op-num? BinopNum)
(define-predicate op-rel? BinopRel)
(define-predicate op-bool? BinopBool)

;; środowiska

(define-type Value (U Integer Boolean))
(define-type (Env A) (Listof (List Symbol A)))
(define-type VEnv (Env Value))

(: empty-env (All (A) (-> (Env A))))
(define (empty-env)
  null)

(: add-to-env (All (A) (-> Symbol A (Env A) (Env A))))
(define (add-to-env x v env)
  (cons (list x v) env))

(: find-in-env (All (A) (-> Symbol (Env A) A)))
(define (find-in-env x env)
  (cond [(null? env) (error "undefined variable" x)]
        [(eq? x (caar env)) (cadar env)]
        [else (find-in-env x (cdr env))]))

;; ewaluator

(: op-num->proc (-> BinopNum (-> Value Value Value)))
(define (op-num->proc op)
  (lambda (a b)
    (if (and (number? a) (number? b))
        (cond [(eq? op '+) (+ a b)]
              [(eq? op '*) (* a b)]
              [(eq? op '-) (- a b)])
        (error "type error in op-num->proc"))))

(: op-rel->proc (-> BinopRel (-> Value Value Value)))
(define (op-rel->proc op)
  (lambda (a b)
    (if (and (number? a) (number? b))
        (cond [(eq? op '=) (= a b)]
              [(eq? op '>) (> a b)])
        (error "type error in op-num->proc"))))

(: op-bool->proc (-> BinopBool (-> Value Value Value)))
(define (op-bool->proc op)
  (lambda (a b)
    (if (and (boolean? a) (boolean? b))
        (cond [(eq? op 'and) (and a b)]
              [(eq? op 'or) (or a b)])
        (error "type error in op-num->proc"))))

(: op->proc (-> BinopSym (-> Value Value Value)))
(define (op->proc op)
  (cond [(op-num? op) (op-num->proc op)]
        [(op-rel? op) (op-rel->proc op)]
        [(op-bool? op) (op-bool->proc op)]))

(: eval (-> VEnv Expr Value))
(define (eval env e)
  (cond [(literal? e) e]
        [(symbol? e) (find-in-env e env)]
        [(expr-binop? e)
         ((op->proc (expr-binop-op e))
          (eval env (expr-binop-l e))
          (eval env (expr-binop-r e)))]
        [(expr-if? e)
         (if (eval env (expr-if-c e))
             (eval env (expr-if-t e))
             (eval env (expr-if-f e)))]
        [(expr-let? e)
         (eval (add-to-env (expr-let-var e) (eval env (expr-let-def e)) env)
               (expr-let-expr e))]))

;; typechecker

(define-type EType (U 'integer 'boolean))
(define-type TEnv (Env EType))

(: typeinfer (-> TEnv Expr EType))
(define (typeinfer env e)
  (define (equal-types t1 t2)
    (if (equal? t1 t2) #t (error "type error")))
  (cond [(integer? e) 'integer]
        [(boolean? e) 'boolean]
        [(symbol? e) (find-in-env e env)]
        [(expr-binop? e)
         (define (typeinfer-binop t1 t2)
                (let ([lt (typeinfer env (expr-binop-l e))]
                      [rt (typeinfer env (expr-binop-r e))])
                  (equal-types lt t1)
                  (equal-types rt t1)
                  t2))
         (cond [(op-num? (expr-binop-op e))
                (typeinfer-binop 'integer 'integer)]
               [(op-rel? (expr-binop-op e))
                (typeinfer-binop 'integer 'boolean)]
               [(op-bool? (expr-binop-op e))
                (typeinfer-binop 'boolean 'boolean)])]
        [(expr-if? e)
         (let ([ct (typeinfer env (expr-if-c e))]
               [tt (typeinfer env (expr-if-t e))]
               [ft (typeinfer env (expr-if-f e))])
           (equal-types ct 'boolean)
           (equal-types tt ft)
           tt)]
        [(expr-let? e)
         (let* ([dt (typeinfer env (expr-let-def e))]
                [env1 (add-to-env (expr-let-var e) dt env)]
                [et (typeinfer env1 (expr-let-expr e))])
           et)]))
