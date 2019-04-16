#lang racket

;; pomocnicza funkcja dla list tagowanych o określonej długości
(define (tagged-tuple? tag len p)
  (and (list? p)
       (= (length p) len)
       (eq? (car p) tag)))

;; np. (tagged-tuple? 'conj 3 '(conj p q))

(define (tagged-list? tag p)
  (and (pair? p)
       (eq? (car p) tag)
       (list? (cdr p))))

;; reprezentacja danych wejściowych (z ćwiczeń)
(define (var? x)
  (symbol? x))

(define (var x)
  x)

(define (var-name x)
  x)

;; przydatne predykaty na zmiennych
(define (var<? x y)   ;;porównuje zmienne leksykograficznie
  (symbol<? x y))

(define (var=? x y)   ;;czy są takie same
  (eq? x y))

(define (literal? x)
  (and (tagged-tuple? 'literal 3 x)
       (boolean? (cadr x))
       (var? (caddr x))))

(define (literal pol x) ;; pol- jest to wartość boolowska
  (list 'literal pol x))

(define (literal-pol x)
  (cadr x))

(define (literal-var x)
  (caddr x))

(define (clause? x)
  (and (tagged-list? 'clause x)
       (andmap literal? (cdr x))))

(define (clause . lits)  ;; bierze dowolną liczbę argumentów
  (cons 'clause lits))

(define (clause-lits c)
  (cdr c))

(define (cnf? x)
  (and (tagged-list? 'cnf x)
       (andmap clause? (cdr x))))

(define (cnf . cs)  ;;tworzy zbiór klauzul
    (cons 'cnf cs))

(define (cnf-clauses x)
  (cdr x))

;; oblicza wartość formuły w CNF z częściowym wartościowaniem. jeśli zmienna nie jest
;; zwartościowana, literał jest uznawany za fałszywy.
(define (valuate-partial val form)
  (define (val-lit l)
    (let ((r (assoc (literal-var l) val)))
      (cond
       [(not r)  false]
       [(cadr r) (literal-pol l)]
       [else     (not (literal-pol l))])))
  (define (val-clause c)
    (ormap val-lit (clause-lits c)))
  (andmap val-clause (cnf-clauses form)))

;; reprezentacja dowodów sprzeczności

(define (axiom? p)
  (tagged-tuple? 'axiom 2 p))

(define (proof-axiom c)
  (list 'axiom c))

(define (axiom-clause p)
  (cadr p))

(define (res? p)
  (tagged-tuple? 'resolve 4 p))

(define (proof-res x pp pn)
  (list 'resolve x pp pn))

(define (res-var p)
  (cadr p))

(define (res-proof-pos p)
  (caddr p))

(define (res-proof-neg p)
  (cadddr p))

;; sprawdza strukturę, ale nie poprawność dowodu
(define (proof? p)
  (or (and (axiom? p)
           (clause? (axiom-clause p)))
      (and (res? p)
           (var? (res-var p))
           (proof? (res-proof-pos p))
           (proof? (res-proof-neg p)))))

;; procedura sprawdzająca poprawność dowodu
(define (check-proof pf form)
  (define (run-axiom c)
    (displayln (list 'checking 'axiom c))
    (and (member c (cnf-clauses form))
         (clause-lits c)))
  (define (run-res x cpos cneg)
    (displayln (list 'checking 'resolution 'of x 'for cpos 'and cneg))
    (and (findf (lambda (l) (and (literal-pol l)
                                 (eq? x (literal-var l))))
                cpos)
         (findf (lambda (l) (and (not (literal-pol l))
                                 (eq? x (literal-var l))))
                cneg)
         (append (remove* (list (literal true x))  cpos)
                 (remove* (list (literal false x)) cneg))))
  (define (run-proof pf)
    (cond
     [(axiom? pf) (run-axiom (axiom-clause pf))]
     [(res? pf)   (run-res (res-var pf)
                           (run-proof (res-proof-pos pf))
                           (run-proof (res-proof-neg pf)))]
     [else        false]))
  (null? (run-proof pf)))


;; reprezentacja wewnętrzna

;; sprawdza posortowanie w porządku ściśle rosnącym, bez duplikatów
(define (sorted? vs)
  (or (null? vs)
      (null? (cdr vs))
      (and (var<? (car vs) (cadr vs))
           (sorted? (cdr vs)))))

(define (sorted-varlist? x)
  (and (list? x)
       (andmap (var? x))
       (sorted? x)))

;; klauzulę reprezentujemy jako parę list — osobno wystąpienia pozytywne i negatywne. Dodatkowo
;; pamiętamy wyprowadzenie tej klauzuli (dowód) i jej rozmiar.
(define (res-clause? x)
  (and (tagged-tuple? 'res-int 5 x)
       (sorted-varlist? (second x))
       (sorted-varlist? (third x))
       (= (fourth x) (+ (length (second x)) (length (third x))))
       (proof? (fifth x))))

(define (res-clause pos neg proof)
  (list 'res-int pos neg (+ (length pos) (length neg)) proof))

(define (res-clause-pos c)
  (second c))

(define (res-clause-neg c)
  (third c))

(define (res-clause-size c)
  (fourth c))

(define (res-clause-proof c)
  (fifth c))

;; przedstawia klauzulę jako parę list zmiennych występujących odpowiednio pozytywnie i negatywnie
(define (print-res-clause c)
  (list (res-clause-pos c) (res-clause-neg c)))

;; sprawdzanie klauzuli sprzecznej
(define (clause-false? c)
  (and (null? (res-clause-pos c))
       (null? (res-clause-neg c))))

;; pomocnicze procedury: scalanie i usuwanie duplikatów z list posortowanych
(define (merge-vars xs ys)
  (cond [(null? xs) ys]
        [(null? ys) xs]
        [(var<? (car xs) (car ys))
         (cons (car xs) (merge-vars (cdr xs) ys))]
        [(var<? (car ys) (car xs))
         (cons (car ys) (merge-vars xs (cdr ys)))]
        [else (cons (car xs) (merge-vars (cdr xs) (cdr ys)))]))

(define (remove-duplicates-vars xs)
  (cond [(null? xs) xs]
        [(null? (cdr xs)) xs]
        [(var=? (car xs) (cadr xs)) (remove-duplicates-vars (cdr xs))]
        [else (cons (car xs) (remove-duplicates-vars (cdr xs)))]))

(define (rev-append xs ys)
  (if (null? xs) ys
      (rev-append (cdr xs) (cons (car xs) ys))))

;; ĆWICZENIE 1
;; TODO: miejsce na uzupełnienie własnych funkcji pomocniczych

(define (intersection l1 l2)
  (define (foo l1 l2 acc)
    (cond [(or (null? l1)
               (null? l2)) acc]
          [(var<? (car l1) (car l2))
           (foo (cdr l1) l2 acc)]
          [(var<? (car l2) (car l1))
           (foo l1 (cdr l2) acc)]
          [(eq? (car l1) (car l2))
           (foo (cdr l1) (cdr l2) (append acc (list (car l1))))]))
  (foo l1 l2 null))

(define (clause-trivial? c)
  (let ((pos (res-clause-pos c))
        (neg (res-clause-neg c)))
    (define (foo pos neg)
      (cond [(or (null? pos) (null? neg)) #f]
            [(var<? (car pos) (car neg)) (foo (cdr pos) neg)]
            [(var<? (car neg) (car pos)) (foo pos (cdr neg))]
            [else     (eq? (car pos) (car neg))]))
    (foo pos neg)))
  


(define (resolve c1 c2)
  (let* ((pos1 (res-clause-pos c1))
         (neg1 (res-clause-neg c1))
         (pos2 (res-clause-pos c2))
         (neg2 (res-clause-neg c2))
         (res-vars (intersection pos1 neg2))
         (res-vars2 (intersection neg1 pos2)))
    (cond [(and (null? res-vars) (null? res-vars2)) #f]
          [(null? res-vars) (res-clause (merge-vars (remove (car res-vars2) pos2) pos1)
                                             (remove-duplicates-vars(merge-vars (remove (car res-vars2) neg1) neg2))
                                             (proof-res (car res-vars2) (res-clause-proof c2) (res-clause-proof c1)))]
          [(null? res-vars2) (res-clause (merge-vars (remove (car res-vars) pos1) pos2)
                                            (remove-duplicates-vars(merge-vars (remove (car res-vars) neg2) neg1))
                                            (proof-res (car res-vars) (res-clause-proof c1) (res-clause-proof c2)))])))

(define (resolve-single-prove s-clause checked pending)
  ;; TODO: zaimplementuj!
  ;; Poniższa implementacja działa w ten sam sposób co dla większych klauzul — łatwo ją poprawić!
  (let* ((resolvents   (filter-map (lambda (c) (resolve c s-clause))
                                     checked))
         (sorted-rs    (sort resolvents < #:key res-clause-size)))
    (subsume-add-prove (cons s-clause checked) pending sorted-rs)))

;; wstawianie klauzuli w posortowaną względem rozmiaru listę klauzul
(define (insert nc ncs)
  (cond
   [(null? ncs)                     (list nc)]
   [(< (res-clause-size nc)
       (res-clause-size (car ncs))) (cons nc ncs)]
   [else                            (cons (car ncs) (insert nc (cdr ncs)))]))

;; sortowanie klauzul względem rozmiaru (funkcja biblioteczna sort)
(define (sort-clauses cs)
  (sort cs < #:key res-clause-size))

;; główna procedura szukająca dowodu sprzeczności
;; zakładamy że w checked i pending nigdy nie ma klauzuli sprzecznej
(define (resolve-prove checked pending)
  (cond
   ;; jeśli lista pending jest pusta, to checked jest zamknięta na rezolucję czyli spełnialna
   [(null? pending) (generate-valuation (sort-clauses checked))]
   ;; jeśli klauzula ma jeden literał, to możemy traktować łatwo i efektywnie ją przetworzyć
   [(= 1 (res-clause-size (car pending)))
    (resolve-single-prove (car pending) checked (cdr pending))]
   ;; w przeciwnym wypadku wykonujemy rezolucję z wszystkimi klauzulami już sprawdzonymi, a
   ;; następnie dodajemy otrzymane klauzule do zbioru i kontynuujemy obliczenia
   [else
    (let* ((next-clause  (car pending))
           (rest-pending (cdr pending))
           (resolvents   (filter-map (lambda (c) (resolve c next-clause))
                                     checked))
           (sorted-rs    (sort-clauses resolvents)))
      (subsume-add-prove (cons next-clause checked) rest-pending sorted-rs))]))

;; procedura upraszczająca stan obliczeń biorąc pod uwagę świeżo wygenerowane klauzule i
;; kontynuująca obliczenia. Do uzupełnienia.
(define (subsume-add-prove checked pending new)
  (cond
   [(null? new)                 (resolve-prove checked pending)]
   ;; jeśli klauzula do przetworzenia jest sprzeczna to jej wyprowadzenie jest dowodem sprzeczności
   ;; początkowej formuły
   [(clause-false? (car new))   (list 'unsat (res-clause-proof (car new)))]
   ;; jeśli klauzula jest trywialna to nie ma potrzeby jej przetwarzać
   [(clause-trivial? (car new)) (subsume-add-prove checked pending (cdr new))]
   [else
    ;; TODO: zaimplementuj!
    ;; Poniższa implementacja nie sprawdza czy nowa klauzula nie jest lepsza (bądź gorsza) od już
    ;; rozpatrzonych; popraw to!
    (subsume-add-prove checked (insert (car new) pending) (cdr new))
    ]))

;;ĆWICZENIE 2

(define (generate-valuation resolved)
  
  (define (give-bool c)
    (if (null? (res-clause-pos c))
        (list (car (res-clause-neg c)) #f)
        (list (car (res-clause-pos c)) #t)))
 
  (define (give-bool2 var bool)
    (cons var bool))
 
  (define (removal clauses acc)
    (cond [(null? clauses) acc]
          [(or (null? (car clauses))
               (and
                (null? (res-clause-pos (car clauses)))
                (null? (res-clause-neg (car clauses)))))
           (removal (cdr clauses) acc)]
          (else
           (removal (cdr clauses) (cons (car clauses) acc)))))
 
 
  (define (easier-clauses literal clauses) ;;procedura upraszczająca klazule
    (define (iter  literal clauses acc)
      (cond [(null? clauses) acc]
            [(if (literal-pol literal)
                 (if (member (literal-var literal)  (res-clause-pos (car clauses)))
                     (iter literal (cdr clauses) acc)
                     (if (member (literal-var literal)  (res-clause-neg (car clauses)))
                         (if (not (null? (append (remove (literal-var literal) (res-clause-neg (car clauses))) acc)))
                             (iter literal (cdr clauses) (append (remove (literal-var literal) (res-clause-neg (car clauses))) acc))
                             (iter literal (cdr clauses) acc))
                         (iter literal (cdr clauses) (append acc (car clauses)))))
                 
                 (if (member (literal-var literal)  (res-clause-neg (car clauses)))
                     (iter literal (cdr clauses) acc)
                     (if (member (literal-var literal)  (res-clause-pos (car clauses)))
                         (if (not (null? (append (remove (literal-var literal) (res-clause-pos (car clauses))) acc)))
                             (iter literal (cdr clauses) (append (remove (literal-var literal) (res-clause-pos (car clauses))) acc))
                             (iter literal (cdr clauses) acc))
                         (iter literal (cdr clauses) (append acc (car clauses))))))]))
    (iter literal clauses null))
 
  (define (nowa resolved acc) ;;główna procedura
    (if (or (null? resolved)
            (null? (car resolved)))
        acc
        (let* ((klauzula (car resolved)))
          (if (not (null? (res-clause-pos klauzula)))
              (let* ((zmienna (car (res-clause-pos klauzula)))
                     (literal (literal #t zmienna))
                     (upros (list (easier-clauses literal  resolved))))
                (removal (nowa upros (cons (give-bool klauzula ) acc)) null))
              (let* ((zmienna (car (res-clause-neg klauzula)))
                     (literal (literal #f zmienna))
                     (upros (list (easier-clauses literal  resolved))))
                (removal(nowa upros (cons (give-bool klauzula ) acc)) null))))))
  (list 'sat (nowa resolved '())))

;; procedura przetwarzające wejściowy CNF na wewnętrzną reprezentację klauzul
(define (form->clauses f)
  (define (conv-clause c)
    (define (aux ls pos neg)
      (cond
       [(null? ls)
        (res-clause (remove-duplicates-vars (sort pos var<?))
                    (remove-duplicates-vars (sort neg var<?))
                    (proof-axiom c))]
       [(literal-pol (car ls))
        (aux (cdr ls)
             (cons (literal-var (car ls)) pos)
             neg)]
       [else
        (aux (cdr ls)
             pos
             (cons (literal-var (car ls)) neg))]))
    (aux (clause-lits c) null null))
  (map conv-clause (cnf-clauses f)))

(define (prove form)
  (let* ((clauses (form->clauses form)))
    (subsume-add-prove '() '() clauses)))

;; procedura testująca: próbuje dowieść sprzeczność formuły i sprawdza czy wygenerowany
;; dowód/waluacja są poprawne. Uwaga: żeby działała dla formuł spełnialnych trzeneba umieć wygenerować
;; poprawną waluację.
(define (prove-and-check form)
  (let* ((res (prove form))
         (sat (car res))
         (pf-val (cadr res)))
    (if (eq? sat 'sat)
        (valuate-partial pf-val form)
        (check-proof pf-val form))))

;;; TODO: poniżej wpisz swoje testy

;;Testy do ćwiczenia 1 i 2:


;;TEST 1
(define c1 (clause (literal #t 'p) (literal #t 'r))) 
(define c2 (clause (literal #f 'r) (literal #f 's)))
(define c3 (clause (literal #t 'q) (literal #t 's)))
(define c4 (clause (literal #t 'q) (literal #t 'r)))
(define c5 (clause (literal #f 'p) (literal #f 'q)))
(define c6 (clause (literal #t 's) (literal #t 'p)))

(define test (cnf c1 c2 c3 c4 c5 c6))
(define test2 (form->clauses test))
(prove test)
(prove-and-check test)
(generate-valuation (form->clauses (cnf c1 c2))) ;;klauzula: (p v r) i (-r v -s)
(generate-valuation (form->clauses (cnf c1 c3))) ;;klauzula: (p v r) i (q v s)
(generate-valuation (form->clauses (cnf c4 c2))) ;;klauzula: (q v r) i (-r v -s)
(generate-valuation (form->clauses (cnf c5 c2))) ;;klauzula: (-p v -q) i (-r v -s)



;;TEST 2
(define a (clause (literal #t 'a) (literal #f 'c) (literal #t 'd)))
(define b (clause  (literal #t 'b) (literal #f 'd)))

(define ok (form->clauses (cnf a b)))
(define c7 (car ok))
(define c8 (car(cdr ok)))
(resolve c7 c8)
(generate-valuation ok)

;;Współpracownicy: Paulina Landkocz, Julia Nowogródzka, Małgorzata Taterka, Katarzyna Polak, Jakub Maras.


