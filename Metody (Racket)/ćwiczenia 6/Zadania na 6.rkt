#lang racket

;; arithmetic expressions
 
(define (const? t)
  (number? t))
 
(define (binop? t)
  (and (list? t)
       (= (length t) 3)
       (member (car t) '(+ - * /))))
 
(define (binop-op e)
  (car e))
 
(define (binop-left e)
  (cadr e))
 
(define (binop-right e)
  (caddr e))
 
(define (binop-cons op l r)
  (list op l r))
 
(define (arith-expr? t)
  (or (const? t)
      (and (binop? t)
           (arith-expr? (binop-left  t))
           (arith-expr? (binop-right t)))))
 
;; Zadanie 1
#|
(define (arith->rpn xs)
  (define (rec xs)
    (cond
      [(null? xs) null]
      [(const? xs) xs]
      [(binop? xs) (list (rec (binop-left xs)) (rec (binop-right xs)) (binop-op xs))]
      [else (error "Invalid expression")]))
  (flatten (rec xs)))|#


;; v2
(define (arith->rpn exp)
  (define (rec e acc)
    (cond
      [(null? e) null]
      [(const? e) (cons e acc)]
      [(binop? e) (rec (binop-left e)
                       (rec (binop-right e)
                            (cons (binop-op e)
                                   acc)))]
      [else (error "Invalid expression")]))
  (rec exp null))

 
;; Zadanie 2
(define (stack? xs)
  (pair? xs))
 
(define (push x stack)
  (cons x stack))
 
(define (pop stack)
  stack)

;; Zadanie 2 vol 2
#|
(define (stack? s)
  (and (list? s)
       (eq? (car s) 'stack)))

(define (pop s)
  (if (not (stack? s))
      (error "Not a stack")
      (cons (cadr s) (cons 'stack (caddr s)))))

(define (push s val)
  (
|#
 
;; Zadanie 3
(define (op? e)
  (or (eq? e '+)
      (eq? e '*)
      (eq? e '-)
      (eq? e '/)))
 
(define (op->proc op)
  (cond [(eq? op '+) +]
        [(eq? op '*) *]
        [(eq? op '-) -]
        [(eq? op '/) /]))
 
(define (eval-rpn exp)
  (define (helper e val-stack)
    (cond
      [(null? e)        (car val-stack)]
      [(const? (car e)) (helper (cdr e) (push (car e) val-stack))]
      [(op? (car e))
       (let ([a (car (pop val-stack))]
             [b (car (pop (cdr (pop val-stack))))]
             [vs (cdr (pop (cdr (pop val-stack))))])
         (helper (cdr e) (push ((op->proc (car e)) a b) vs)))]))
  (helper exp null))
 
;(define exp (arith->rpn '(/ (+ (/ (+ 2 7) 3) (* (- 14 3) 4)) 2)))
;'(2 7 + 3 / 14 3 - 4 * + 2 /)
(eval-rpn '(1 2 3 + + 6 /))


;; Zadanie 5

#|
(define (if-zero? expr)
  (and (list? expr)
       (= (length expr) 4)
       (eq? (first expr) 'if-zero)
       (arith/let-expr? (second expr))
       (arith/let-expr? (third expr))
       (arith/let-expr? (fourth expr))))
 
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
        [(var? e) (find-in-env (var-var e) env)]
        [(if-zero? e)
         (if (= (eval-subst (second e)) 0)
             (eval-subst (third e))
             (eval-subst (fourth e)))]))
|#


