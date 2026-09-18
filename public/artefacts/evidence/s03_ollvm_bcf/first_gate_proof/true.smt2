(set-logic QF_BV)
(declare-fun g_140089018_4 () (_ BitVec 32))
(declare-fun g_14008901c_4 () (_ BitVec 32))
; Extended part - SUB operation
(define-fun ref!54 () (_ BitVec 32) (bvsub g_14008901c_4 (_ bv1 32)))
; Extended part - IMUL operation
(define-fun ref!63 () (_ BitVec 32) (bvmul g_14008901c_4 ref!54))
; Extended part - AND operation
(define-fun ref!68 () (_ BitVec 32) (bvand ref!63 (_ bv1 32)))
; CMP operation
(define-fun ref!76 () (_ BitVec 32) ref!68)
; Zero flag
(define-fun ref!82 () (_ BitVec 1) (ite (= ref!76 (_ bv0 32)) (_ bv1 1) (_ bv0 1)))
; CMP operation
(define-fun ref!86 () (_ BitVec 32) (bvsub g_140089018_4 (_ bv10 32)))
; Overflow flag
(define-fun ref!89 () (_ BitVec 1) ((_ extract 31 31) (bvand (bvxor g_140089018_4 (_ bv10 32)) (bvxor g_140089018_4 ref!86))))
; Sign flag
(define-fun ref!91 () (_ BitVec 1) ((_ extract 31 31) ref!86))
; TEST operation
(define-fun ref!103 () (_ BitVec 8) (bvand (bvor (ite (= ref!82 (_ bv1 1)) (_ bv1 8) (_ bv0 8)) (ite (= (bvxor ref!91 ref!89) (_ bv1 1)) (_ bv1 8) (_ bv0 8))) (_ bv1 8)))
; Zero flag
(define-fun ref!108 () (_ BitVec 1) (ite (= ref!103 (_ bv0 8)) (_ bv1 1) (_ bv0 1)))
(assert (and (= (_ bv1 1) (_ bv1 1)) (= ref!108 (_ bv0 1))))
(check-sat)
