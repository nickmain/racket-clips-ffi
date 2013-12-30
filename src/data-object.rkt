#lang racket
;----------------------------------------------------------------------------
; CLIPS DATA_OBJECT marshaling functions
;----------------------------------------------------------------------------

(provide (all-defined-out))

(require ffi/unsafe) 
(require "clips-structs.rkt")
(require "clips-functions.rkt")

(define (empty-dataObject)
  (make-dataObject #f 0 #f 0 0 #f))

; Marshall a scheme value into a dataObject
(define (value->dataObject env value ptr-dobj)
  (let ([dobj (ptr-ref ptr-dobj _dataObject)])
    (cond
      [(symbol? value)  (set-dataObject-type! dobj SYMBOL)
                        (set-dataObject-value! dobj (EnvAddSymbol env (symbol->string value)))]
      [(symbol? value)  (set-dataObject-type! dobj STRING)
                        (set-dataObject-value! dobj (EnvAddSymbol env value))]
      [(exact-integer? value) (set-dataObject-type! dobj INTEGER)
                              (set-dataObject-value! dobj (EnvAddLong env value))]
      [(real? value)    (set-dataObject-type! dobj FLOAT)
                        (set-dataObject-value! dobj (EnvAddDouble env value))]
      [(boolean? value) (value->dataObject env (if value 'TRUE 'FALSE) dobj)]
      
      [(vector? value) (let* ([len (vector-length value)]
                              [mf (EnvCreateMultifield env len)]
                              [fields (ptr-ref (array-ptr (multifield-fields mf))
                                               (_array _field len))])
                         (set-dataObject-type! dobj MULTIFIELD)
                         (set-dataObject-value! dobj mf)
                         (set-dataObject-begin! dobj 0)
                         (set-dataObject-end!   dobj (- len 1))                       
                         (let loop ([i 0])
                           (when (< i len)
                             (value->field env 
                                           (vector-ref value i)
                                           (array-ref fields i))
                             (loop (+ i 1)))))]
      
      [(list? value) (value->dataObject env (list->vector value) dobj)]
      [else (value->dataObject env 'nil dobj)])))

; Marshall a scheme value into a multifield field
(define (value->field env value field)
  (cond
    [(symbol? value)  (set-field-type! field SYMBOL)
                      (set-field-value! field (EnvAddSymbol env (symbol->string value)))]
    [(symbol? value)  (set-field-type! field STRING)
                      (set-field-value! field (EnvAddSymbol env value))]
    [(exact-integer? value) (set-field-type! field INTEGER)
                            (set-field-value! field (EnvAddLong env value))]
    [(real? value)    (set-field-type! field FLOAT)
                      (set-field-value! field (EnvAddDouble env value))]
    [(boolean? value) (value->field env (if value 'TRUE 'FALSE) field)]
    [else (value->field env 'nil field)]))    


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
    [(2)   (let ([sym (string->symbol (symbolHashNode-contents (ptr-ref value-ptr _symbolHashNode)))])
             (case sym
               [(TRUE) #t]
               [(FALSE) #f]
               [else sym]))]
    [(3 8) (symbolHashNode-contents  (ptr-ref value-ptr _symbolHashNode))]
    [(4)   (multifield->vector value-ptr begin end)]
    [(5)   (externalAddressHashNode-externalAddress (ptr-ref value-ptr _externalAddressHashNode))]
    [(6 7) value-ptr]
    [else #f]))
