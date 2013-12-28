#lang racket
;----------------------------------------------------------------------------
; CLIPS DATA_OBJECT structures and functions
;----------------------------------------------------------------------------

(provide (all-defined-out))

(require ffi/unsafe) 
(require ffi/cvector)

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

(define (empty-dataObject)
  (make-dataObject #f 0 #f 0 0 #f))

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

; marshal a dataObject to a scheme value
(define (dataObject->value dobj)
  (clips-value->scheme-value (dataObject-value dobj) 
                             (dataObject-type dobj)
                             (dataObject-begin dobj)
                             (dataObject-end dobj)))

; multifield to vector
(define (multifield->vector mf-ptr begin end)
  (let* ([len (+ 1 (- end begin))]        
         [mf  (ptr-ref mf-ptr _multifield)]
         [fields (ptr-ref (array-ptr (multifield-fields mf))
                          (_array _field (multifield-length mf)))]
         [v (make-vector len)])
    (let loop ([vidx 0])
      (when (< vidx len)
        (let* ([fld  (array-ref fields (+ vidx begin))]
               [type (field-type fld)]
               [val  (field-value fld)])
          (vector-set! v vidx 
                       (clips-value->scheme-value val type))
          (loop (+ vidx 1)))))
    v))
  
; marshal a CLIPS value to a scheme value
(define (clips-value->scheme-value value-ptr type [begin 0] [end 0])
  (case type
    [(0)   (floatHashNode-contents   (ptr-ref value-ptr _floatHashNode))]
    [(1)   (integerHashNode-contents (ptr-ref value-ptr _integerHashNode))]
    [(2)   (string->symbol (symbolHashNode-contents (ptr-ref value-ptr _symbolHashNode)))]
    [(3 8) (symbolHashNode-contents  (ptr-ref value-ptr _symbolHashNode))]
    [(4)   (multifield->vector value-ptr begin end)]
    [(5)   (externalAddressHashNode-externalAddress (ptr-ref value-ptr _externalAddressHashNode))]
    [(6 7) value-ptr]
    [else #f]))
