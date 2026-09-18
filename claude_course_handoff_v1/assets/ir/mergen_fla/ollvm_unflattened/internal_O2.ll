; ModuleID = 'E:\Workspace\seeing_through_obfuscation\results\deobfuscation\mergen\fla\ollvm_unflattened\lift\output.ll'
source_filename = "lifter_module"

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define i64 @main(i64 %RAX, i64 %RCX, i64 %RDX, i64 %RBX, i64 %RSP, i64 %RBP, i64 %RSI, i64 %RDI, i64 %R8, i64 %R9, i64 %R10, i64 %R11, i64 %R12, i64 %R13, i64 %R14, i64 %R15, ptr nocapture readnone %EIP, ptr nocapture readnone %memory, i128 %XMM0, i128 %XMM1, i128 %XMM2, i128 %XMM3, i128 %XMM4, i128 %XMM5, i128 %XMM6, i128 %XMM7, i128 %XMM8, i128 %XMM9, i128 %XMM10, i128 %XMM11, i128 %XMM12, i128 %XMM13, i128 %XMM14, i128 %XMM15) local_unnamed_addr #0 {
entry:
  %0 = trunc i64 %RCX to i32
  %realand = and i32 %0, 1
  %zeroflag1 = icmp eq i32 %realand, 0
  br i1 %zeroflag1, label %bb1, label %bb2

bb1:                                              ; preds = %entry
  %realand.1 = and i32 %0, 256
  %zeroflag10 = icmp eq i32 %realand.1, 0
  br i1 %zeroflag10, label %bb3, label %bb4

bb2:                                              ; preds = %entry
  %realadd = add i32 %0, 4369
  %realand.2 = and i32 %realadd, 256
  %zeroflag326 = icmp eq i32 %realand.2, 0
  br i1 %zeroflag326, label %bb11, label %bb12

bb3:                                              ; preds = %bb1
  %realadd.1 = xor i32 %0, 8994
  br label %bb5

bb4:                                              ; preds = %bb1
  %realxor = xor i32 %0, 12834
  br label %bb5

bb5:                                              ; preds = %bb12, %bb11, %bb4, %bb3
  %realadd-5368714690-.sink = phi i32 [ %realadd.1, %bb3 ], [ %realxor, %bb4 ], [ %realadd.5, %bb11 ], [ %realxor.7, %bb12 ]
  %realand.3 = and i32 %realadd-5368714690-.sink, 256
  %zeroflag58 = icmp eq i32 %realand.3, 0
  %realxor.1 = xor i32 %realadd-5368714690-.sink, 4097
  %realadd.2 = add i32 %realadd-5368714690-.sink, 257
  %realxor.2 = select i1 %zeroflag58, i32 %realadd.2, i32 %realxor.1
  %realand-5368714654-56.1 = and i32 %realxor.2, 256
  %zeroflag58.1 = icmp eq i32 %realand-5368714654-56.1, 0
  %realxor-5368714748-.1 = xor i32 %realxor.2, 4098
  %realadd-5368714690-77.1 = add i32 %realxor.2, 258
  %realxor-5368714748-361.1 = select i1 %zeroflag58.1, i32 %realadd-5368714690-77.1, i32 %realxor-5368714748-.1
  %realand-5368714654-56.2 = and i32 %realxor-5368714748-361.1, 256
  %zeroflag58.2 = icmp eq i32 %realand-5368714654-56.2, 0
  %realxor-5368714748-.2 = xor i32 %realxor-5368714748-361.1, 4099
  %realadd-5368714690-77.2 = add i32 %realxor-5368714748-361.1, 259
  %realxor-5368714748-361.2 = select i1 %zeroflag58.2, i32 %realadd-5368714690-77.2, i32 %realxor-5368714748-.2
  %realand.4 = and i32 %realxor-5368714748-361.2, 3
  switch i32 %realand.4, label %bb10 [
    i32 0, label %bb6
    i32 1, label %bb8
    i32 2, label %bb9
  ]

bb6:                                              ; preds = %bb5
  %realadd.3 = add i32 %realxor-5368714748-361.2, 286331153
  %realxor.3 = xor i32 %realadd.3, -889275714
  br label %bb7

bb7:                                              ; preds = %bb10, %bb9, %bb8, %bb6
  %common.ret.op.in = phi i32 [ %realxor.3, %bb6 ], [ %realxor.4, %bb8 ], [ %realxor.6, %bb10 ], [ %realxor.5, %bb9 ]
  %common.ret.op = zext i32 %common.ret.op.in to i64
  ret i64 %common.ret.op

bb8:                                              ; preds = %bb5
  %realxor.4 = xor i32 %realxor-5368714748-361.2, -388196196
  br label %bb7

bb9:                                              ; preds = %bb5
  %realsub = add i32 %realxor-5368714748-361.2, -13107
  %realxor.5 = xor i32 %realsub, -889275714
  br label %bb7

bb10:                                             ; preds = %bb5
  %realadd.4 = add i32 %realxor-5368714748-361.2, 17476
  %realxor.6 = xor i32 %realadd.4, -889275714
  br label %bb7

bb11:                                             ; preds = %bb2
  %realadd.5 = add i32 %0, 4625
  br label %bb5

bb12:                                             ; preds = %bb2
  %realxor.7 = xor i32 %realadd, 4096
  br label %bb5
}

attributes #0 = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) }
