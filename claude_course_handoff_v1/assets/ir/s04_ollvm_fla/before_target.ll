define dso_local dllexport i32 @demo_flattening(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 %0, ptr %4, align 4
  %7 = load i32, ptr %4, align 4
  store i32 %7, ptr %5, align 4
  %8 = load i32, ptr %5, align 4
  %9 = and i32 %8, 1
  store i32 %9, ptr %3, align 4
  %10 = alloca i32, align 4
  store i32 1367572438, ptr %10, align 4
  br label %11

11:                                               ; preds = %1, %78
  %12 = load i32, ptr %10, align 4
  switch i32 %12, label %13 [
    i32 1367572438, label %14
    i32 -1606921101, label %18
    i32 605478433, label %21
    i32 61707517, label %24
    i32 1626327509, label %25
    i32 1629775455, label %29
    i32 879957278, label %34
    i32 1684104516, label %39
    i32 2138990305, label %44
    i32 1676569018, label %45
    i32 -222858904, label %48
    i32 680461358, label %51
    i32 -1928282851, label %55
    i32 743425413, label %59
    i32 2000015314, label %63
    i32 -906389340, label %66
    i32 113589690, label %69
    i32 582032103, label %72
    i32 526445444, label %75
  ]

13:                                               ; preds = %11
  br label %78

14:                                               ; preds = %11
  %15 = load volatile i32, ptr %3, align 4
  %16 = icmp ne i32 %15, 0
  %17 = select i1 %16, i32 -1606921101, i32 605478433
  store i32 %17, ptr %10, align 4
  br label %78

18:                                               ; preds = %11
  %19 = load i32, ptr %5, align 4
  %20 = add i32 %19, 4369
  store i32 %20, ptr %5, align 4
  store i32 61707517, ptr %10, align 4
  br label %78

21:                                               ; preds = %11
  %22 = load i32, ptr %5, align 4
  %23 = xor i32 %22, 8738
  store i32 %23, ptr %5, align 4
  store i32 61707517, ptr %10, align 4
  br label %78

24:                                               ; preds = %11
  store i32 0, ptr %6, align 4
  store i32 1626327509, ptr %10, align 4
  br label %78

25:                                               ; preds = %11
  %26 = load i32, ptr %6, align 4
  %27 = icmp ult i32 %26, 4
  %28 = select i1 %27, i32 1629775455, i32 -222858904
  store i32 %28, ptr %10, align 4
  br label %78

29:                                               ; preds = %11
  %30 = load i32, ptr %5, align 4
  %31 = and i32 %30, 256
  %32 = icmp ne i32 %31, 0
  %33 = select i1 %32, i32 879957278, i32 1684104516
  store i32 %33, ptr %10, align 4
  br label %78

34:                                               ; preds = %11
  %35 = load i32, ptr %6, align 4
  %36 = add i32 4096, %35
  %37 = load i32, ptr %5, align 4
  %38 = xor i32 %37, %36
  store i32 %38, ptr %5, align 4
  store i32 2138990305, ptr %10, align 4
  br label %78

39:                                               ; preds = %11
  %40 = load i32, ptr %6, align 4
  %41 = add i32 256, %40
  %42 = load i32, ptr %5, align 4
  %43 = add i32 %42, %41
  store i32 %43, ptr %5, align 4
  store i32 2138990305, ptr %10, align 4
  br label %78

44:                                               ; preds = %11
  store i32 1676569018, ptr %10, align 4
  br label %78

45:                                               ; preds = %11
  %46 = load i32, ptr %6, align 4
  %47 = add i32 %46, 1
  store i32 %47, ptr %6, align 4
  store i32 1626327509, ptr %10, align 4
  br label %78

48:                                               ; preds = %11
  %49 = load i32, ptr %5, align 4
  %50 = and i32 %49, 3
  store i32 %50, ptr %2, align 4
  store i32 680461358, ptr %10, align 4
  br label %78

51:                                               ; preds = %11
  %52 = load volatile i32, ptr %2, align 4
  %53 = icmp slt i32 %52, 1
  %54 = select i1 %53, i32 2000015314, i32 -1928282851
  store i32 %54, ptr %10, align 4
  br label %78

55:                                               ; preds = %11
  %56 = load volatile i32, ptr %2, align 4
  %57 = icmp slt i32 %56, 2
  %58 = select i1 %57, i32 -906389340, i32 743425413
  store i32 %58, ptr %10, align 4
  br label %78

59:                                               ; preds = %11
  %60 = load volatile i32, ptr %2, align 4
  %61 = icmp eq i32 %60, 2
  %62 = select i1 %61, i32 113589690, i32 582032103
  store i32 %62, ptr %10, align 4
  br label %78

63:                                               ; preds = %11
  %64 = load i32, ptr %5, align 4
  %65 = add i32 %64, 286331153
  store i32 %65, ptr %5, align 4
  store i32 526445444, ptr %10, align 4
  br label %78

66:                                               ; preds = %11
  %67 = load i32, ptr %5, align 4
  %68 = xor i32 %67, 572662306
  store i32 %68, ptr %5, align 4
  store i32 526445444, ptr %10, align 4
  br label %78

69:                                               ; preds = %11
  %70 = load i32, ptr %5, align 4
  %71 = sub i32 %70, 13107
  store i32 %71, ptr %5, align 4
  store i32 526445444, ptr %10, align 4
  br label %78

72:                                               ; preds = %11
  %73 = load i32, ptr %5, align 4
  %74 = add i32 %73, 17476
  store i32 %74, ptr %5, align 4
  store i32 526445444, ptr %10, align 4
  br label %78

75:                                               ; preds = %11
  %76 = load i32, ptr %5, align 4
  %77 = xor i32 %76, -889275714
  ret i32 %77

78:                                               ; preds = %72, %69, %66, %63, %59, %55, %51, %48, %45, %44, %39, %34, %29, %25, %24, %21, %18, %14, %13
  br label %11
}