#lang racket/base
 
(require rackunit
         "clips-ffi.rkt")

(define env (CreateEnvironment))
(define dobj (empty-dataObject))

(define (test env ptr-dobj)
  (let ([args (args->vector env)])
    (value->dataObject env 
                       (list (+ 1 (vector-ref args 0))
                             (+ 1.0 (vector-ref args 1)))
                       ptr-dobj)))

(register-extfn env test "test")

(EnvEval env "(create$ (sym-cat \"foo \" (+ 2 22 4.5)) (test 8 9) a b c (str-cat a 12))" dobj)

(check-equal? '#(|foo 28.5| 9 10.0 a b c "a12")
              (dataObject->value dobj)
              "sanity test")

(DestroyEnvironment env)