#lang racket

(require racklog)

;; predykat unarny %male reprezentuje zbiór mężczyzn
(define %male
  (%rel ()
        [('adam)]
        [('john)]
        [('joshua)]
        [('mark)]
        [('david)]))

;; predykat unarny %female reprezentuje zbiór kobiet
(define %female
  (%rel ()
        [('eve)]
        [('helen)]
        [('ivonne)]
        [('anna)]))

;; predykat binarny %parent reprezentuje relację bycia rodzicem
(define %parent
  (%rel ()
        [('adam 'helen)]
        [('adam 'ivonne)]
        [('adam 'anna)]
        [('eve 'helen)]
        [('eve 'ivonne)]
        [('eve 'anna)]
        [('john 'joshua)]
        [('helen 'joshua)]
        [('ivonne 'david)]
        [('mark 'david)]))

;; predykat binarny %sibling reprezentuje relację bycia rodzeństwem
(define %sibling
  (%rel (a b c)
        [(a b)
         (%parent c a)
         (%parent c b)]))

;; predykat binarny %sister reprezentuje relację bycia siostrą
(define %sister
  (%rel (a b)
        [(a b)
         (%sibling a b)
         (%female a)]))

;; predykat binarny %ancestor reprezentuje relację bycia przodkiem
(define %ancestor
  (%rel (a b c)
        [(a b)
         (%parent a b)]
        [(a b)
         (%parent a c)
         (%ancestor c b)]))

(define %my-append
  (%rel (x xs ys zs)
        [(null ys ys)]
        [((cons x xs) ys (cons x zs))
         (%my-append xs ys zs)]))

(define %my-member
  (%rel (x xs y)
        [(x (cons x xs))]
        [(y (cons x xs))
         (%my-member y xs)]))

(define %select
  (%rel (x xs y ys)
        [(x (cons x xs) xs)]
        [(y (cons x xs) (cons x ys))
         (%select y xs ys)]))

;; prosta rekurencyjna definicja
(define %simple-length
  (%rel (x xs n m)
        [(null 0)]
        [((cons x xs) n)
         (%simple-length xs m)
         (%is n (+ m 1))]))

;; test w trybie +- (działa)
(%find-all (a) (%simple-length (list 1 2) a))
;; test w trybie ++ (działa)
(%find-all () (%simple-length (list 1 2) 2))
;; test w trybie -+ (1 odpowiedź, pętli się)
(%which (xs) (%simple-length xs 2))
;; test w trybie -- (nieskończona liczba odpowiedzi)
(%which (xs a) (%simple-length xs a))

;; definicja zakładająca, że długość jest znana
(define %gen-length
  (%rel (x xs n m)
        [(null 0) !]
        [((cons x xs) n)
         (%is m (- n 1))
         (%gen-length xs m)]))
;; test w trybie ++ (działa)
(%find-all () (%gen-length (list 1 2) 2))
;; test w trybie -+ (działa)
(%find-all (xs) (%gen-length xs 2))


;; Zadanie 1

;; a)

(define %grandson
  (%rel (a b c)
        [(a c)
         (%parent b a)
         (%parent c b)
         (%male a)]))

;; b)

(define %cousin
  (%rel (a b c d)
        [(a d)
         (%parent b a)
         (%sibling b c)
         (%parent c d)
         (%/= b c)
         (%/= a d)]))

;; c)

(define %is_mother
  (%rel (a b)
        [(a)
         (%parent a b)
         (%female a)]))

;; d)

(define %is_father
  (%rel (a b)
        [(a)
         (%parent a b)
         (%male a)]))

;; Zadanie 2

;; a)

(%find-all (x) (%and (%ancestor 'mark x) (%= x 'john)))

;; b)

(%find-all (x) (%ancestor 'adam x))

;; c)
(%find-all (x) (%and (%sister 'ivonne x) (%/= x 'ivonne)))

;; d)

(%find-all (x y) (%and (%/= x y) (%cousin x y)))

;; Zadanie 3

;; a)

(%which (l1 l2) (%append l1 l1 l2))
(%more)
(%more)

;; b)

(%which (x) (%select x '(1 2 3 4) '(1 2 4)))

;; c)

(%which (l) (%my-append '(1 2 3) l '(1 2 3 4 5)))

;; Zadanie 4 (...) zeszyt!

;; Zadanie 5 (...) zeszyt!

;; Zadanie 6

(define %sublist
  (%rel (x xs y ys)
        [(null ys)]
        [((cons x xs) (cons y ys))
         (%or (%and (%= x y) (%sublist xs ys))
              (%sublist (cons x xs) ys))]))

;; Zadanie 7

(define %perm
  (%rel (x xs ys zs)
        [(null null)]
        [((cons x xs) ys)
         (%select x ys zs)
         (%perm xs zs)]))



