; ModuleID = 'E:\Workspace\seeing_through_obfuscation\results\deobfuscation\mergen\arithmetic\ollvm_sub\lift\output.ll'
source_filename = "lifter_module"

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define i64 @main(i64 %RAX, i64 %RCX, i64 %RDX, i64 %RBX, i64 %RSP, i64 %RBP, i64 %RSI, i64 %RDI, i64 %R8, i64 %R9, i64 %R10, i64 %R11, i64 %R12, i64 %R13, i64 %R14, i64 %R15, ptr nocapture readnone %EIP, ptr nocapture readnone %memory, i128 %XMM0, i128 %XMM1, i128 %XMM2, i128 %XMM3, i128 %XMM4, i128 %XMM5, i128 %XMM6, i128 %XMM7, i128 %XMM8, i128 %XMM9, i128 %XMM10, i128 %XMM11, i128 %XMM12, i128 %XMM13, i128 %XMM14, i128 %XMM15) local_unnamed_addr #0 {
entry:
  %0 = trunc i64 %RCX to i32
  %1 = icmp eq i32 %0, -16843009
  %2 = icmp eq i32 %0, -33686018
  %3 = icmp eq i32 %0, -50529027
  %4 = icmp eq i32 %0, -67372036
  %5 = icmp eq i32 %0, -84215045
  %6 = icmp eq i32 %0, -101058054
  %7 = icmp eq i32 %0, -117901063
  %8 = icmp eq i32 %0, -134744072
  %lola = select i1 %3, i32 305420446, i32 -305419347
  %lola.1 = select i1 %5, i32 305420446, i32 -305419347
  %lola.2 = select i1 %6, i32 305420446, i32 -305419347
  %lola.3 = select i1 %8, i32 305420446, i32 -305419347
  %lol = select i1 %1, i32 -1970176605, i32 1970179728
  %lol.1 = select i1 %2, i32 -1970176605, i32 1970179728
  %realxor = xor i32 %lol, %lol.1
  %realxor.1 = xor i32 %realxor, -1
  %realand = and i32 %lola, %realxor.1
  %lol.2 = select i1 %3, i32 -305421535, i32 305418258
  %realand.1 = and i32 %realxor, %lol.2
  %realor = or i32 %realand, %realand.1
  %lol.3 = select i1 %4, i32 -2001409476, i32 2001410319
  %9 = xor i32 %realor, %lol.3
  %realxor.2 = xor i32 %9, -1702841822
  %realxor.3 = xor i32 %9, 1702840605
  %realand.2 = and i32 %realxor.3, %lola.1
  %lol.4 = select i1 %5, i32 -305420447, i32 305419346
  %realand.3 = and i32 %realxor.2, %lol.4
  %realor.1 = or i32 %realand.2, %realand.3
  %realxor.4 = xor i32 %realor.1, -1
  %realand.4 = and i32 %lola.2, %realxor.4
  %lol.5 = select i1 %6, i32 -305420447, i32 305419346
  %realand.5 = and i32 %realor.1, %lol.5
  %realor.2 = or i32 %realand.4, %realand.5
  %10 = icmp eq i32 %realor.2, 0
  %selectEZ1566 = select i1 %10, i32 1201192903, i32 -1201192904
  %lol2 = select i1 %7, i32 1437394777, i32 -1437395862
  %realxor.5 = xor i32 %selectEZ1566, %lol2
  %realxor.6 = xor i32 %realxor.5, -1
  %realand.6 = and i32 %lola.3, %realxor.6
  %lol.6 = select i1 %8, i32 -305420447, i32 305419346
  %realand.7 = and i32 %realxor.5, %lol.6
  %realor.3 = or i32 %realand.6, %realand.7
  %11 = zext i32 %realor.3 to i64
  ret i64 %11
}

attributes #0 = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) }
