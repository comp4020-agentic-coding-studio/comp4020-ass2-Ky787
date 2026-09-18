; ModuleID = 'E:\Workspace\seeing_through_obfuscation\results\deobfuscation\mergen\fla\ollvm_original\lift\output_no_opts.ll'
source_filename = "lifter_module"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define i64 @main(i64 %RAX, i64 %RCX, i64 %RDX, i64 %RBX, i64 %RSP, i64 %RBP, i64 %RSI, i64 %RDI, i64 %R8, i64 %R9, i64 %R10, i64 %R11, i64 %R12, i64 %R13, i64 %R14, i64 %R15, ptr nocapture readnone %EIP, ptr nocapture %memory, i128 %XMM0, i128 %XMM1, i128 %XMM2, i128 %XMM3, i128 %XMM4, i128 %XMM5, i128 %XMM6, i128 %XMM7, i128 %XMM8, i128 %XMM9, i128 %XMM10, i128 %XMM11, i128 %XMM12, i128 %XMM13, i128 %XMM14, i128 %XMM15) local_unnamed_addr #0 {
previousjmp_block-5368714358-:
  %0 = trunc i64 %RCX to i32
  %1 = getelementptr i8, ptr %memory, i64 1375892
  store i32 %0, ptr %1, align 4
  %2 = getelementptr i8, ptr %memory, i64 1375888
  store i32 %0, ptr %2, align 4
  %realand-5368714327- = and i32 %0, 1
  %3 = getelementptr i8, ptr %memory, i64 1375896
  store i32 %realand-5368714327-, ptr %3, align 4
  %4 = getelementptr i8, ptr %memory, i64 1375880
  %zeroflag25.not = icmp eq i32 %realand-5368714327-, 0
  %lol-27 = select i1 %zeroflag25.not, i32 605478433, i32 -1606921101
  store i32 %lol-27, ptr %4, align 4
  %5 = getelementptr i8, ptr %memory, i64 1375884
  %6 = getelementptr i8, ptr %memory, i64 1375900
  br label %previousjmp_block-0-86.outer

previousjmp_block-0-86.outer:                     ; preds = %previousjmp_block-0-86.backedge.sink.split, %previousjmp_block-5368714358-
  %.ph4 = phi i32 [ %.ph, %previousjmp_block-0-86.backedge.sink.split ], [ %0, %previousjmp_block-5368714358- ]
  %.ph5 = phi i32 [ %.ph2, %previousjmp_block-0-86.backedge.sink.split ], [ %0, %previousjmp_block-5368714358- ]
  %.ph6 = phi i32 [ %.ph3, %previousjmp_block-0-86.backedge.sink.split ], [ %0, %previousjmp_block-5368714358- ]
  %.ph7 = phi i32 [ %lol-98.sink, %previousjmp_block-0-86.backedge.sink.split ], [ %lol-27, %previousjmp_block-5368714358- ]
  br label %previousjmp_block-0-86

previousjmp_block-0-86:                           ; preds = %previousjmp_block-0-86.outer, %previousjmp_block-0-86
  switch i32 %.ph7, label %previousjmp_block-0-86 [
    i32 -1928282851, label %bb_true84
    i32 -1606921101, label %bb_true116
    i32 -906389340, label %bb_true154
    i32 -222858904, label %bb_true182
    i32 61707517, label %bb_true208
    i32 113589690, label %bb_true228
    i32 526445444, label %real_return-5368715218-
    i32 582032103, label %bb_true290
    i32 605478433, label %bb_true327
    i32 680461358, label %bb_true355
    i32 743425413, label %bb_true387
    i32 879957278, label %bb_true419
    i32 1367572438, label %previousjmp_block-0-86.backedge.sink.split
    i32 1626327509, label %bb_true493
    i32 1629775455, label %bb_true525
    i32 1676569018, label %bb_true549
    i32 1684104516, label %bb_true586
    i32 2000015314, label %bb_true638
    i32 2138990305, label %bb_true675
  ]

bb_true84:                                        ; preds = %previousjmp_block-0-86
  %7 = load i32, ptr %6, align 4
  %8 = add i32 %7, -2
  %9 = or i32 %8, %7
  %.not1 = icmp sgt i32 %9, -1
  %lol-98 = select i1 %.not1, i32 743425413, i32 -906389340
  br label %previousjmp_block-0-86.backedge.sink.split

