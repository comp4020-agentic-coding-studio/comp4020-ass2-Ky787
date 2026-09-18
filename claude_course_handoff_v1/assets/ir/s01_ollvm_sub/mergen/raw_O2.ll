; ModuleID = 'E:\Workspace\seeing_through_obfuscation\results\deobfuscation\mergen\arithmetic\ollvm_sub\lift\output_no_opts.ll'
source_filename = "lifter_module"

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
define i64 @main(i64 %RAX, i64 %RCX, i64 %RDX, i64 %RBX, i64 %RSP, i64 %RBP, i64 %RSI, i64 %RDI, i64 %R8, i64 %R9, i64 %R10, i64 %R11, i64 %R12, i64 %R13, i64 %R14, i64 %R15, ptr nocapture readnone %EIP, ptr nocapture writeonly %memory, i128 %XMM0, i128 %XMM1, i128 %XMM2, i128 %XMM3, i128 %XMM4, i128 %XMM5, i128 %XMM6, i128 %XMM7, i128 %XMM8, i128 %XMM9, i128 %XMM10, i128 %XMM11, i128 %XMM12, i128 %XMM13, i128 %XMM14, i128 %XMM15) local_unnamed_addr #0 {
real_return-5368714514-:
  %0 = trunc i64 %RCX to i32
  %1 = getelementptr i8, ptr %memory, i64 1375900
  store i32 %0, ptr %1, align 4
  %2 = getelementptr i8, ptr %memory, i64 1375864
  %3 = getelementptr i8, ptr %memory, i64 1375868
  %4 = getelementptr i8, ptr %memory, i64 1375872
  %5 = getelementptr i8, ptr %memory, i64 1375876
  %6 = getelementptr i8, ptr %memory, i64 1375880
  %7 = getelementptr i8, ptr %memory, i64 1375884
  %8 = getelementptr i8, ptr %memory, i64 1375888
  %9 = getelementptr i8, ptr %memory, i64 1375892
  %10 = icmp eq i32 %0, -16843009
  %11 = icmp eq i32 %0, -33686018
  %12 = icmp eq i32 %0, -50529027
  %13 = icmp eq i32 %0, -67372036
  %14 = icmp eq i32 %0, -84215045
  %15 = icmp eq i32 %0, -101058054
  %16 = icmp eq i32 %0, -117901063
  %17 = icmp eq i32 %0, -134744072
  %lola-930 = select i1 %10, i32 305420446, i32 -305419347
  store i32 %lola-930, ptr %2, align 4
  %lola-972 = select i1 %11, i32 305420446, i32 -305419347
  store i32 %lola-972, ptr %3, align 4
  %lola-991 = select i1 %12, i32 305420446, i32 -305419347
  store i32 %lola-991, ptr %4, align 4
  %lola-1034 = select i1 %13, i32 305420446, i32 -305419347
  store i32 %lola-1034, ptr %5, align 4
  %lola-1079 = select i1 %14, i32 305420446, i32 -305419347
  store i32 %lola-1079, ptr %6, align 4
  %lola-1122 = select i1 %15, i32 305420446, i32 -305419347
  store i32 %lola-1122, ptr %7, align 4
  %lola-1162 = select i1 %16, i32 305420446, i32 -305419347
  store i32 %lola-1162, ptr %8, align 4
  %lola-1205 = select i1 %17, i32 305420446, i32 -305419347
  store i32 %lola-1205, ptr %9, align 4
  %lol-1297 = select i1 %10, i32 -1970176605, i32 1970179728
  %lol-1299 = select i1 %11, i32 -1970176605, i32 1970179728
  %realxor-5368714313- = xor i32 %lol-1297, %lol-1299
  %realxor-5368714322- = xor i32 %realxor-5368714313-, -1
  %realand-5368714328- = and i32 %lola-991, %realxor-5368714322-
  %lol-1335 = select i1 %12, i32 -305421535, i32 305418258
  %realand-5368714333- = and i32 %realxor-5368714313-, %lol-1335
  %realor-5368714336- = or i32 %realand-5368714328-, %realand-5368714333-
  %lol-1416 = select i1 %13, i32 -2001409476, i32 2001410319
  %18 = xor i32 %realor-5368714336-, %lol-1416
  %realxor-5368714388- = xor i32 %18, -1702841822
  %realxor-5368714399- = xor i32 %18, 1702840605
  %realand-5368714404- = and i32 %realxor-5368714399-, %lola-1079
  %lol-1454 = select i1 %14, i32 -305420447, i32 305419346
  %realand-5368714409- = and i32 %realxor-5368714388-, %lol-1454
  %realor-5368714411- = or i32 %realand-5368714404-, %realand-5368714409-
  %realxor-5368714420- = xor i32 %realor-5368714411-, -1
  %realand-5368714426- = and i32 %lola-1122, %realxor-5368714420-
  %lol-1500 = select i1 %15, i32 -305420447, i32 305419346
  %realand-5368714431- = and i32 %realor-5368714411-, %lol-1500
  %realor-5368714434- = or i32 %realand-5368714426-, %realand-5368714431-
  %19 = icmp eq i32 %realor-5368714434-, 0
  %selectEZ1566 = select i1 %19, i32 1201192903, i32 -1201192904
  %lol2-1577 = select i1 %16, i32 1437394777, i32 -1437395862
  %realxor-5368714486- = xor i32 %selectEZ1566, %lol2-1577
  %realxor-5368714497- = xor i32 %realxor-5368714486-, -1
  %realand-5368714502- = and i32 %lola-1205, %realxor-5368714497-
  %lol-1624 = select i1 %17, i32 -305420447, i32 305419346
  %realand-5368714507- = and i32 %realxor-5368714486-, %lol-1624
  %realor-5368714509- = or i32 %realand-5368714502-, %realand-5368714507-
  %20 = zext i32 %realor-5368714509- to i64
  ret i64 %20
}

attributes #0 = { mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write) }
