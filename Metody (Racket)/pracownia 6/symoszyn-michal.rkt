#lang racket

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

(define (hole? t)
  (eq? t 'hole))

(define (arith/let/holes? t)
  (or (hole? t)
      (const? t)
      (and (binop? t)
           (arith/let/holes? (binop-left  t))
           (arith/let/holes? (binop-right t)))
      (and (let? t)
           (arith/let/holes? (let-expr t))
           (arith/let/holes? (let-def-expr (let-def t))))
      (var? t)))

(define (num-of-holes t)
  (cond [(hole? t) 1]
        [(const? t) 0]
        [(binop? t)
         (+ (num-of-holes (binop-left  t))
            (num-of-holes (binop-right t)))]
        [(let? t)
         (+ (num-of-holes (let-expr t))
            (num-of-holes (let-def-expr (let-def t))))]
        [(var? t) 0]))

(define (arith/let/hole-expr? t)
  (and (arith/let/holes? t)
       (= (num-of-holes t) 1)))

#|
(define (hole-context e)
      (cond [(hole? e) '()]
            [(const? e) '()]
            [(binop? e)
             (hole-context (binop-left e)) (hole-context (binop-right e))]
            [(let? e)
             (append (list (let-def-var (let-def e))) (hole-context (let-expr e)))]))
|#
   

             
(define (hole-context e)

  (define (clear acc)  ;; procedura zajmująca się reprezentacją akumulatora (pozbywa się powtórzeń i wrzuca zmienne w jedną listę)
    (remove-duplicates (flatten (list acc))))

  (define (foo e acc)  ;; główna procedura,która "zbiera" zmienne do akumulatora i kończy działanie gdy napotka 'hole
    (cond [(hole? e)  (clear acc)]
          [(const? e)  (clear acc)]
          [(binop? e)
           (foo (binop-left e) acc) (foo (binop-right e) acc)]
          [(let? e)
           (if (hole? (let-def-expr (let-def e)))
               (clear acc)
           (foo (let-expr e) (append (list acc) (let-def-var (let-def e)))))]))

  (if (arith/let/hole-expr? e) ;; predykat sprawdzający czy wejściowa procedura jest w prawidłowej formie
      (foo e null)
      (error "Wrong type!")))

;;Testy z polecenia, wszystkie działają prawidłowo:
(hole-context '(+ 3 hole)) ;; '()
(hole-context '(let (x 3) (let (y 7) (+ x hole)))) ;; '(x y)
(hole-context '(let (x 3) (let (y hole) (+ x 3)))) ;; '(x)
(hole-context '(let (x hole) (let (y 7) (+ x 3)))) ;; '()
(hole-context '(let (piesek 1) 
                 (let (kotek 7)
                   (let (piesek 9)
                     (let (chomik 5)
                       hole)))))                ;; '(piesek kotek chomik)
(hole-context '(+ (let (x 4) 5) hole))         ;; '()




;;Procedura testująca:
(define (compare l1 l2) ;; specjalna procedura która porównuje listy bez względu na kolejność
  (define (foo l1 l2)
    (cond [(null? l1) #t]
        [(member (car l1) l2) (foo (cdr l1) l2)]
        [else #f]))
  (if (= (length l1) (length l2))
      (foo l1 l2)
      #f))
  
(define (test)
  (compare (hole-context (binop-cons '- 5 'hole))
          '())
  (compare (hole-context (let-cons (let-def-cons 'q 4) (let-cons (let-def-cons 'p 6) (let-cons (let-def-cons 'r 2) (binop-cons '+ 'hole 4)))))
          '(q p r))
  (compare (hole-context (binop-cons '* (let-cons (let-def-cons 'a 5) (binop-cons '+ 5 'hole)) (let-cons (let-def-cons 'b 42) (let-cons (let-def-cons 'c 4) (binop-cons '- 'c 4)))))
          '(b c))
  (compare (hole-context (let-cons (let-def-cons 'x 'hole) (binop-cons '- 5 6)))
          '()))
                                                                                                                                                                    
                                                                              
(test)