previousjmp_block-0-86.backedge.sink.split:       ; preds = %previousjmp_block-0-86, %bb_true675, %bb_true638, %bb_true586, %bb_true549, %bb_true525, %bb_true493, %bb_true419, %bb_true387, %bb_true355, %bb_true327, %bb_true290, %bb_true228, %bb_true208, %bb_true182, %bb_true154, %bb_true116, %bb_true84
  %lol-98.sink = phi i32 [ %lol-98, %bb_true84 ], [ 61707517, %bb_true116 ], [ 526445444, %bb_true154 ], [ 680461358, %bb_true182 ], [ 1626327509, %bb_true208 ], [ 526445444, %bb_true228 ], [ 526445444, %bb_true290 ], [ 61707517, %bb_true327 ], [ %lol-369, %bb_true355 ], [ %lol-401, %bb_true387 ], [ 2138990305, %bb_true419 ], [ %lol-507, %bb_true493 ], [ %lol-531, %bb_true525 ], [ 1626327509, %bb_true549 ], [ 2138990305, %bb_true586 ], [ 526445444, %bb_true638 ], [ 1676569018, %bb_true675 ], [ %lol-27, %previousjmp_block-0-86 ]
  %.ph = phi i32 [ %.ph4, %bb_true84 ], [ %realadd-5368714766-119, %bb_true116 ], [ %realxor-5368715135-, %bb_true154 ], [ %.ph4, %bb_true182 ], [ %.ph4, %bb_true208 ], [ %realsub-5368715161-, %bb_true228 ], [ %realadd-5368715187-, %bb_true290 ], [ %realxor-5368714792-, %bb_true327 ], [ %.ph4, %bb_true355 ], [ %.ph4, %bb_true387 ], [ %realxor-5368714905-, %bb_true419 ], [ %.ph4, %bb_true493 ], [ %.ph4, %bb_true525 ], [ %.ph4, %bb_true549 ], [ %realadd-5368714935-, %bb_true586 ], [ %realadd-5368715109-, %bb_true638 ], [ %.ph4, %bb_true675 ], [ %.ph4, %previousjmp_block-0-86 ]
  %.ph2 = phi i32 [ %.ph5, %bb_true84 ], [ %realadd-5368714766-119, %bb_true116 ], [ %realxor-5368715135-, %bb_true154 ], [ %.ph4, %bb_true182 ], [ %.ph5, %bb_true208 ], [ %realsub-5368715161-, %bb_true228 ], [ %realadd-5368715187-, %bb_true290 ], [ %realxor-5368714792-, %bb_true327 ], [ %.ph5, %bb_true355 ], [ %.ph5, %bb_true387 ], [ %realxor-5368714905-, %bb_true419 ], [ %.ph5, %bb_true493 ], [ %.ph5, %bb_true525 ], [ %.ph5, %bb_true549 ], [ %realadd-5368714935-, %bb_true586 ], [ %realadd-5368715109-, %bb_true638 ], [ %.ph5, %bb_true675 ], [ %.ph5, %previousjmp_block-0-86 ]
  %.ph3 = phi i32 [ %.ph6, %bb_true84 ], [ %realadd-5368714766-119, %bb_true116 ], [ %realxor-5368715135-, %bb_true154 ], [ %.ph4, %bb_true182 ], [ %.ph6, %bb_true208 ], [ %realsub-5368715161-, %bb_true228 ], [ %realadd-5368715187-, %bb_true290 ], [ %realxor-5368714792-, %bb_true327 ], [ %.ph6, %bb_true355 ], [ %.ph6, %bb_true387 ], [ %realxor-5368714905-, %bb_true419 ], [ %.ph6, %bb_true493 ], [ %.ph5, %bb_true525 ], [ %.ph6, %bb_true549 ], [ %realadd-5368714935-, %bb_true586 ], [ %realadd-5368715109-, %bb_true638 ], [ %.ph6, %bb_true675 ], [ %.ph6, %previousjmp_block-0-86 ]
  store i32 %lol-98.sink, ptr %4, align 4
  br label %previousjmp_block-0-86.outer

bb_true116:                                       ; preds = %previousjmp_block-0-86
  %realadd-5368714766-119 = add i32 %.ph4, 4369
  store i32 %realadd-5368714766-119, ptr %2, align 4
  br label %previousjmp_block-0-86.backedge.sink.split

bb_true154:                                       ; preds = %previousjmp_block-0-86
  %realxor-5368715135- = xor i32 %.ph4, 572662306
  store i32 %realxor-5368715135-, ptr %2, align 4
  br label %previousjmp_block-0-86.backedge.sink.split

