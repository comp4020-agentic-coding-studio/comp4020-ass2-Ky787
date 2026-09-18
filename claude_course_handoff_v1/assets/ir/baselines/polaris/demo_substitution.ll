define dso_local dllexport i32 @demo_substitution(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca [8 x i32], align 16
  store i32 %0, ptr %2, align 4
  %4 = load i32, ptr %2, align 4
  %5 = add i32 %4, 16843009
  %6 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 0
  store volatile i32 %5, ptr %6, align 16
  %7 = load i32, ptr %2, align 4
  %8 = add i32 %7, 33686018
  %9 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 1
  store volatile i32 %8, ptr %9, align 4
  %10 = load i32, ptr %2, align 4
  %11 = add i32 %10, 50529027
  %12 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 2
  store volatile i32 %11, ptr %12, align 8
  %13 = load i32, ptr %2, align 4
  %14 = add i32 %13, 67372036
  %15 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 3
  store volatile i32 %14, ptr %15, align 4
  %16 = load i32, ptr %2, align 4
  %17 = add i32 %16, 84215045
  %18 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 4
  store volatile i32 %17, ptr %18, align 16
  %19 = load i32, ptr %2, align 4
  %20 = add i32 %19, 101058054
  %21 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 5
  store volatile i32 %20, ptr %21, align 4
  %22 = load i32, ptr %2, align 4
  %23 = add i32 %22, 117901063
  %24 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 6
  store volatile i32 %23, ptr %24, align 8
  %25 = load i32, ptr %2, align 4
  %26 = add i32 %25, 134744072
  %27 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 7
  store volatile i32 %26, ptr %27, align 4
  %28 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 0
  %29 = load volatile i32, ptr %28, align 16
  %30 = xor i32 %29, 305419896
  store volatile i32 %30, ptr %28, align 16
  %31 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 1
  %32 = load volatile i32, ptr %31, align 4
  %33 = xor i32 %32, 305419896
  store volatile i32 %33, ptr %31, align 4
  %34 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 2
  %35 = load volatile i32, ptr %34, align 8
  %36 = xor i32 %35, 305419896
  store volatile i32 %36, ptr %34, align 8
  %37 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 3
  %38 = load volatile i32, ptr %37, align 4
  %39 = xor i32 %38, 305419896
  store volatile i32 %39, ptr %37, align 4
  %40 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 4
  %41 = load volatile i32, ptr %40, align 16
  %42 = xor i32 %41, 305419896
  store volatile i32 %42, ptr %40, align 16
  %43 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 5
  %44 = load volatile i32, ptr %43, align 4
  %45 = xor i32 %44, 305419896
  store volatile i32 %45, ptr %43, align 4
  %46 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 6
  %47 = load volatile i32, ptr %46, align 8
  %48 = xor i32 %47, 305419896
  store volatile i32 %48, ptr %46, align 8
  %49 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 7
  %50 = load volatile i32, ptr %49, align 4
  %51 = xor i32 %50, 305419896
  store volatile i32 %51, ptr %49, align 4
  %52 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 0
  %53 = load volatile i32, ptr %52, align 16
  %54 = add i32 %53, 4919
  store volatile i32 %54, ptr %52, align 16
  %55 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 1
  %56 = load volatile i32, ptr %55, align 4
  %57 = add i32 %56, 4919
  store volatile i32 %57, ptr %55, align 4
  %58 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 2
  %59 = load volatile i32, ptr %58, align 8
  %60 = add i32 %59, 4919
  store volatile i32 %60, ptr %58, align 8
  %61 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 3
  %62 = load volatile i32, ptr %61, align 4
  %63 = add i32 %62, 4919
  store volatile i32 %63, ptr %61, align 4
  %64 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 4
  %65 = load volatile i32, ptr %64, align 16
  %66 = add i32 %65, 4919
  store volatile i32 %66, ptr %64, align 16
  %67 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 5
  %68 = load volatile i32, ptr %67, align 4
  %69 = add i32 %68, 4919
  store volatile i32 %69, ptr %67, align 4
  %70 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 6
  %71 = load volatile i32, ptr %70, align 8
  %72 = add i32 %71, 4919
  store volatile i32 %72, ptr %70, align 8
  %73 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 7
  %74 = load volatile i32, ptr %73, align 4
  %75 = add i32 %74, 4919
  store volatile i32 %75, ptr %73, align 4
  %76 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 0
  %77 = load volatile i32, ptr %76, align 16
  %78 = sub i32 %77, 4369
  store volatile i32 %78, ptr %76, align 16
  %79 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 1
  %80 = load volatile i32, ptr %79, align 4
  %81 = sub i32 %80, 4369
  store volatile i32 %81, ptr %79, align 4
  %82 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 2
  %83 = load volatile i32, ptr %82, align 8
  %84 = sub i32 %83, 4369
  store volatile i32 %84, ptr %82, align 8
  %85 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 3
  %86 = load volatile i32, ptr %85, align 4
  %87 = sub i32 %86, 4369
  store volatile i32 %87, ptr %85, align 4
  %88 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 4
  %89 = load volatile i32, ptr %88, align 16
  %90 = sub i32 %89, 4369
  store volatile i32 %90, ptr %88, align 16
  %91 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 5
  %92 = load volatile i32, ptr %91, align 4
  %93 = sub i32 %92, 4369
  store volatile i32 %93, ptr %91, align 4
  %94 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 6
  %95 = load volatile i32, ptr %94, align 8
  %96 = sub i32 %95, 4369
  store volatile i32 %96, ptr %94, align 8
  %97 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 7
  %98 = load volatile i32, ptr %97, align 4
  %99 = sub i32 %98, 4369
  store volatile i32 %99, ptr %97, align 4
  %100 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 0
  %101 = load volatile i32, ptr %100, align 16
  %102 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 1
  %103 = load volatile i32, ptr %102, align 4
  %104 = xor i32 %101, %103
  %105 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 2
  %106 = load volatile i32, ptr %105, align 8
  %107 = xor i32 %104, %106
  %108 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 3
  %109 = load volatile i32, ptr %108, align 4
  %110 = xor i32 %107, %109
  %111 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 4
  %112 = load volatile i32, ptr %111, align 16
  %113 = xor i32 %110, %112
  %114 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 5
  %115 = load volatile i32, ptr %114, align 4
  %116 = xor i32 %113, %115
  %117 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 6
  %118 = load volatile i32, ptr %117, align 8
  %119 = xor i32 %116, %118
  %120 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 7
  %121 = load volatile i32, ptr %120, align 4
  %122 = xor i32 %119, %121
  ret i32 %122
}

