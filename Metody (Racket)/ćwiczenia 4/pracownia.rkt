#lang racket


(define (concatMap f xs)
  ( lambda ( new-row )
     ( map ( lambda ( rest-of-queens )
              (adjoin-position new-row k rest-of-queens ) )
           ( queen-cols (- k 1) ) ) )
  ( from-to 1 board-size ) )


(define (from-to s e)
  (if (= s e)
      (list s)
      (cons s (from-to (+ s 1) e))))

(define (make-position row col)
  (list row col))

(define (queens board-size)
  ;; Return the representation of a board with 0 queens inserted
  (define (empty-board)
    (define (fill k)
      (if (= k 0)
          null
          (cons 0 (fill (- k 1))
      (fill board-size)))))
  ;; Return the representation of a board with a new queen at
  ;; (row, col) added to the partial representation `rest'
  (define (adjoin-position row col rest)
    (if (= col 1)
        (cons row (cdr rest))
        (cons (car rest)
              (adjoin-position row (- col 1 ) (cdr rest)))))
  ;; Return true if the queen in k-th column does not attack any of
  ;; the others
  (define (safe? k position)
    (define (list-to-check i pos)
      (if (= i k)
          (list (car pos) (+ (car pos) 1) (- (car pos) 1))
          (let ([block (list-to-check (- i 1) (cdr pos))]
                [act (car pos)])
            (if (or (null? blocked)
                    (= (first blocked) act)
                    (= (second blocked) act)
                    (= (third blocked) act))
                null
                ((first blocked) (+ (second blocked) 1 ) (- (third blocked) 1))))))
    (not (null? (list-to-check 1 positions))))
    
 
  
      
  ;; Return a list of all possible solutions for k first columns
  (define (queen-cols k)
    (if (= k 0)
        (list (empty-board))
        (filter
         (lambda (positions) (safe? k positions))
         (concatMap
          (lambda (rest-of-queens)
            (map (lambda (new-row)
                   (adjoin-position new-row k rest-of-queens))
                 (from-to 1 board-size)))
          (queen-cols (- k 1))))))
  (queen-cols board-size))
