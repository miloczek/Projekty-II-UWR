#lang racket

(require "calc.rkt")

(define (def-name p)
  (car p))

(define (def-prods p)
  (cdr p))

(define (rule-name r)
  (car r))

(define (rule-body r)
  (cdr r))

(define (lookup-def g nt)
  (cond [(null? g) (error "unknown non-terminal" g)]
        [(eq? (def-name (car g)) nt) (def-prods (car g))]
        [else (lookup-def (cdr g) nt)]))

(define parse-error 'PARSEERROR)

(define (parse-error? r) (eq? r 'PARSEERROR))

(define (res v r)
  (cons v r))

(define (res-val r)
  (car r))

(define (res-input r)
  (cdr r))

;;

(define (token? e)
  (and (list? e)
       (> (length e) 0)
       (eq? (car e) 'token)))

(define (token-args e)
  (cdr e))

(define (nt? e)
  (symbol? e))

;;

(define (parse g e i)
  (cond [(token? e) (match-token (token-args e) i)]
        [(nt? e) (parse-nt g (lookup-def g e) i)]))

(define (parse-nt g ps i)
  (if (null? ps)
      parse-error
      (let ([r (parse-many g (rule-body (car ps)) i)])
        (if (parse-error? r)
            (parse-nt g (cdr ps) i)
            (res (cons (rule-name (car ps)) (res-val r))
                 (res-input r))))))

(define (parse-many g es i)
  (if (null? es)
      (res null i)
      (let ([r (parse g (car es) i)])
        (if (parse-error? r)
            parse-error
            (let ([rs (parse-many g (cdr es) (res-input r))])
              (if (parse-error? rs)
                  parse-error
                  (res (cons (res-val r) (res-val rs))
                       (res-input rs))))))))

(define (match-token xs i)
  (if (and (not (null? i))
           (member (car i) xs))
      (res (car i) (cdr i))
      parse-error))

;;

(define num-grammar
  '([digit {DIG (token #\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9)}]
    [numb {MANY digit numb}
          {SINGLE digit}]))

(define (node-name t)
  (car t))

(define (c->int c)
  (- (char->integer c) (char->integer #\0)))

(define (walk-tree-acc t acc)
  (cond [(eq? (node-name t) 'MANY)
         (walk-tree-acc
          (third t)
          (+ (* 10 acc) (c->int (second (second t)))))]
        [(eq? (node-name t) 'SINGLE)
         (+ (* 10 acc) (c->int (second (second t))))]))

(define (walk-tree t)
  (walk-tree-acc t 0))

;;


(define arith-grammar
  (append num-grammar
    '( [add-expr {ADD-MANY   mult-expr (token #\+) add-expr}
                 {SUB-MANY   mult-expr (token #\-) add-expr}  ;;dodajemy do gramatyki operację odejmowania
                 {ADD-SINGLE mult-expr}]
       [mult-expr {MULT-MANY base-expr (token #\*) mult-expr} 
                  {DIV-MANY base-expr (token #\/) mult-expr}  ;;dodajemy do gramatyki operację dzielenia
                  {MULT-SINGLE base-expr}]
       [base-expr {BASE-NUM numb}
                  {PARENS (token #\() add-expr (token #\))}])))
 
 
(define (single? t)
  (or (eq? (node-name t) 'ADD-SINGLE) (eq? (node-name t) 'MULT-SINGLE)))
 
(define (arith-walk-tree t)  ;;do arith-walk-tree dodajemy przypadki odejmowania i dzieleenia 
  (cond [(eq? (node-name t) 'ADD-SINGLE)
         (arith-walk-tree (second t))]
        [(eq? (node-name t) 'MULT-SINGLE)
         (arith-walk-tree (second t))]
        [(eq? (node-name t) 'ADD-MANY)
         (binop-cons
          '+
          (arith-walk-tree (second t))
          (arith-walk-tree (fourth t)))]
        [(eq? (node-name t) 'SUB-MANY)
         (binop-cons
          '-
          (arith-walk-tree (second t))
          (arith-walk-tree (fourth t)))]
        [(eq? (node-name t) 'MULT-MANY)
         (binop-cons
          '*
          (arith-walk-tree (second t))
          (arith-walk-tree (fourth t)))]
        [(eq? (node-name t) 'DIV-MANY)
         (binop-cons
          '/
          (arith-walk-tree (second t))
          (arith-walk-tree (fourth t)))]
        [(eq? (node-name t) 'BASE-NUM)
         (walk-tree (second t))]
        [(eq? (node-name t) 'PARENS)
         (arith-walk-tree (third t))]))
 
 
(define (edit-tree t)   ;;procedura skręcająca drzewo w prawo, ustawia inny priorytet obliczania
  (cond [(single? t) (list (node-name t) (edit-tree (second t)))]
        [(eq? (node-name t) 'BASE-NUM) t]
        [(eq? (node-name t) 'PARENS) (list (node-name t) (second t)
                                           (edit-tree (third t)) (fourth t))]
        [else
         (cond [(single? (fourth t)) (cons (node-name t)
                                           (cons (edit-tree (second t))
                                                 (cons (third t) (list (edit-tree (fourth t))))))]
               [(eq? (node-name (fourth t)) 'BASE-NUM)
                (list (node-name t) (edit-tree (second t))
                      (third t) (fourth t))]
               [(eq? (node-name (fourth t)) 'PARENS)
                (list (node-name t) (edit-tree (second t)) (third t) (list (node-name (fourth t))
                                                                           (second (fourth t))
                                                                           (edit-tree (third (fourth t))) (fourth (fourth t))))]
               [else    (let* ((rght (fourth t))
                               (operator1 (third t))
                               (operator2 (third (fourth t)))
                               (arg1-rght (second (fourth t)))
                               (arg2-rght (fourth (fourth t)))
                               (left (second t))
                               (tag (node-name rght)))
                          (edit-tree (list tag (list (node-name t) (edit-tree left) operator1 (edit-tree arg1-rght))
                                           operator2
                                           (edit-tree arg2-rght))))])]))
 
(define (calc s)
  (eval
   (arith-walk-tree
    (edit-tree
     (car
      (parse
       arith-grammar
       'add-expr
       (string->list s)))))))



(define (scheme s) ;; procedura pomijająca eval i wyświetlająca racketową interpretację wyrażenia
  (arith-walk-tree
   (edit-tree
    (car
     (parse
      arith-grammar
      'add-expr
      (string->list s))))))


;;TESTY

;;Wyrażenia do obliczenia + racketowe nawiasowanie:

(calc "2*2*2*2*2") ;;32
(scheme "2*2*2*2*2") ;;'(* (* (* (* 2 2) 2) 2) 2)


(calc "5-2-1") ;;2
(scheme "5-2-1") ;;'(- (- 5 2) 1)


(calc "(12-7)/5") ;;1
(scheme "(12-7)/5") ;;'(/ (- 12 7) 5)

(calc "(276*(5-4))+(13*2)") ;;302
(scheme "(276*(5-4))+(13*2)") ;;'(+ (* 276 (- 5 4)) (* 13 2))

(calc "14/7*20*13/2*13*42") ;;141960
(scheme "14/7*20*13/2*13*42") ;;'(* (* (/ (* (* (/ 14 7) 20) 13) 2) 13) 42)

(calc "24*15-44+12") ;;328
(scheme "24*15-44+12") ;;'(+ (- (* 24 15) 44) 12)



;;Zadanie opracowywane z Pauliną Landkocz, współpracownicy: Julia Nowogrodzka oraz Katarzyna Polak


