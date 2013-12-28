#lang racket
;----------------------------------------------------------------------------
; FFI functions for CLIPS
;----------------------------------------------------------------------------

(provide (all-defined-out))

(require ffi/unsafe) 
(require racket/runtime-path)
(require "ffi-utils.rkt")
(require "data-object.rkt")

(define-runtime-path libclips "../lib/libclips63b1")

; Go look at the CLIPS source - all the comments you need are there.

(native-lib libclips  
  _pointer CreateEnvironment  ()
  _int     DestroyEnvironment ( _pointer )
  
  _void    EnvClear ( _pointer )
  _void    EnvReset ( _pointer )
  _int     EnvEval  ( _pointer _string _dataObject-pointer )
  _llong   EnvRun   ( _pointer _llong )
  
  _pointer EnvAssertString ( _pointer _string )
)

(define env (CreateEnvironment))

;;;TEST-->
(define dobj (empty-dataObject))
(EnvEval env "(create$ (sym-cat \"foo \" (+ 2 3 4.5)) a b c (str-cat a 12))" dobj)
