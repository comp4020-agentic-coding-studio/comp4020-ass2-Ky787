; ModuleID = 'E:\Workspace\seeing_through_obfuscation\results\deobfuscation\mergen\fla\ollvm_unflattened\lift\output_no_opts.ll'
source_filename = "lifter_module"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: write)
define i64 @main(i64 %RAX, i64 %RCX, i64 %RDX, i64 %RBX, i64 %RSP, i64 %RBP, i64 %RSI, i64 %RDI, i64 %R8, i64 %R9, i64 %R10, i64 %R11, i64 %R12, i64 %R13, i64 %R14, i64 %R15, ptr nocapture readnone %EIP, ptr nocapture writeonly %memory, i128 %XMM0, i128 %XMM1, i128 %XMM2, i128 %XMM3, i128 %XMM4, i128 %XMM5, i128 %XMM6, i128 %XMM7, i128 %XMM8, i128 %XMM9, i128 %XMM10, i128 %XMM11, i128 %XMM12, i128 %XMM13, i128 %XMM14, i128 %XMM15) local_unnamed_addr #0 {
previousjmp_block-0-:
  %0 = trunc i64 %RCX to i32
  %1 = getelementptr i8, ptr %memory, i64 1375892
  store i32 %0, ptr %1, align 4
  %2 = getelementptr i8, ptr %memory, i64 1375888
  %realand-5368714327- = and i32 %0, 1
  %3 = getelementptr i8, ptr %memory, i64 1375896
  store i32 %realand-5368714327-, ptr %3, align 4
  %4 = getelementptr i8, ptr %memory, i64 1375880
  %zeroflag1 = icmp eq i32 %realand-5368714327-, 0
  br i1 %zeroflag1, label %previousjmp_block-5368714644-, label %bb_false

previousjmp_block-5368714644-:                    ; preds = %previousjmp_block-0-
  %realand-5368714654- = and i32 %0, 256
  %zeroflag10 = icmp eq i32 %realand-5368714654-, 0
  br i1 %zeroflag10, label %bb_true, label %bb_false11

bb_false:                                         ; preds = %previousjmp_block-0-
  %realadd-5368714775- = add i32 %0, 4369
  %realand-5368714654-324 = and i32 %realadd-5368714775-, 256
  %zeroflag326 = icmp eq i32 %realand-5368714654-324, 0
  br i1 %zeroflag326, label %bb_true327, label %bb_false328

bb_true:                                          ; preds = %previousjmp_block-5368714644-
  %realadd-5368714690- = xor i32 %0, 8994
  br label %previousjmp_block-0-61

bb_false11:                                       ; preds = %previousjmp_block-5368714644-
  %realxor-5368714748-294 = xor i32 %0, 12834
  br label %previousjmp_block-0-61

previousjmp_block-0-61:                           ; preds = %bb_true, %bb_false11, %bb_true327, %bb_false328
  %.promoted4 = phi i32 [ %realadd-5368714690-, %bb_true ], [ %realxor-5368714748-294, %bb_false11 ], [ %realadd-5368714690-330, %bb_true327 ], [ %realxor-5368714748-346, %bb_false328 ]
  %5 = getelementptr i8, ptr %memory, i64 1375884
  %realand-5368714654-56 = and i32 %.promoted4, 256
  %zeroflag58 = icmp eq i32 %realand-5368714654-56, 0
  %realadd-5368714690-77 = add i32 %.promoted4, 257
  %realxor-5368714748- = xor i32 %.promoted4, 4097
  %realxor-5368714748-.sink = select i1 %zeroflag58, i32 %realadd-5368714690-77, i32 %realxor-5368714748-
  %realand-5368714654-56.1 = and i32 %realxor-5368714748-.sink, 256
  %zeroflag58.1 = icmp eq i32 %realand-5368714654-56.1, 0
  %realadd-5368714690-77.1 = add i32 %realxor-5368714748-.sink, 258
  %realxor-5368714748-.1 = xor i32 %realxor-5368714748-.sink, 4098
  %realxor-5368714748-.sink.1 = select i1 %zeroflag58.1, i32 %realadd-5368714690-77.1, i32 %realxor-5368714748-.1
  %realand-5368714654-56.2 = and i32 %realxor-5368714748-.sink.1, 256
  %zeroflag58.2 = icmp eq i32 %realand-5368714654-56.2, 0
  %realadd-5368714690-77.2 = add i32 %realxor-5368714748-.sink.1, 259
  %realxor-5368714748-.2 = xor i32 %realxor-5368714748-.sink.1, 4099
  %realxor-5368714748-.sink.2 = select i1 %zeroflag58.2, i32 %realadd-5368714690-77.2, i32 %realxor-5368714748-.2
  store i32 4, ptr %5, align 4
  %realand-5368714435- = and i32 %realxor-5368714748-.sink.2, 3
  %6 = getelementptr i8, ptr %memory, i64 1375900
  store i32 %realand-5368714435-, ptr %6, align 4
  switch i32 %realand-5368714435-, label %real_return-5368714563-283 [
    i32 0, label %bb_true169
    i32 1, label %bb_true207
    i32 2, label %bb_true233
  ]

bb_true169:                                       ; preds = %previousjmp_block-0-61
  %realadd-5368714626- = add i32 %realxor-5368714748-.sink.2, 286331153
  store i32 %realadd-5368714626-, ptr %2, align 4
  store i32 526445444, ptr %4, align 4
  %realxor-5368714558- = xor i32 %realadd-5368714626-, -889275714
  br label %common.ret

common.ret:                                       ; preds = %bb_true233, %real_return-5368714563-283, %bb_true207, %bb_true169
  %common.ret.op.in = phi i32 [ %realxor-5368714558-, %bb_true169 ], [ %realxor-5368714558-219, %bb_true207 ], [ %realxor-5368714558-274, %real_return-5368714563-283 ], [ %realxor-5368714558-247, %bb_true233 ]
  %common.ret.op = zext i32 %common.ret.op.in to i64
  ret i64 %common.ret.op

bb_true207:                                       ; preds = %previousjmp_block-0-61
  %realxor-5368714599- = xor i32 %realxor-5368714748-.sink.2, 572662306
  store i32 %realxor-5368714599-, ptr %2, align 4
  store i32 526445444, ptr %4, align 4
  %realxor-5368714558-219 = xor i32 %realxor-5368714748-.sink.2, -388196196
  br label %common.ret

bb_true233:                                       ; preds = %previousjmp_block-0-61
  %realsub-5368714572- = add i32 %realxor-5368714748-.sink.2, -13107
  store i32 %realsub-5368714572-, ptr %2, align 4
  store i32 526445444, ptr %4, align 4
  %realxor-5368714558-247 = xor i32 %realsub-5368714572-, -889275714
  br label %common.ret

real_return-5368714563-283:                       ; preds = %previousjmp_block-0-61
  %realadd-5368714537- = add i32 %realxor-5368714748-.sink.2, 17476
  store i32 %realadd-5368714537-, ptr %2, align 4
  store i32 526445444, ptr %4, align 4
  %realxor-5368714558-274 = xor i32 %realadd-5368714537-, -889275714
  br label %common.ret

bb_true327:                                       ; preds = %bb_false
  %realadd-5368714690-330 = add i32 %0, 4625
  br label %previousjmp_block-0-61

bb_false328:                                      ; preds = %bb_false
  %realxor-5368714748-346 = xor i32 %realadd-5368714775-, 4096
  br label %previousjmp_block-0-61
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: write) }
