; ModuleID = 'E:\Workspace\seeing_through_obfuscation\results\deobfuscation\mergen\fla\ollvm_original\lift\output.ll'
source_filename = "lifter_module"

; Function Attrs: nofree norecurse nosync nounwind memory(none)
define i64 @main(i64 %RAX, i64 %RCX, i64 %RDX, i64 %RBX, i64 %RSP, i64 %RBP, i64 %RSI, i64 %RDI, i64 %R8, i64 %R9, i64 %R10, i64 %R11, i64 %R12, i64 %R13, i64 %R14, i64 %R15, ptr nocapture readnone %EIP, ptr nocapture readnone %memory, i128 %XMM0, i128 %XMM1, i128 %XMM2, i128 %XMM3, i128 %XMM4, i128 %XMM5, i128 %XMM6, i128 %XMM7, i128 %XMM8, i128 %XMM9, i128 %XMM10, i128 %XMM11, i128 %XMM12, i128 %XMM13, i128 %XMM14, i128 %XMM15) local_unnamed_addr #0 {
entry:
  %0 = trunc i64 %RCX to i32
  %realand = and i32 %0, 1
  %zeroflag25.not = icmp eq i32 %realand, 0
  %lol = select i1 %zeroflag25.not, i32 605478433, i32 -1606921101
  br label %bb1

bb1:                                              ; preds = %bb1.backedge, %entry
  %stackmemory719.sroa.33.0 = phi i32 [ undef, %entry ], [ %stackmemory719.sroa.33.0.be, %bb1.backedge ]
  %stackmemory719.sroa.11.0 = phi i32 [ %0, %entry ], [ %stackmemory719.sroa.11.0.be, %bb1.backedge ]
  %stackmemory719.sroa.5.0 = phi i32 [ undef, %entry ], [ %stackmemory719.sroa.5.0.be, %bb1.backedge ]
  %.ph = phi i32 [ %lol, %entry ], [ %.ph.be, %bb1.backedge ]
  switch i32 %.ph, label %bb3 [
    i32 -1928282851, label %bb4
    i32 -1606921101, label %bb5
    i32 -906389340, label %bb6
    i32 -222858904, label %bb7
    i32 61707517, label %bb8
    i32 113589690, label %bb9
    i32 526445444, label %bb10
    i32 582032103, label %bb11
    i32 605478433, label %bb12
    i32 680461358, label %bb13
    i32 743425413, label %bb14
    i32 879957278, label %bb15
    i32 1367572438, label %bb1.backedge
    i32 1626327509, label %bb16
    i32 1629775455, label %bb17
    i32 1676569018, label %bb18
    i32 1684104516, label %bb19
    i32 2000015314, label %bb20
    i32 2138990305, label %bb21
  ]

bb3:                                              ; preds = %bb1, %bb3
  br label %bb3

bb4:                                              ; preds = %bb1
  %1 = add i32 %stackmemory719.sroa.33.0, -2
  %2 = or i32 %1, %stackmemory719.sroa.33.0
  %.not718 = icmp sgt i32 %2, -1
  %lol.1 = select i1 %.not718, i32 743425413, i32 -906389340
  br label %bb1.backedge

bb5:                                              ; preds = %bb1
  %realadd = add i32 %stackmemory719.sroa.11.0, 4369
  br label %bb1.backedge

bb6:                                              ; preds = %bb1
  %realxor = xor i32 %stackmemory719.sroa.11.0, 572662306
  br label %bb1.backedge

bb7:                                              ; preds = %bb1
  %realand.1 = and i32 %stackmemory719.sroa.11.0, 3
  br label %bb1.backedge

bb8:                                              ; preds = %bb1
  br label %bb1.backedge

bb9:                                              ; preds = %bb1
  %realsub = add i32 %stackmemory719.sroa.11.0, -13107
  br label %bb1.backedge

bb10:                                             ; preds = %bb1
  %realxor.1 = xor i32 %stackmemory719.sroa.11.0, -889275714
  %3 = zext i32 %realxor.1 to i64
  ret i64 %3

bb11:                                             ; preds = %bb1
  %realadd.1 = add i32 %stackmemory719.sroa.11.0, 17476
  br label %bb1.backedge

bb12:                                             ; preds = %bb1
  %realxor.2 = xor i32 %stackmemory719.sroa.11.0, 8738
  br label %bb1.backedge

bb13:                                             ; preds = %bb1
  %.not = icmp sgt i32 %stackmemory719.sroa.33.0, 0
  %lol.2 = select i1 %.not, i32 -1928282851, i32 2000015314
  br label %bb1.backedge

bb14:                                             ; preds = %bb1
  %zeroflag391 = icmp eq i32 %stackmemory719.sroa.33.0, 2
  %lol.3 = select i1 %zeroflag391, i32 113589690, i32 582032103
  br label %bb1.backedge

bb15:                                             ; preds = %bb1
  %realadd.2 = add i32 %stackmemory719.sroa.5.0, 4096
  %realxor.3 = xor i32 %realadd.2, %stackmemory719.sroa.11.0
  br label %bb1.backedge

bb16:                                             ; preds = %bb1
  %4 = icmp ult i32 %stackmemory719.sroa.5.0, 4
  %lol.4 = select i1 %4, i32 1629775455, i32 -222858904
  br label %bb1.backedge

