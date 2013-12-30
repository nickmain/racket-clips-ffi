#lang racket
;----------------------------------------------------------------------------
; FFI functions for CLIPS
;----------------------------------------------------------------------------

(provide (all-defined-out))

(require ffi/unsafe) 
(require racket/runtime-path)
(require "ffi-utils.rkt")
(require "clips-structs.rkt")

(define-runtime-path libclips "../lib/libclips63b1")

; Go look at the CLIPS source - all the comments you need are there.

(native-lib libclips  
  _environ CreateEnvironment  ()
  _int     DestroyEnvironment ( _environ )
  
  _void    EnvClear ( _environ )
  _void    EnvReset ( _environ )
  _int     EnvEval  ( _environ _string _dataObject-pointer )
  _llong   EnvRun   ( _environ _llong )
  _int     EnvLoad  ( _environ _string )
  
  _pointer EnvAssertString ( _environ _string )
  
  _int EnvDefineFunction2 ( _environ _string _int _pointer _string _string )  
  _int EnvRtnArgCount ( _environ )
  _dataObject-pointer EnvRtnUnknown ( _environ _int _dataObject-pointer )
  
  _pointer EnvAddSymbol ( _environ _string )
  _pointer EnvAddLong ( _environ _llong )
  _pointer EnvAddDouble ( _environ _double )
  
  _multifield-pointer EnvCreateMultifield ( _environ _long )
)
