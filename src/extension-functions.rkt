#lang racket
;----------------------------------------------------------------------------
; Registration and marshaling for Racket functions as CLIPS extension funcs
;----------------------------------------------------------------------------

(provide (all-defined-out))

(require "clips-functions.rkt")
(require "clips-structs.rkt")
(require "data-object.rkt")
(require ffi/unsafe)

;; Make a vector of the marshaled args
(define (args->vector env)
  (let* ([count (EnvRtnArgCount env)]
         [vec   (make-vector count)]
         [dobj  (empty-dataObject)])
    (let loop ([i 1])
      (EnvRtnUnknown env i dobj)
      (vector-set! vec (- i 1) (dataObject->value dobj))
      (when (< i count) (loop (+ i 1))))
    vec))

;; Register an extension function that returns a value
(define (register-extfn env proc name [signature "**"])
  (EnvDefineFunction2 env name (char->integer #\u)
                      (function-ptr proc (_fun _environ _pointer -> _void))
                      name
                      signature)
  (void))

;; Register a void extension function
(define (register-void-extfn env proc name [signature "**"])
  (EnvDefineFunction2 env name (char->integer #\v)
                      (function-ptr proc (_fun _environ -> _void))
                      name
                      signature)
  (void))