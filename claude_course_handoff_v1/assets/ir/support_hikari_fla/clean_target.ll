define dso_local dllexport i32 @demo_flattening(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  %5 = load i32, ptr %2, align 4
  store i32 %5, ptr %3, align 4
  %6 = load i32, ptr %3, align 4
  %7 = and i32 %6, 1
  %8 = icmp ne i32 %7, 0
  br i1 %8, label %9, label %12

9:                                                ; preds = %1
  %10 = load i32, ptr %3, align 4
  %11 = add i32 %10, 4369
  store i32 %11, ptr %3, align 4
  br label %15

12:                                               ; preds = %1
  %13 = load i32, ptr %3, align 4
  %14 = xor i32 %13, 8738
  store i32 %14, ptr %3, align 4
  br label %15

15:                                               ; preds = %12, %9
  store i32 0, ptr %4, align 4
  br label %16

16:                                               ; preds = %34, %15
  %17 = load i32, ptr %4, align 4
  %18 = icmp ult i32 %17, 4
  br i1 %18, label %19, label %37

19:                                               ; preds = %16
  %20 = load i32, ptr %3, align 4
  %21 = and i32 %20, 256
  %22 = icmp ne i32 %21, 0
  br i1 %22, label %23, label %28

23:                                               ; preds = %19
  %24 = load i32, ptr %4, align 4
  %25 = add i32 4096, %24
  %26 = load i32, ptr %3, align 4
  %27 = xor i32 %26, %25
  store i32 %27, ptr %3, align 4
  br label %33

28:                                               ; preds = %19
  %29 = load i32, ptr %4, align 4
  %30 = add i32 256, %29
  %31 = load i32, ptr %3, align 4
  %32 = add i32 %31, %30
  store i32 %32, ptr %3, align 4
  br label %33

33:                                               ; preds = %28, %23
  br label %34

34:                                               ; preds = %33
  %35 = load i32, ptr %4, align 4
  %36 = add i32 %35, 1
  store i32 %36, ptr %4, align 4
  br label %16, !llvm.loop !5

37:                                               ; preds = %16
  %38 = load i32, ptr %3, align 4
  %39 = and i32 %38, 3
  switch i32 %39, label %49 [
    i32 0, label %40
    i32 1, label %43
    i32 2, label %46
  ]

40:                                               ; preds = %37
  %41 = load i32, ptr %3, align 4
  %42 = add i32 %41, 286331153
  store i32 %42, ptr %3, align 4
  br label %52

43:                                               ; preds = %37
  %44 = load i32, ptr %3, align 4
  %45 = xor i32 %44, 572662306
  store i32 %45, ptr %3, align 4
  br label %52

46:                                               ; preds = %37
  %47 = load i32, ptr %3, align 4
  %48 = sub i32 %47, 13107
  store i32 %48, ptr %3, align 4
  br label %52

49:                                               ; preds = %37
  %50 = load i32, ptr %3, align 4
  %51 = add i32 %50, 17476
  store i32 %51, ptr %3, align 4
  br label %52

52:                                               ; preds = %49, %46, %43, %40
  %53 = load i32, ptr %3, align 4
  %54 = xor i32 %53, -889275714
  ret i32 %54
}