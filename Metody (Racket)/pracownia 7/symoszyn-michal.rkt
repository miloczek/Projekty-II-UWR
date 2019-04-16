#lang racket


;; expressions

(define (const? t)
  (number? t))

(define (op? t)
  (and (list? t)
       (member (car t) '(+ - * /))))

(define (op-op e)
  (car e))

(define (op-args e)
  (cdr e))

(define (op-cons op args)
  (cons op args))

(define (op->proc op)
  (cond [(eq? op '+) +]
        [(eq? op '*) *]
        [(eq? op '-) -]
        [(eq? op '/) /]))

(define (let-def? t)
  (and (list? t)
       (= (length t) 2)
       (symbol? (car t))))

(define (let-def-var e)
  (car e))

(define (let-def-expr e)
  (cadr e))

(define (let-def-cons x e)
  (list x e))

(define (let? t)
  (and (list? t)
       (= (length t) 3)
       (eq? (car t) 'let)
       (let-def? (cadr t))))

(define (let-def e)
  (cadr e))

(define (let-expr e)
  (caddr e))

(define (let-cons def e)
  (list 'let def e))

(define (var? t)
  (symbol? t))

(define (var-var e)
  e)

(define (var-cons x)
  x)

(define (arith/let-expr? t)
  (or (const? t)
      (and (op? t)
           (andmap arith/let-expr? (op-args t)))
      (and (let? t)
           (arith/let-expr? (let-expr t))
           (arith/let-expr? (let-def-expr (let-def t))))
      (var? t)))

;; let-lifted expressions

(define (arith-expr? t)
  (or (const? t)
      (and (op? t)
           (andmap arith-expr? (op-args t)))
      (var? t)))

(define (let-lifted-expr? t)
  (or (and (let? t)
           (let-lifted-expr? (let-expr t))
           (arith-expr? (let-def-expr (let-def t))))
      (arith-expr? t)))

;; generating a symbol using a counter

(define (number->symbol i)
  (string->symbol (string-append "x" (number->string i))))



(define (rename-with-counter e var i)  
  (define (rename-with-counter-iter e) ;;iterator biegnący po wyrażeniu i sprawdzający czy trzeba zmienić 
    (if (or (const? e) (symbol? e))    ;;symbol zmiennej
      (cond [(eq? var e) (number->symbol i)]
            [else e])
      (map rename-with-counter-iter e)))
   (rename-with-counter-iter e))

;; environments (could be useful for something)

(define (let-inside? t)
  (not (arith-expr? t)))

(define empty-env
  null)

(define (add-to-env x v env)
  (cons (list x v) env))

(define (find-in-env x env)
  (cond [(null? env) -(error "undefined variable" x)]
        [(eq? x (caar env)) (cadar env)]
        [else (find-in-env x (cdr env))]))

;; procedury pomocnicze

(define (inc e)
  (+ 1 e))

(define (bot-let e counter)
  (cond
    [(op? e) (car (filter let-inside? (op-args e)))]
    [(let? e)
     (cond
       [(let-inside? (let-expr e)) (bot-let (let-expr e) counter)] ;;jeśli napotkamy jakiegoś leta w let-wyrażeniu
       [(let-inside? (let-def-expr (let-def e))) (bot-let (let-def-expr (let-def e)) counter)] ;;jeśli napotkamy jakiegoś leta w let-definicji
       [else e])]
    [(or (const? e) (var? e)) '()]))

(define (replace-bot-let e counter) ;;podmieniamy znalezionego najgłębszego leta, jego let-wyrażenie
  (define (apply-to predic proc lst)
    (if (predic (car lst))
        (append (list (proc (car lst) counter)) (cdr lst))
        (append (list (car lst)) (apply-to predic proc (cdr lst))))) 
  (cond
    [(op? e) (op-cons (op-op e) (apply-to let-inside? replace-bot-let (op-args e)))]
    [(let? e)
     (cond
       [(let-inside? (let-expr e)) (let-cons (let-def e) (replace-bot-let (let-expr e) counter))]
       [(let-inside? (let-def-expr (let-def e)))
        (let-cons (let-def-cons (let-def-var (let-def e)) (replace-bot-let (let-def-expr (let-def e)) counter)) (let-expr e))]
       [else (rename-with-counter (let-expr e) (let-def-var (let-def e)) counter)])]
    [(or (const? e) (var? e)) e]))

;; the let-lift procedure

(define (let-lift e)
  (define (let-lift-iter e counter)
     (cond  [(let-lifted-expr? e) e]
            [else (let-lift-iter (let-cons (let-def-cons (number->symbol counter) (let-def-expr (let-def (bot-let e counter)))) (replace-bot-let e counter)) (inc counter))]))
  (let-lift-iter e 0))


;; Testy


;; Proste testy:

(let-lift '(+ 10 (let (x 6) (+ 5 x)))) ;;'(let (x0 6) (+ 10 (+ 5 x0)))

(let-lift '(let (x (- 2 (let (z 3) z))) (+ x 2))) ;;'(let (x0 3) (let (x (- 2 x0)) (+ x 2)))

(let-lift '(- (let (y 4) (+ 12 x)) (let (x 5) (* 42 x)))) ;;'(let (x1 5) (let (x0 4) (- (+ 12 x) (* 42 x1))))

;; Bardziej złożone przykłady:

(let-lift '(* (let (x 9) (+ 9 8 x)) 120 42 (let (y 30) (/ 5 6))));;'(let (x1 30) (let (x0 9) (* (+ 9 8 x0) 120 42 (/ 5 6))))

(let-lift '(let (x (+ 5 6 (let (y 20) (+ 15 y)))) (* x 17))) ;;'(let (x0 20) (let (x (+ 5 6 (+ 15 x0))) (* x 17)))

(let-lift '(/ 453 (let (x 12) (- 32 x)) 12 45 566 (let (x 15) (* 14 (+ x 2))))) ;;'(let (x1 15)(let (x0 12) (/ 453 (- 32 x0) 12 45 566 (* 14 (+ x1 2)))))


;;Zadanie zrobione we współpracy z Adamem Sibikiem


