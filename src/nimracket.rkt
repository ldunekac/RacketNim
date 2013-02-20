#lang racket
;; (nim '((x x x x)(x)) '(human human))

(define (nim board players)
  (makeMove (makeNumberBoard board) players (list 1 2)))


(define (makeNumberBoard board)
  (define (rowCount row acc)
    (cond [(empty? row) acc]
           [else (rowCount (cdr row) (+ acc 1))]))
 (cond [(empty? board) '()]
       [else (cons (rowCount (car board) 0) (makeNumberBoard (cdr board)))]))

(define (makeMove board players 1or2)
  (if (end? board)
      (won (cadr 1or2)) 
      (begin (printBoard board 1or2)
       (cond [(eq? 'human  (car players)) (humanMove board players 1or2)]
             [(eq? 'random (car players)) (randomMove board players 1or2)]
             [else (smartMove board players 1or2)]))))

;; TO DO!!!!!
(define (humanMove board players 1or2)
  (define (take row)
    (display "How many do you want to take? ")
     (evalHumanMove board players 1or2 row (read)))
  (define (getRow)
    (display "Please choose a row: ")
     (take (read)))
  (getRow))

(define (evalHumanMove board players 1or2 row many)
  (if (validMove? board row many) 
      (begin (display "---------------------")
              (newline)
              (makeMove (updateBoard board row many) (reverse players) (reverse 1or2)))
      (begin (display "INVALID MOVE - TRY AGAIN")
             (newline)
             (display "---------------------")
              (newline)
             (makeMove board players 1or2))))
  
;; TO DO !!!!
(define (randomMove board players 1or2)
  (display "RANDOM"))

;; TODO !!!!
(define (smartMove board players 1or2)
  (display "SMART"))

;; Update
(define (updateBoard board row many)
  (cond [(= row 1) (cons (- (car board) many) (cdr board))]
        [else (cons (car board)(updateBoard (cdr board) (- row 1) many))]))

;; Conditions statments
(define (validMove? board row many)
  (cond [(empty? board) #f]
        [(< row 1) #f]
        [(<= many 0) #f]
        [(eq? row 1) (<= many (car board))]
        [else (validMove? (cdr board) (- row 1) many)]))

(define (end? board)
  (cond [(empty? board) #t]
        [(zero? (car board)) (end? (cdr board))]
        [else #f]))

;; Printing statments
(define (printBoard board 1or2)
  (define (printRow num)
    (cond [(= num 0) (newline)]
          [else (begin (display "X ") (printRow (- num 1)))]))
  (define (printPrefix board rowNum)
    (cond [(empty? board) 
           (display "Player ")
           (display (car 1or2))
           (display "'s turn")
           (newline)
           (display "---------------------")
           (newline)]
          [else (begin (display "Row ")
                (display rowNum)
                (display ": ") 
                (printRow (car board))
                (printPrefix (cdr board)(+ 1 rowNum)))]))
  (printPrefix board 1))

(define (won player)
  (begin
  (display "player ") (display player)(display " won!")))