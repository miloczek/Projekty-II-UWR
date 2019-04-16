#lang racket

;; arithmetic expressions

;;predykat definiujący czy coś jest stałą

(define (const? t)
  (number? t))

;;predykat do operacji binarnej
;;( 'op arg1 arg2)- taką postać ma binop

(define (binop? t)
  (and (list? t)
       (= (length t) 3)
       (member (car t) '(+ - * /))))

;;abstrakcyjne selektory, które wydobywają składowe procedury

  ;;wydobycie operatora : + - * /
(define (binop-op e)
  (car e))

  ;;wydobycie argumentu1
(define (binop-left e)
  (cadr e))

  ;;wydobycie argumentu2
(define (binop-right e)
  (caddr e))

;;konstruktor operacji binarnej
(define (binop-cons op l r)
  (list op l r))

;;predykat, sprawdzający czy coś jest wyr arytmetycznym

(define (arith-expr? t)
  (or (const? t) ;;albo coś jest stałą,
      (and (binop? t) ;; albo jest operacją binarną.
           (arith-expr? (binop-left  t))
           (arith-expr? (binop-right t)))))

;; calculator

;;zamienia symbole procedury na faktyczną procedurę

(define (op->proc op)
  (cond [(eq? op '+) +]
        [(eq? op '*) *]
        [(eq? op '-) -]
        [(eq? op '/) /]))

;;wylicza wartość wyrażenia arytmetycznego

(define (eval-arith e)
  (cond [(const? e) e] ;;gdy wyr to stała zwróć stałą
        [(binop? e) ;;gdy binop to zastusuj operator do argumentów
         ((op->proc (binop-op e)) ;;wpierw wylicz te argumenty
            (eval-arith (binop-left  e))
            (eval-arith (binop-right e)))]))

;; let expressions
;;reprezentacja let w naszym interpreterze

;;podstawienie zdefiniowane jako lista 2 elementowa
;;postać : '( 'symbol wartość)
(define (let-def? t)
  (and (list? t)
       (= (length t) 2)
       (symbol? (car t))))

;;selektor, który pozwala uzyskać symbol z podstawienia
(define (let-def-var e) 
  (car e))

;;selektor, który pozwala uzyskać wartośc z podstawienia
(define (let-def-expr e)
  (cadr e))

;;konstruktor, który pozwala utworzyć podstawienie
(define (let-def-cons x e)
  (list x e))

;;predykat, który sprawdza czy coś jest wyrażeniem let:
;;postać: ('let ('symbol wartość) czynność)
(define (let? t)
  (and (list? t)
       (= (length t) 3)
       (eq? (car t) 'let)
       (let-def? (cadr t))))

;;pozwala wydobyć podstawienie z leta
(define (let-def e)
  (cadr e))

;;pozwala wydobyć czynnośc do wykonania w let
(define (let-expr e)
  (caddr e))

;;konstruktor, tworzy faktyczne wyrażenie let:
;;postać: ('let (podstawienie) czynność)
(define (let-cons def e)
  (list 'let def e))

;;predykat do sprawdzenia czy coś jest zmienną
(define (var? t)
  (symbol? t))

;;selektor do wydobycia zmiennej
(define (var-var e)
  e)
;;konstruktor zmiennych
(define (var-cons x)
  x)


;;predykat, który sprawdza czy coś jest wyr arytmetycznym albo let wyrażeniem

(define (arith/let-expr? t)
  (or (const? t) ;;wyrażenie to albo stała
      (and (binop? t) ;;albo operacja binarna
           (arith/let-expr? (binop-left  t)) ;;wtedy sprawdzam operandy
           (arith/let-expr? (binop-right t)))
      (and (let? t) ;;let wyrażenie 
           (arith/let-expr? (let-expr t)) ;;sprawdzam czy czynnośc to wyr arytmetyczne albo let wyr
           (arith/let-expr? (let-def (let-def-expr t)))) ;;to samo z podstawianą wartością w podstawieniu
      (var? t))) ;;wyrażenie to może tez być zmienna

;; evalation via substitution
;;faktyczna część z interpreterem:
;;MODEL PODSTAWIANIA:
;;e = wyrażenie do sprawdzenia na podstawienia
;;x = symbol, za który będę podstawiać
;;f = konkretna wartość x

(define (subst e x f)
  (cond [(const? e) e] ;;jak coś jest stałą nie wymaga podstawiania
        [(binop? e) ;; jak operacja binarna: sprawdź argumenty
         (binop-cons
           (binop-op e)
           (subst (binop-left  e) x f)
           (subst (binop-right e) x f))]
        [(let? e) ;; gdy cos jest let-wyr
         (let-cons
           (let-def-cons
             (let-def-var (let-def e))
             (subst (let-def-expr (let-def e)) x f)) ;;podstawiam wartości w podstawienia
           (if (eq? x (let-def-var (let-def e))) ;;gdy jest ta sama wartośc nie podstawiam
               (let-expr e)
               (subst (let-expr e) x f)))] ;;podstawiam w czynności do wykonania bo w podstawieniu nic się nie zmienia
        [(var? e) ;;gdy coś jest zmienną 
         (if (eq? x (var-var e))
             f ;;zwracam faktyczną wartośc dla zmiennej 
             (var-var e))]))

;;pozwala obliczyć wartość wyrażenia z podstawieniem
(define (eval-subst e)
  (cond [(const? e) e]
        [(binop? e)
         ((op->proc (binop-op e))
            (eval-subst (binop-left  e))
            (eval-subst (binop-right e)))]
        [(let? e)
         (eval-subst
           (subst
             (let-expr e)
             (let-def-var (let-def e))
             (eval-subst (let-def-expr (let-def e)))))]
        [(var? e) ;;jestem już po podstawieniu więc tak nie można
         (error "undefined variable" (var-var e))]))

;; evaluation via environments
;;METODA ŚRODOWISKOWA


;;zdefiniowane puste środowisko
(define empty-env
  null)

;;operacja dodawania elementów do środowiska
;;postać: ('symbol wartość)
(define (add-to-env x v env)
  (cons (list x v) env))

;;przeszukiwanie środowiska, aby odnaleźć jakąś zmienną 
(define (find-in-env x env)
  (cond [(null? env) (error "undefined variable" x)]
        [(eq? x (caar env)) (cadar env)]
        [else (find-in-env x (cdr env))]))

;;obliczanie wartości na podstawie środowiska
#|
(define (eval-env e env)
  (cond [(const? e) e]
        [(binop? e)
         ((op->proc (binop-op e))
            (eval-env (binop-left  e) env)
            (eval-env (binop-right e) env))]
        [(let? e)
         (eval-env
           (let-expr e)
           (env-for-let (let-def e) env))]
        [(var? e) (find-in-env (var-var e) env)]))
|#


;;dodawanie do środowiska zmiennych wiązanych przez let
(define (env-for-let def env)
  (add-to-env
    (let-def-var def)
    (eval-env (let-def-expr def) env)
    env))

;;właściwa funkcja, która wywołuje resztę
(define (eval e)
  (eval-env e empty-env))

;; Zadanie 5

(define (if-zero? expr)
  (and (list? expr)
       (= (length expr) 4)
       (eq? (first expr) 'if-zero)
       (arith/let-expr? (second expr))
       (arith/let-expr? (third expr))
       (arith/let-expr? (fourth expr))))


 
(define (eval-env e env)
  (cond [(const? e) e]
        [(op? e)
         (apply ((op->proc (op-op e)) (map
                                       (lambda (x) (eval-env x env)
                                         (op-args e)))))]
        [(let? e)
         (eval (let-expr e)
               (add-env-l (let-def e) env))]
        [(var? e) (find-in-env (var-var e) env)]
        [(if-zero? e)
         (if (= (eval-subst (second e)) 0)
             (eval-subst (third e))
             (eval-subst (fourth e)))]))

;; Zadanie 6

(define (op? f)
  (and (list? f)
       (>= (length f) 1)
       (member (car f) '(+ - / *))))

(define (op-args f)
  (cdr f))

(define (op-op f)
  (car f))

(define (make-op operator l)
  (cons operator l))

(define (ecal-arith e)
  (cond [(const? e) e]
        [(op? e)
         (apply (op->proc (op-op e))
                (map eval-arith (op-args e)))]))

;; Zadanie 7


(define (add-env-l l env)
  (if (null?)
      env
      (add-env-l (cdr l) (add-env (car l) env))))

(define (let-def? e)
  (and
   (list? e)
   (check e)))

(define (check l)
  (cond [(null? l) #t]
        [(let-def? l) (check (cdr l))]
        [else #f]))

;; Zadanie 8

(define (let->let-db e)
  (define (convert exp l)
    (cond
      [(let? exp)
       (list 'let (let-def-expr (let-def e)) (convert






