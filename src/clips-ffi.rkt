#lang racket
;----------------------------------------------------------------------------
; FFI functions for CLIPS
;----------------------------------------------------------------------------

(provide (all-defined-out))

(require ffi/unsafe) 
(require ffi/cvector)
(require racket/runtime-path)
(require "ffi-utils.rkt")

(define-runtime-path libclips "../lib/libclips63b1")

; Go look at the CLIPS source - all the comments you need are there.

(define-cstruct _dataObject (
  [supplementalInfo _pointer]
  [type  _ushort]
  [value _pointer]
  [begin _long]
  [end   _long]
  [next  _pointer]
))

(native-lib libclips  
  _pointer CreateEnvironment  ()
  _int     DestroyEnvironment ( _pointer )
  
  _void    EnvClear ( _pointer )
  _void    EnvReset ( _pointer )
  _int     EnvEval  ( _pointer _string _dataObject-pointer )
  _llong   EnvRun   ( _pointer _llong )
  
  _pointer EnvAssertString ( _pointer _string )
)

; dataObject types
(define FLOAT            0)
(define INTEGER          1)
(define SYMBOL           2)
(define STRING           3)
(define MULTIFIELD       4)
(define EXTERNAL_ADDRESS 5)
(define FACT_ADDRESS     6)
(define INSTANCE_ADDRESS 7)
(define INSTANCE_NAME    8)

(define env (CreateEnvironment))

(define (empty-dataObject)
  (make-dataObject #f 0 #f 0 0 #f))

(define-cstruct _floatHashNode (
  [next  _pointer]
  [count _long]
  [depth _int]
  [flags _uint32]
  [contents _double]
))

(define-cstruct _integerHashNode (
  [next  _pointer]
  [count _long]
  [depth _int]
  [flags _uint32]
  [contents _llong]
))

(define-cstruct _symbolHashNode (
  [next  _pointer]
  [count _long]
  [depth _int]
  [flags _uint32]
  [contents _string]
))

(define-cstruct _externalAddressHashNode (
  [next  _pointer]
  [count _long]
  [depth _int]
  [flags _uint32]
  [externalAddress _pointer]
  [type  _ushort]
))

; marshal a dataObject to a scheme value
(define (dataObject->value dobj)
  (case (dataObject-type dobj)
    [(0) (floatHashNode-contents   (ptr-ref (dataObject-value dobj) _floatHashNode))]
    [(1) (integerHashNode-contents (ptr-ref (dataObject-value dobj) _integerHashNode))]
    [(2) (string->symbol (symbolHashNode-contents (ptr-ref (dataObject-value dobj) _symbolHashNode)))]
    [(3 8) (symbolHashNode-contents  (ptr-ref (dataObject-value dobj) _symbolHashNode))]
    [(4) #f ] ;;;;;;;;;;;;TODO
    [(5) (externalAddressHashNode-externalAddress (ptr-ref (dataObject-value dobj) _externalAddressHashNode))]
    [(6 7) (dataObject-value dobj)]
    [else #f]))

;;;TEST-->
(define dobj (empty-dataObject))
(EnvEval env "(create$ (sym-cat \"foo \" (+ 2 3 4.5)) a b c)" dobj)