bb17:                                             ; preds = %bb1
  %realand.2 = and i32 %stackmemory719.sroa.11.0, 256
  %zeroflag529.not = icmp eq i32 %realand.2, 0
  %lol.5 = select i1 %zeroflag529.not, i32 1684104516, i32 879957278
  br label %bb1.backedge

bb18:                                             ; preds = %bb1
  %realadd.3 = add i32 %stackmemory719.sroa.5.0, 1
  br label %bb1.backedge

bb19:                                             ; preds = %bb1
  %realadd.4 = add i32 %stackmemory719.sroa.11.0, 256
  %realadd.5 = add i32 %realadd.4, %stackmemory719.sroa.5.0
  br label %bb1.backedge

bb20:                                             ; preds = %bb1
  %realadd.6 = add i32 %stackmemory719.sroa.11.0, 286331153
  br label %bb1.backedge

bb21:                                             ; preds = %bb1
  br label %bb1.backedge

bb1.backedge:                                     ; preds = %bb21, %bb20, %bb19, %bb18, %bb17, %bb16, %bb15, %bb14, %bb13, %bb12, %bb11, %bb9, %bb8, %bb7, %bb6, %bb5, %bb4, %bb1
  %stackmemory719.sroa.33.0.be = phi i32 [ %stackmemory719.sroa.33.0, %bb21 ], [ %stackmemory719.sroa.33.0, %bb20 ], [ %stackmemory719.sroa.33.0, %bb19 ], [ %stackmemory719.sroa.33.0, %bb18 ], [ %stackmemory719.sroa.33.0, %bb17 ], [ %stackmemory719.sroa.33.0, %bb16 ], [ %stackmemory719.sroa.33.0, %bb15 ], [ %stackmemory719.sroa.33.0, %bb14 ], [ %stackmemory719.sroa.33.0, %bb13 ], [ %stackmemory719.sroa.33.0, %bb12 ], [ %stackmemory719.sroa.33.0, %bb11 ], [ %stackmemory719.sroa.33.0, %bb9 ], [ %stackmemory719.sroa.33.0, %bb8 ], [ %realand.1, %bb7 ], [ %stackmemory719.sroa.33.0, %bb6 ], [ %stackmemory719.sroa.33.0, %bb5 ], [ %stackmemory719.sroa.33.0, %bb4 ], [ %stackmemory719.sroa.33.0, %bb1 ]
  %stackmemory719.sroa.11.0.be = phi i32 [ %stackmemory719.sroa.11.0, %bb21 ], [ %realadd.6, %bb20 ], [ %realadd.5, %bb19 ], [ %stackmemory719.sroa.11.0, %bb18 ], [ %stackmemory719.sroa.11.0, %bb17 ], [ %stackmemory719.sroa.11.0, %bb16 ], [ %realxor.3, %bb15 ], [ %stackmemory719.sroa.11.0, %bb14 ], [ %stackmemory719.sroa.11.0, %bb13 ], [ %realxor.2, %bb12 ], [ %realadd.1, %bb11 ], [ %realsub, %bb9 ], [ %stackmemory719.sroa.11.0, %bb8 ], [ %stackmemory719.sroa.11.0, %bb7 ], [ %realxor, %bb6 ], [ %realadd, %bb5 ], [ %stackmemory719.sroa.11.0, %bb4 ], [ %stackmemory719.sroa.11.0, %bb1 ]
  %stackmemory719.sroa.5.0.be = phi i32 [ %stackmemory719.sroa.5.0, %bb21 ], [ %stackmemory719.sroa.5.0, %bb20 ], [ %stackmemory719.sroa.5.0, %bb19 ], [ %realadd.3, %bb18 ], [ %stackmemory719.sroa.5.0, %bb17 ], [ %stackmemory719.sroa.5.0, %bb16 ], [ %stackmemory719.sroa.5.0, %bb15 ], [ %stackmemory719.sroa.5.0, %bb14 ], [ %stackmemory719.sroa.5.0, %bb13 ], [ %stackmemory719.sroa.5.0, %bb12 ], [ %stackmemory719.sroa.5.0, %bb11 ], [ %stackmemory719.sroa.5.0, %bb9 ], [ 0, %bb8 ], [ %stackmemory719.sroa.5.0, %bb7 ], [ %stackmemory719.sroa.5.0, %bb6 ], [ %stackmemory719.sroa.5.0, %bb5 ], [ %stackmemory719.sroa.5.0, %bb4 ], [ %stackmemory719.sroa.5.0, %bb1 ]
  %.ph.be = phi i32 [ 1676569018, %bb21 ], [ 526445444, %bb20 ], [ 2138990305, %bb19 ], [ 1626327509, %bb18 ], [ %lol.5, %bb17 ], [ %lol.4, %bb16 ], [ 2138990305, %bb15 ], [ %lol.3, %bb14 ], [ %lol.2, %bb13 ], [ 61707517, %bb12 ], [ 526445444, %bb11 ], [ 526445444, %bb9 ], [ 1626327509, %bb8 ], [ 680461358, %bb7 ], [ 526445444, %bb6 ], [ 61707517, %bb5 ], [ %lol.1, %bb4 ], [ %lol, %bb1 ]
  br label %bb1
}

attributes #0 = { nofree norecurse nosync nounwind memory(none) }
