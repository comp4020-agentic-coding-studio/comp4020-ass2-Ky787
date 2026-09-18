define dso_local dllexport i32 @demo_flattening(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store i32 %0, ptr %3, align 4
  %6 = load i32, ptr %3, align 4
  store i32 %6, ptr %4, align 4
  %7 = load i32, ptr %4, align 4
  %8 = and i32 %7, 1
  store i32 %8, ptr %2, align 4
  %9 = alloca i32, align 4
  store i32 7719, ptr %9, align 4
  br label %10

10:                                               ; preds = %1, %65
  %11 = load i32, ptr %9, align 4
  switch i32 %11, label %12 [
    i32 7719, label %13
    i32 2437, label %17
    i32 11797, label %20
    i32 32285, label %23
    i32 30612, label %24
    i32 28100, label %28
    i32 281, label %33
    i32 15921, label %38
    i32 26285, label %43
    i32 14680, label %44
    i32 31891, label %47
    i32 25906, label %50
    i32 1323, label %53
    i32 2240, label %56
    i32 32278, label %59
    i32 590, label %62
  ]

12:                                               ; preds = %10
  br label %65

13:                                               ; preds = %10
  %14 = load volatile i32, ptr %2, align 4
  %15 = icmp ne i32 %14, 0
  %16 = select i1 %15, i32 2437, i32 11797
  store i32 %16, ptr %9, align 4
  br label %65

17:                                               ; preds = %10
  %18 = load i32, ptr %4, align 4
  %19 = add i32 %18, 4369
  store i32 %19, ptr %4, align 4
  store i32 32285, ptr %9, align 4
  br label %65

20:                                               ; preds = %10
  %21 = load i32, ptr %4, align 4
  %22 = xor i32 %21, 8738
  store i32 %22, ptr %4, align 4
  store i32 32285, ptr %9, align 4
  br label %65

23:                                               ; preds = %10
  store i32 0, ptr %5, align 4
  store i32 30612, ptr %9, align 4
  br label %65

24:                                               ; preds = %10
  %25 = load i32, ptr %5, align 4
  %26 = icmp ult i32 %25, 4
  %27 = select i1 %26, i32 28100, i32 31891
  store i32 %27, ptr %9, align 4
  br label %65

28:                                               ; preds = %10
  %29 = load i32, ptr %4, align 4
  %30 = and i32 %29, 256
  %31 = icmp ne i32 %30, 0
  %32 = select i1 %31, i32 281, i32 15921
  store i32 %32, ptr %9, align 4
  br label %65

33:                                               ; preds = %10
  %34 = load i32, ptr %5, align 4
  %35 = add i32 4096, %34
  %36 = load i32, ptr %4, align 4
  %37 = xor i32 %36, %35
  store i32 %37, ptr %4, align 4
  store i32 26285, ptr %9, align 4
  br label %65

38:                                               ; preds = %10
  %39 = load i32, ptr %5, align 4
  %40 = add i32 256, %39
  %41 = load i32, ptr %4, align 4
  %42 = add i32 %41, %40
  store i32 %42, ptr %4, align 4
  store i32 26285, ptr %9, align 4
  br label %65

43:                                               ; preds = %10
  store i32 14680, ptr %9, align 4
  br label %65

44:                                               ; preds = %10
  %45 = load i32, ptr %5, align 4
  %46 = add i32 %45, 1
  store i32 %46, ptr %5, align 4
  store i32 30612, ptr %9, align 4
  br label %65

47:                                               ; preds = %10
  %48 = load i32, ptr %4, align 4
  %49 = and i32 %48, 3
  switch i32 %49, label %59 [
    i32 0, label %50
    i32 1, label %53
    i32 2, label %56
  ]

50:                                               ; preds = %10, %47
  %51 = load i32, ptr %4, align 4
  %52 = add i32 %51, 286331153
  store i32 %52, ptr %4, align 4
  store i32 590, ptr %9, align 4
  br label %65

53:                                               ; preds = %10, %47
  %54 = load i32, ptr %4, align 4
  %55 = xor i32 %54, 572662306
  store i32 %55, ptr %4, align 4
  store i32 590, ptr %9, align 4
  br label %65

56:                                               ; preds = %10, %47
  %57 = load i32, ptr %4, align 4
  %58 = sub i32 %57, 13107
  store i32 %58, ptr %4, align 4
  store i32 590, ptr %9, align 4
  br label %65

59:                                               ; preds = %10, %47
  %60 = load i32, ptr %4, align 4
  %61 = add i32 %60, 17476
  store i32 %61, ptr %4, align 4
  store i32 590, ptr %9, align 4
  br label %65

62:                                               ; preds = %10
  %63 = load i32, ptr %4, align 4
  %64 = xor i32 %63, -889275714
  ret i32 %64

65:                                               ; preds = %59, %56, %53, %50, %44, %43, %38, %33, %28, %24, %23, %20, %17, %13, %12
  br label %10
}