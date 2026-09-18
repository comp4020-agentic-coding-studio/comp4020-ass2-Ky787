define dso_local dllexport i32 @demo_bogus_control_flow(i32 noundef %0, i32 noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store i32 %1, ptr %3, align 4
  store i32 %0, ptr %4, align 4
  store i32 286331153, ptr %5, align 4
  %6 = load i32, ptr %4, align 4
  %7 = icmp eq i32 %6, 4919
  br i1 %7, label %8, label %29

8:                                                ; preds = %2
  %9 = load i32, ptr @x, align 4
  %10 = load i32, ptr @y, align 4
  %11 = icmp slt i32 %10, 10
  %12 = add i32 %9, 1
  %13 = mul i32 %12, %9
  %14 = urem i32 %13, 2
  %15 = icmp eq i32 %14, 0
  %16 = or i1 %11, %15
  br i1 %16, label %17, label %183

17:                                               ; preds = %183, %8
  %18 = load i32, ptr %5, align 4
  %19 = xor i32 %18, 572662306
  store i32 %19, ptr %5, align 4
  %20 = load i32, ptr @x.2, align 4
  %21 = load i32, ptr @y.3, align 4
  %22 = icmp slt i32 %21, 10
  %23 = add i32 %20, 1
  %24 = mul i32 %23, %20
  %25 = urem i32 %24, 2
  %26 = icmp eq i32 %25, 0
  %27 = or i1 %22, %26
  br i1 %27, label %28, label %183

28:                                               ; preds = %17
  br label %50

29:                                               ; preds = %2
  %30 = load i32, ptr @x.4, align 4
  %31 = load i32, ptr @y.5, align 4
  %32 = icmp slt i32 %31, 10
  %33 = add i32 %30, 1
  %34 = mul i32 %33, %30
  %35 = urem i32 %34, 2
  %36 = icmp eq i32 %35, 0
  %37 = or i1 %32, %36
  br i1 %37, label %38, label %186

38:                                               ; preds = %186, %29
  %39 = load i32, ptr %5, align 4
  %40 = add i32 %39, 13107
  store i32 %40, ptr %5, align 4
  %41 = load i32, ptr @x.6, align 4
  %42 = load i32, ptr @y.7, align 4
  %43 = icmp slt i32 %42, 10
  %44 = add i32 %41, 1
  %45 = mul i32 %44, %41
  %46 = urem i32 %45, 2
  %47 = icmp eq i32 %46, 0
  %48 = or i1 %43, %47
  br i1 %48, label %49, label %186

49:                                               ; preds = %38
  br label %50

50:                                               ; preds = %49, %28
  %51 = load i32, ptr @x.8, align 4
  %52 = load i32, ptr @y.9, align 4
  %53 = icmp slt i32 %52, 10
  %54 = add i32 %51, 1
  %55 = mul i32 %54, %51
  %56 = urem i32 %55, 2
  %57 = icmp eq i32 %56, 0
  %58 = or i1 %53, %57
  br i1 %58, label %59, label %189

59:                                               ; preds = %189, %50
  %60 = load i32, ptr %3, align 4
  %61 = icmp ugt i32 %60, 305397760
  %62 = load i32, ptr @x.10, align 4
  %63 = load i32, ptr @y.11, align 4
  %64 = icmp slt i32 %63, 10
  %65 = add i32 %62, 1
  %66 = mul i32 %65, %62
  %67 = urem i32 %66, 2
  %68 = icmp eq i32 %67, 0
  %69 = or i1 %64, %68
  br i1 %69, label %70, label %189

70:                                               ; preds = %59
  br i1 %61, label %71, label %74

71:                                               ; preds = %70
  %72 = load i32, ptr %5, align 4
  %73 = add i32 %72, 17476
  store i32 %73, ptr %5, align 4
  br label %74

74:                                               ; preds = %71, %70
  %75 = load i32, ptr @x.12, align 4
  %76 = load i32, ptr @y.13, align 4
  %77 = icmp slt i32 %76, 10
  %78 = add i32 %75, 1
  %79 = mul i32 %78, %75
  %80 = urem i32 %79, 2
  %81 = icmp eq i32 %80, 0
  %82 = or i1 %77, %81
  br i1 %82, label %83, label %192

83:                                               ; preds = %192, %74
  %84 = load i32, ptr %4, align 4
  %85 = and i32 %84, 255
  %86 = icmp eq i32 %85, 55
  %87 = load i32, ptr @x.14, align 4
  %88 = load i32, ptr @y.15, align 4
  %89 = icmp slt i32 %88, 10
  %90 = add i32 %87, 1
  %91 = mul i32 %90, %87
  %92 = urem i32 %91, 2
  %93 = icmp eq i32 %92, 0
  %94 = or i1 %89, %93
  br i1 %94, label %95, label %192

95:                                               ; preds = %83
  br i1 %86, label %96, label %99

96:                                               ; preds = %95
  %97 = load i32, ptr %5, align 4
  %98 = xor i32 %97, 1431655765
  store i32 %98, ptr %5, align 4
  br label %99

99:                                               ; preds = %96, %95
  %100 = load i32, ptr @x.16, align 4
  %101 = load i32, ptr @y.17, align 4
  %102 = icmp slt i32 %101, 10
  %103 = add i32 %100, 1
  %104 = mul i32 %103, %100
  %105 = urem i32 %104, 2
  %106 = icmp eq i32 %105, 0
  %107 = or i1 %102, %106
  br i1 %107, label %108, label %196

108:                                              ; preds = %196, %99
  %109 = load i32, ptr %3, align 4
  %110 = and i32 %109, 1
  %111 = icmp eq i32 %110, 0
  %112 = load i32, ptr @x.18, align 4
  %113 = load i32, ptr @y.19, align 4
  %114 = icmp slt i32 %113, 10
  %115 = add i32 %112, 1
  %116 = mul i32 %115, %112
  %117 = urem i32 %116, 2
  %118 = icmp eq i32 %117, 0
  %119 = or i1 %114, %118
  br i1 %119, label %120, label %196

120:                                              ; preds = %108
  br i1 %111, label %121, label %142

121:                                              ; preds = %120
  %122 = load i32, ptr @x.20, align 4
  %123 = load i32, ptr @y.21, align 4
  %124 = icmp slt i32 %123, 10
  %125 = add i32 %122, 1
  %126 = mul i32 %125, %122
  %127 = urem i32 %126, 2
  %128 = icmp eq i32 %127, 0
  %129 = or i1 %124, %128
  br i1 %129, label %130, label %200

130:                                              ; preds = %200, %121
  %131 = load i32, ptr %5, align 4
  %132 = sub i32 %131, 26214
  store i32 %132, ptr %5, align 4
  %133 = load i32, ptr @x.22, align 4
  %134 = load i32, ptr @y.23, align 4
  %135 = icmp slt i32 %134, 10
  %136 = add i32 %133, 1
  %137 = mul i32 %136, %133
  %138 = urem i32 %137, 2
  %139 = icmp eq i32 %138, 0
  %140 = or i1 %135, %139
  br i1 %140, label %141, label %200

141:                                              ; preds = %130
  br label %163

142:                                              ; preds = %120
  %143 = load i32, ptr @x.24, align 4
  %144 = load i32, ptr @y.25, align 4
  %145 = icmp slt i32 %144, 10
  %146 = add i32 %143, 1
  %147 = mul i32 %146, %143
  %148 = urem i32 %147, 2
  %149 = icmp eq i32 %148, 0
  %150 = or i1 %145, %149
  br i1 %150, label %151, label %203

151:                                              ; preds = %203, %142
  %152 = load i32, ptr %5, align 4
  %153 = add i32 %152, 30583
  store i32 %153, ptr %5, align 4
  %154 = load i32, ptr @x.26, align 4
  %155 = load i32, ptr @y.27, align 4
  %156 = icmp slt i32 %155, 10
  %157 = add i32 %154, 1
  %158 = mul i32 %157, %154
  %159 = urem i32 %158, 2
  %160 = icmp eq i32 %159, 0
  %161 = or i1 %156, %160
  br i1 %161, label %162, label %203

162:                                              ; preds = %151
  br label %163

163:                                              ; preds = %162, %141
  %164 = load i32, ptr @x.28, align 4
  %165 = load i32, ptr @y.29, align 4
  %166 = icmp slt i32 %165, 10
  %167 = add i32 %164, 1
  %168 = mul i32 %167, %164
  %169 = urem i32 %168, 2
  %170 = icmp eq i32 %169, 0
  %171 = or i1 %166, %170
  br i1 %171, label %172, label %206

172:                                              ; preds = %206, %163
  %173 = load i32, ptr %5, align 4
  %174 = load i32, ptr @x.30, align 4
  %175 = load i32, ptr @y.31, align 4
  %176 = icmp slt i32 %175, 10
  %177 = add i32 %174, 1
  %178 = mul i32 %177, %174
  %179 = urem i32 %178, 2
  %180 = icmp eq i32 %179, 0
  %181 = or i1 %176, %180
  br i1 %181, label %182, label %206

182:                                              ; preds = %172
  ret i32 %173

183:                                              ; preds = %17, %8
  %184 = load i32, ptr %5, align 4
  %185 = xor i32 %184, 572662306
  store i32 %185, ptr %5, align 4
  br label %17

186:                                              ; preds = %38, %29
  %187 = load i32, ptr %5, align 4
  %188 = add i32 %187, 13107
  store i32 %188, ptr %5, align 4
  br label %38

189:                                              ; preds = %59, %50
  %190 = load i32, ptr %3, align 4
  %191 = icmp ugt i32 %190, 305397760
  br label %59

192:                                              ; preds = %83, %74
  %193 = load i32, ptr %4, align 4
  %194 = and i32 %193, 255
  %195 = icmp eq i32 %194, 55
  br label %83

196:                                              ; preds = %108, %99
  %197 = load i32, ptr %3, align 4
  %198 = and i32 %197, 1
  %199 = icmp eq i32 %198, 0
  br label %108

200:                                              ; preds = %130, %121
  %201 = load i32, ptr %5, align 4
  %202 = sub i32 %201, 26214
  store i32 %202, ptr %5, align 4
  br label %130

203:                                              ; preds = %151, %142
  %204 = load i32, ptr %5, align 4
  %205 = add i32 %204, 30583
  store i32 %205, ptr %5, align 4
  br label %151

206:                                              ; preds = %172, %163
  %207 = load i32, ptr %5, align 4
  br label %172
}

