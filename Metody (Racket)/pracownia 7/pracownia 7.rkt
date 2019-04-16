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

;; environments (could be useful for something)

(define empty-env
  null)

(define (add-to-env x v env)
  (cons (list x v) env))

(define (find-in-env x env)
  (cond [(null? env) (error "undefined variable" x)]
        [(eq? x (caar env)) (cadar env)]
        [else (find-in-env x (cdr env))]))

;; the let-lift procedure


#|

(define (let-lift1 e)
  (define (foo e acc)
    (cond [(or (var? e)
            (const? e)) '()]
          [(op? e) (map (lambda (y) (foo y acc)) (op-args e))]
          [(let? e)
            (foo (let-expr e) (append acc (foo (let-def e) acc)))]
          [(let-def? e) (foo let-def-expr e)]))
  (foo e null))
|#




 
(define (defs-and-arith def-list arith)
  (cons def-list arith))
 
(define (get-defs daa)
  (car daa))
 
(define (get-arith daa)
  (if (null? daa)
      null
      (cdr daa)))
 
(define (print daa)
  (displayln "defs:")
  (displayln (get-defs daa))
  (displayln "arith:")
  (displayln (get-arith daa))
  (displayln ""))
 
(define (let-lift e)
  (helper e))
 
(define (helper e)
  (cond
    [(let? e)
     (defs-and-arith
       (append (get-defs (helper (let-expr e)))
                             (append (get-defs (helper (let-def e)))
                                     (list (let-def e))))
       (let-expr e))]
    [(let-def? e)
     (helper (let-def-expr e))]
    [(op? e)
     (define e1 (helper (second e)))
     (define e2 (helper (third e)))
     (defs-and-arith (append (get-defs e1) (get-defs e2)) (list e (get-arith e1) (get-arith e2)))]
    [(const? e) (defs-and-arith null e)]
    [(var? e) (defs-and-arith null e)]
    [else null]))
 
(print (let-lift '(let (x 7) (+ 10 (* (+ x 2) 2)))))
(print (let-lift '(let (x 7) (let (y 5) (+ x y)))))
(print (let-lift '(let (x (let (y 3) y)) 1)))
;(print (let-lift '(let (y 3) y)))
(print (let-lift '(let (x (- 2 (let (z 3) z))) (+ x 2))))
  