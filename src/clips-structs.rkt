#lang racket
;----------------------------------------------------------------------------
; CLIPS structures
;----------------------------------------------------------------------------

(provide (all-defined-out))

(require ffi/unsafe) 

(define _environ _pointer)

(define-cstruct _dataObject (
  [supplementalInfo _pointer]
  [type  _ushort]
  [value _pointer]
  [begin _long]
  [end   _long]
  [next  _pointer]))

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

(define-cstruct _floatHashNode (
  [next  _floatHashNode-pointer]
  [count _long]
  [depth _int]
  [flags _uint32]
  [contents _double]))

(define-cstruct _integerHashNode (
  [next  _integerHashNode-pointer]
  [count _long]
  [depth _int]
  [flags _uint32]
  [contents _llong]))

(define-cstruct _symbolHashNode (
  [next  _symbolHashNode-pointer]
  [count _long]
  [depth _int]
  [flags _uint32]
  [contents _string]))

(define-cstruct _externalAddressHashNode (
  [next  _externalAddressHashNode-pointer]
  [count _long]
  [depth _int]
  [flags _uint32]
  [externalAddress _pointer]
  [type  _ushort]))

(define-cstruct _field (
  [type  _ushort]
  [value _pointer]))

(define-cstruct _multifield (
  [busyCount _uint]
  [depth     _short]
  [length    _long]
  [next      _multifield-pointer]
  [fields    (_array _field 1)]))
