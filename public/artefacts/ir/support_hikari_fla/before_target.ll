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
  store i32 %9, i32* %3, align 4
  %10 = alloca i32, align 4
  store i32 -1778888553, i32* %10, align 4
  br label %11

11:                                               ; preds = %1, %83
  %12 = load i32, i32* %10, align 4
  switch i32 %12, label %13 [
    i32 -1778888553, label %14
    i32 1926478384, label %18
    i32 1041077995, label %21
    i32 443419611, label %24
    i32 -728143123, label %25
    i32 1036658766, label %29
    i32 350389002, label %34
    i32 -965413862, label %39
    i32 -2050176392, label %44
    i32 -51044028, label %45
    i32 -2041382832, label %48
    i32 -1144296488, label %51
    i32 -1395527858, label %55
    i32 1925053676, label %59
    i32 1716698222, label %63
    i32 1487486812, label %67
    i32 -1488518707, label %70
    i32 -2116351983, label %73
    i32 -767861034, label %76
    i32 -970531858, label %77
    i32 1980942208, label %80
  ]

13:                                               ; preds = %11
  br label %83

14:                                               ; preds = %11
  %15 = load i32, i32* %3, align 4
  %16 = icmp ne i32 %15, 0
  %17 = select i1 %16, i32 1926478384, i32 1041077995
  store i32 %17, i32* %10, align 4
  br label %83

18:                                               ; preds = %11
  %19 = load i32, ptr %5, align 4
  %20 = add i32 %19, 4369
  store i32 %20, ptr %5, align 4
  store i32 443419611, i32* %10, align 4
  br label %83

21:                                               ; preds = %11
  %22 = load i32, ptr %5, align 4
  %23 = xor i32 %22, 8738
  store i32 %23, ptr %5, align 4
  store i32 443419611, i32* %10, align 4
  br label %83

24:                                               ; preds = %11
  store i32 0, ptr %6, align 4
  store i32 -728143123, i32* %10, align 4
  br label %83

25:                                               ; preds = %11
  %26 = load i32, ptr %6, align 4
  %27 = icmp ult i32 %26, 4
  %28 = select i1 %27, i32 1036658766, i32 -2041382832
  store i32 %28, i32* %10, align 4
  br label %83

29:                                               ; preds = %11
  %30 = load i32, ptr %5, align 4
  %31 = and i32 %30, 256
  %32 = icmp ne i32 %31, 0
  %33 = select i1 %32, i32 350389002, i32 -965413862
  store i32 %33, i32* %10, align 4
  br label %83

34:                                               ; preds = %11
  %35 = load i32, ptr %6, align 4
  %36 = add i32 4096, %35
  %37 = load i32, ptr %5, align 4
  %38 = xor i32 %37, %36
  store i32 %38, ptr %5, align 4
  store i32 -2050176392, i32* %10, align 4
  br label %83

39:                                               ; preds = %11
  %40 = load i32, ptr %6, align 4
  %41 = add i32 256, %40
  %42 = load i32, ptr %5, align 4
  %43 = add i32 %42, %41
  store i32 %43, ptr %5, align 4
  store i32 -2050176392, i32* %10, align 4
  br label %83

44:                                               ; preds = %11
  store i32 -51044028, i32* %10, align 4
  br label %83

45:                                               ; preds = %11
  %46 = load i32, ptr %6, align 4
  %47 = add i32 %46, 1
  store i32 %47, ptr %6, align 4
  store i32 -728143123, i32* %10, align 4
  br label %83

48:                                               ; preds = %11
  %49 = load i32, ptr %5, align 4
  %50 = and i32 %49, 3
  store i32 %50, i32* %2, align 4
  store i32 -1144296488, i32* %10, align 4
  br label %83

51:                                               ; preds = %11
  %52 = load i32, i32* %2, align 4
  %53 = icmp slt i32 %52, 1
  %54 = select i1 %53, i32 1716698222, i32 -1395527858
  store i32 %54, i32* %10, align 4
  br label %83

55:                                               ; preds = %11
  %56 = load i32, i32* %2, align 4
  %57 = icmp slt i32 %56, 2
  %58 = select i1 %57, i32 -1488518707, i32 1925053676
  store i32 %58, i32* %10, align 4
  br label %83

59:                                               ; preds = %11
  %60 = load i32, i32* %2, align 4
  %61 = icmp eq i32 %60, 2
  %62 = select i1 %61, i32 -2116351983, i32 -767861034
  store i32 %62, i32* %10, align 4
  br label %83

63:                                               ; preds = %11
  %64 = load i32, i32* %2, align 4
  %65 = icmp eq i32 %64, 0
  %66 = select i1 %65, i32 1487486812, i32 -767861034
  store i32 %66, i32* %10, align 4
  br label %83

67:                                               ; preds = %11
  %68 = load i32, ptr %5, align 4
  %69 = add i32 %68, 286331153
  store i32 %69, ptr %5, align 4
  store i32 1980942208, i32* %10, align 4
  br label %83

70:                                               ; preds = %11
  %71 = load i32, ptr %5, align 4
  %72 = xor i32 %71, 572662306
  store i32 %72, ptr %5, align 4
  store i32 1980942208, i32* %10, align 4
  br label %83

73:                                               ; preds = %11
  %74 = load i32, ptr %5, align 4
  %75 = sub i32 %74, 13107
  store i32 %75, ptr %5, align 4
  store i32 1980942208, i32* %10, align 4
  br label %83

76:                                               ; preds = %11
  store i32 -970531858, i32* %10, align 4
  br label %83

77:                                               ; preds = %11
  %78 = load i32, ptr %5, align 4
  %79 = add i32 %78, 17476
  store i32 %79, ptr %5, align 4
  store i32 1980942208, i32* %10, align 4
  br label %83

80:                                               ; preds = %11
  %81 = load i32, ptr %5, align 4
  %82 = xor i32 %81, -889275714
  ret i32 %82

83:                                               ; preds = %77, %76, %73, %70, %67, %63, %59, %55, %51, %48, %45, %44, %39, %34, %29, %25, %24, %21, %18, %14, %13
  br label %11
}