bb_true182:                                       ; preds = %previousjmp_block-0-86
  %realand-5368714996- = and i32 %.ph4, 3
  store i32 %realand-5368714996-, ptr %6, align 4
  br label %previousjmp_block-0-86.backedge.sink.split

bb_true208:                                       ; preds = %previousjmp_block-0-86
  store i32 0, ptr %5, align 4
  br label %previousjmp_block-0-86.backedge.sink.split

bb_true228:                                       ; preds = %previousjmp_block-0-86
  %realsub-5368715161- = add i32 %.ph5, -13107
  store i32 %realsub-5368715161-, ptr %2, align 4
  br label %previousjmp_block-0-86.backedge.sink.split

real_return-5368715218-:                          ; preds = %previousjmp_block-0-86
  %10 = getelementptr i8, ptr %memory, i64 1375876
  store i32 526445444, ptr %10, align 4
  %realxor-5368715213- = xor i32 %.ph5, -889275714
  %11 = zext i32 %realxor-5368715213- to i64
  ret i64 %11

bb_true290:                                       ; preds = %previousjmp_block-0-86
  %realadd-5368715187- = add i32 %.ph5, 17476
  store i32 %realadd-5368715187-, ptr %2, align 4
  br label %previousjmp_block-0-86.backedge.sink.split

bb_true327:                                       ; preds = %previousjmp_block-0-86
  %realxor-5368714792- = xor i32 %.ph5, 8738
  store i32 %realxor-5368714792-, ptr %2, align 4
  br label %previousjmp_block-0-86.backedge.sink.split

bb_true355:                                       ; preds = %previousjmp_block-0-86
  %12 = load i32, ptr %6, align 4
  %.not = icmp sgt i32 %12, 0
  %lol-369 = select i1 %.not, i32 -1928282851, i32 2000015314
  br label %previousjmp_block-0-86.backedge.sink.split

bb_true387:                                       ; preds = %previousjmp_block-0-86
  %13 = load i32, ptr %6, align 4
  %zeroflag391 = icmp eq i32 %13, 2
  %lol-401 = select i1 %zeroflag391, i32 113589690, i32 582032103
  br label %previousjmp_block-0-86.backedge.sink.split

bb_true419:                                       ; preds = %previousjmp_block-0-86
  %14 = load i32, ptr %5, align 4
  %realadd-5368714901- = add i32 %14, 4096
  %realxor-5368714905- = xor i32 %realadd-5368714901-, %.ph5
  store i32 %realxor-5368714905-, ptr %2, align 4
  br label %previousjmp_block-0-86.backedge.sink.split

bb_true493:                                       ; preds = %previousjmp_block-0-86
  %15 = load i32, ptr %5, align 4
  %16 = icmp ult i32 %15, 4
  %lol-507 = select i1 %16, i32 1629775455, i32 -222858904
  br label %previousjmp_block-0-86.backedge.sink.split

bb_true525:                                       ; preds = %previousjmp_block-0-86
  %realand-5368714867- = and i32 %.ph5, 256
  %zeroflag529.not = icmp eq i32 %realand-5368714867-, 0
  %lol-531 = select i1 %zeroflag529.not, i32 1684104516, i32 879957278
  br label %previousjmp_block-0-86.backedge.sink.split

bb_true549:                                       ; preds = %previousjmp_block-0-86
  %17 = load i32, ptr %5, align 4
  %realadd-5368714972- = add i32 %17, 1
  store i32 %realadd-5368714972-, ptr %5, align 4
  br label %previousjmp_block-0-86.backedge.sink.split

bb_true586:                                       ; preds = %previousjmp_block-0-86
  %18 = load i32, ptr %5, align 4
  %realadd-5368714931- = add i32 %18, 256
  %realadd-5368714935- = add i32 %realadd-5368714931-, %.ph6
  store i32 %realadd-5368714935-, ptr %2, align 4
  br label %previousjmp_block-0-86.backedge.sink.split

bb_true638:                                       ; preds = %previousjmp_block-0-86
  %realadd-5368715109- = add i32 %.ph6, 286331153
  store i32 %realadd-5368715109-, ptr %2, align 4
  br label %previousjmp_block-0-86.backedge.sink.split

bb_true675:                                       ; preds = %previousjmp_block-0-86
  br label %previousjmp_block-0-86.backedge.sink.split
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) }
