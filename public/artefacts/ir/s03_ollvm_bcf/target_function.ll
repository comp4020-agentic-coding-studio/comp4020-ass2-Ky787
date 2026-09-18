define dso_local dllexport i32 @demo_bogus_control_flow(i32 noundef %0, i32 noundef %1) #0 {
  %3 = load i32, ptr @x.16, align 4
  %4 = load i32, ptr @y.17, align 4
  %5 = sub i32 %3, 1
  %6 = mul i32 %3, %5
  %7 = urem i32 %6, 2
  %8 = icmp eq i32 %7, 0
  %9 = icmp slt i32 %4, 10
  %10 = or i1 %8, %9
  br i1 %10, label %11, label %237

11:                                               ; preds = %2, %237
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  store i32 %1, ptr %12, align 4
  store i32 %0, ptr %13, align 4
  store i32 286331153, ptr %14, align 4
  %15 = load i32, ptr %13, align 4
  %16 = icmp eq i32 %15, 4919
  %17 = load i32, ptr @x.16, align 4
  %18 = load i32, ptr @y.17, align 4
  %19 = sub i32 %17, 1
  %20 = mul i32 %17, %19
  %21 = urem i32 %20, 2
  %22 = icmp eq i32 %21, 0
  %23 = icmp slt i32 %18, 10
  %24 = or i1 %22, %23
  br i1 %24, label %25, label %237

25:                                               ; preds = %11
  br i1 %16, label %26, label %47

26:                                               ; preds = %25
  %27 = load i32, ptr @x.16, align 4
  %28 = load i32, ptr @y.17, align 4
  %29 = sub i32 %27, 1
  %30 = mul i32 %27, %29
  %31 = urem i32 %30, 2
  %32 = icmp eq i32 %31, 0
  %33 = icmp slt i32 %28, 10
  %34 = or i1 %32, %33
  br i1 %34, label %35, label %243

35:                                               ; preds = %26, %243
  %36 = load i32, ptr %14, align 4
  %37 = xor i32 %36, 572662306
  store i32 %37, ptr %14, align 4
  %38 = load i32, ptr @x.16, align 4
  %39 = load i32, ptr @y.17, align 4
  %40 = sub i32 %38, 1
  %41 = mul i32 %38, %40
  %42 = urem i32 %41, 2
  %43 = icmp eq i32 %42, 0
  %44 = icmp slt i32 %39, 10
  %45 = or i1 %43, %44
  br i1 %45, label %46, label %243

46:                                               ; preds = %35
  br label %68

47:                                               ; preds = %25
  %48 = load i32, ptr @x.16, align 4
  %49 = load i32, ptr @y.17, align 4
  %50 = sub i32 %48, 1
  %51 = mul i32 %48, %50
  %52 = urem i32 %51, 2
  %53 = icmp eq i32 %52, 0
  %54 = icmp slt i32 %49, 10
  %55 = or i1 %53, %54
  br i1 %55, label %56, label %253

56:                                               ; preds = %47, %253
  %57 = load i32, ptr %14, align 4
  %58 = add i32 %57, 13107
  store i32 %58, ptr %14, align 4
  %59 = load i32, ptr @x.16, align 4
  %60 = load i32, ptr @y.17, align 4
  %61 = sub i32 %59, 1
  %62 = mul i32 %59, %61
  %63 = urem i32 %62, 2
  %64 = icmp eq i32 %63, 0
  %65 = icmp slt i32 %60, 10
  %66 = or i1 %64, %65
  br i1 %66, label %67, label %253

67:                                               ; preds = %56
  br label %68

68:                                               ; preds = %67, %46
  %69 = load i32, ptr @x.16, align 4
  %70 = load i32, ptr @y.17, align 4
  %71 = sub i32 %69, 1
  %72 = mul i32 %69, %71
  %73 = urem i32 %72, 2
  %74 = icmp eq i32 %73, 0
  %75 = icmp slt i32 %70, 10
  %76 = or i1 %74, %75
  br i1 %76, label %77, label %263

77:                                               ; preds = %68, %263
  %78 = load i32, ptr %12, align 4
  %79 = icmp ugt i32 %78, 305397760
  %80 = load i32, ptr @x.16, align 4
  %81 = load i32, ptr @y.17, align 4
  %82 = sub i32 %80, 1
  %83 = mul i32 %80, %82
  %84 = urem i32 %83, 2
  %85 = icmp eq i32 %84, 0
  %86 = icmp slt i32 %81, 10
  %87 = or i1 %85, %86
  br i1 %87, label %88, label %263

88:                                               ; preds = %77
  br i1 %79, label %89, label %110

89:                                               ; preds = %88
  %90 = load i32, ptr @x.16, align 4
  %91 = load i32, ptr @y.17, align 4
  %92 = sub i32 %90, 1
  %93 = mul i32 %90, %92
  %94 = urem i32 %93, 2
  %95 = icmp eq i32 %94, 0
  %96 = icmp slt i32 %91, 10
  %97 = or i1 %95, %96
  br i1 %97, label %98, label %266

98:                                               ; preds = %89, %266
  %99 = load i32, ptr %14, align 4
  %100 = add i32 %99, 17476
  store i32 %100, ptr %14, align 4
  %101 = load i32, ptr @x.16, align 4
  %102 = load i32, ptr @y.17, align 4
  %103 = sub i32 %101, 1
  %104 = mul i32 %101, %103
  %105 = urem i32 %104, 2
  %106 = icmp eq i32 %105, 0
  %107 = icmp slt i32 %102, 10
  %108 = or i1 %106, %107
  br i1 %108, label %109, label %266

109:                                              ; preds = %98
  br label %110

110:                                              ; preds = %109, %88
  %111 = load i32, ptr @x.16, align 4
  %112 = load i32, ptr @y.17, align 4
  %113 = sub i32 %111, 1
  %114 = mul i32 %111, %113
  %115 = urem i32 %114, 2
  %116 = icmp eq i32 %115, 0
  %117 = icmp slt i32 %112, 10
  %118 = or i1 %116, %117
  br i1 %118, label %119, label %277

119:                                              ; preds = %110, %277
  %120 = load i32, ptr %13, align 4
  %121 = and i32 %120, 255
  %122 = icmp eq i32 %121, 55
  %123 = load i32, ptr @x.16, align 4
  %124 = load i32, ptr @y.17, align 4
  %125 = sub i32 %123, 1
  %126 = mul i32 %123, %125
  %127 = urem i32 %126, 2
  %128 = icmp eq i32 %127, 0
  %129 = icmp slt i32 %124, 10
  %130 = or i1 %128, %129
  br i1 %130, label %131, label %277

131:                                              ; preds = %119
  br i1 %122, label %132, label %153

132:                                              ; preds = %131
  %133 = load i32, ptr @x.16, align 4
  %134 = load i32, ptr @y.17, align 4
  %135 = sub i32 %133, 1
  %136 = mul i32 %133, %135
  %137 = urem i32 %136, 2
  %138 = icmp eq i32 %137, 0
  %139 = icmp slt i32 %134, 10
  %140 = or i1 %138, %139
  br i1 %140, label %141, label %296

141:                                              ; preds = %132, %296
  %142 = load i32, ptr %14, align 4
  %143 = xor i32 %142, 1431655765
  store i32 %143, ptr %14, align 4
  %144 = load i32, ptr @x.16, align 4
  %145 = load i32, ptr @y.17, align 4
  %146 = sub i32 %144, 1
  %147 = mul i32 %144, %146
  %148 = urem i32 %147, 2
  %149 = icmp eq i32 %148, 0
  %150 = icmp slt i32 %145, 10
  %151 = or i1 %149, %150
  br i1 %151, label %152, label %296

152:                                              ; preds = %141
  br label %153

153:                                              ; preds = %152, %131
  %154 = load i32, ptr @x.16, align 4
  %155 = load i32, ptr @y.17, align 4
  %156 = sub i32 %154, 1
  %157 = mul i32 %154, %156
  %158 = urem i32 %157, 2
  %159 = icmp eq i32 %158, 0
  %160 = icmp slt i32 %155, 10
  %161 = or i1 %159, %160
  br i1 %161, label %162, label %306

162:                                              ; preds = %153, %306
  %163 = load i32, ptr %12, align 4
  %164 = and i32 %163, 1
  %165 = icmp eq i32 %164, 0
  %166 = load i32, ptr @x.16, align 4
  %167 = load i32, ptr @y.17, align 4
  %168 = sub i32 %166, 1
  %169 = mul i32 %166, %168
  %170 = urem i32 %169, 2
  %171 = icmp eq i32 %170, 0
  %172 = icmp slt i32 %167, 10
  %173 = or i1 %171, %172
  br i1 %173, label %174, label %306

174:                                              ; preds = %162
  br i1 %165, label %175, label %196

175:                                              ; preds = %174
  %176 = load i32, ptr @x.16, align 4
  %177 = load i32, ptr @y.17, align 4
  %178 = sub i32 %176, 1
  %179 = mul i32 %176, %178
  %180 = urem i32 %179, 2
  %181 = icmp eq i32 %180, 0
  %182 = icmp slt i32 %177, 10
  %183 = or i1 %181, %182
  br i1 %183, label %184, label %314

184:                                              ; preds = %175, %314
  %185 = load i32, ptr %14, align 4
  %186 = sub i32 %185, 26214
  store i32 %186, ptr %14, align 4
  %187 = load i32, ptr @x.16, align 4
  %188 = load i32, ptr @y.17, align 4
  %189 = sub i32 %187, 1
  %190 = mul i32 %187, %189
  %191 = urem i32 %190, 2
  %192 = icmp eq i32 %191, 0
  %193 = icmp slt i32 %188, 10
  %194 = or i1 %192, %193
  br i1 %194, label %195, label %314

195:                                              ; preds = %184
  br label %217

196:                                              ; preds = %174
  %197 = load i32, ptr @x.16, align 4
  %198 = load i32, ptr @y.17, align 4
  %199 = sub i32 %197, 1
  %200 = mul i32 %197, %199
  %201 = urem i32 %200, 2
  %202 = icmp eq i32 %201, 0
  %203 = icmp slt i32 %198, 10
  %204 = or i1 %202, %203
  br i1 %204, label %205, label %320

205:                                              ; preds = %196, %320
  %206 = load i32, ptr %14, align 4
  %207 = add i32 %206, 30583
  store i32 %207, ptr %14, align 4
  %208 = load i32, ptr @x.16, align 4
  %209 = load i32, ptr @y.17, align 4
  %210 = sub i32 %208, 1
  %211 = mul i32 %208, %210
  %212 = urem i32 %211, 2
  %213 = icmp eq i32 %212, 0
  %214 = icmp slt i32 %209, 10
  %215 = or i1 %213, %214
  br i1 %215, label %216, label %320

216:                                              ; preds = %205
  br label %217

217:                                              ; preds = %216, %195
  %218 = load i32, ptr @x.16, align 4
  %219 = load i32, ptr @y.17, align 4
  %220 = sub i32 %218, 1
  %221 = mul i32 %218, %220
  %222 = urem i32 %221, 2
  %223 = icmp eq i32 %222, 0
  %224 = icmp slt i32 %219, 10
  %225 = or i1 %223, %224
  br i1 %225, label %226, label %325

226:                                              ; preds = %217, %325
  %227 = load i32, ptr %14, align 4
  %228 = load i32, ptr @x.16, align 4
  %229 = load i32, ptr @y.17, align 4
  %230 = sub i32 %228, 1
  %231 = mul i32 %228, %230
  %232 = urem i32 %231, 2
  %233 = icmp eq i32 %232, 0
  %234 = icmp slt i32 %229, 10
  %235 = or i1 %233, %234
  br i1 %235, label %236, label %325

236:                                              ; preds = %226
  ret i32 %227

237:                                              ; preds = %11, %2
  %238 = alloca i32, align 4
  %239 = alloca i32, align 4
  %240 = alloca i32, align 4
  store i32 %1, ptr %238, align 4
  store i32 %0, ptr %239, align 4
  store i32 286331153, ptr %240, align 4
  %241 = load i32, ptr %239, align 4
  %242 = icmp eq i32 %241, 4919
  br label %11

243:                                              ; preds = %35, %26
  %244 = load i32, ptr %14, align 4
  %245 = sub i32 0, %244
  %246 = add i32 %245, 572662306
  %247 = shl i32 %244, 572662306
  %248 = sub i32 0, %244
  %249 = add i32 %248, 572662306
  %250 = sub i32 %244, 572662306
  %251 = mul i32 %250, 572662306
  %252 = xor i32 %244, 572662306
  store i32 %252, ptr %14, align 4
  br label %35

253:                                              ; preds = %56, %47
  %254 = load i32, ptr %14, align 4
  %255 = sub i32 0, %254
  %256 = add i32 %255, 13107
  %257 = sub i32 %254, 13107
  %258 = mul i32 %257, 13107
  %259 = sub i32 0, %254
  %260 = add i32 %259, 13107
  %261 = shl i32 %254, 13107
  %262 = add i32 %254, 13107
  store i32 %262, ptr %14, align 4
  br label %56

263:                                              ; preds = %77, %68
  %264 = load i32, ptr %12, align 4
  %265 = icmp ugt i32 %264, 305397760
  br label %77

266:                                              ; preds = %98, %89
  %267 = load i32, ptr %14, align 4
  %268 = sub i32 0, %267
  %269 = add i32 %268, 17476
  %270 = sub i32 0, %267
  %271 = add i32 %270, 17476
  %272 = sub i32 0, %267
  %273 = add i32 %272, 17476
  %274 = shl i32 %267, 17476
  %275 = shl i32 %267, 17476
  %276 = add i32 %267, 17476
  store i32 %276, ptr %14, align 4
  br label %98

277:                                              ; preds = %119, %110
  %278 = load i32, ptr %13, align 4
  %279 = sub i32 0, %278
  %280 = add i32 %279, 255
  %281 = sub i32 %278, 255
  %282 = mul i32 %281, 255
  %283 = sub i32 %278, 255
  %284 = mul i32 %283, 255
  %285 = sub i32 %278, 255
  %286 = mul i32 %285, 255
  %287 = shl i32 %278, 255
  %288 = sub i32 %278, 255
  %289 = mul i32 %288, 255
  %290 = sub i32 0, %278
  %291 = add i32 %290, 255
  %292 = sub i32 %278, 255
  %293 = mul i32 %292, 255
  %294 = and i32 %278, 255
  %295 = icmp eq i32 %294, 55
  br label %119

296:                                              ; preds = %141, %132
  %297 = load i32, ptr %14, align 4
  %298 = sub i32 %297, 1431655765
  %299 = mul i32 %298, 1431655765
  %300 = sub i32 0, %297
  %301 = add i32 %300, 1431655765
  %302 = shl i32 %297, 1431655765
  %303 = sub i32 %297, 1431655765
  %304 = mul i32 %303, 1431655765
  %305 = xor i32 %297, 1431655765
  store i32 %305, ptr %14, align 4
  br label %141

306:                                              ; preds = %162, %153
  %307 = load i32, ptr %12, align 4
  %308 = sub i32 0, %307
  %309 = add i32 %308, 1
  %310 = sub i32 %307, 1
  %311 = mul i32 %310, 1
  %312 = and i32 %307, 1
  %313 = icmp eq i32 %312, 0
  br label %162

314:                                              ; preds = %184, %175
  %315 = load i32, ptr %14, align 4
  %316 = shl i32 %315, 26214
  %317 = sub i32 %315, 26214
  %318 = mul i32 %317, 26214
  %319 = sub i32 %315, 26214
  store i32 %319, ptr %14, align 4
  br label %184

320:                                              ; preds = %205, %196
  %321 = load i32, ptr %14, align 4
  %322 = shl i32 %321, 30583
  %323 = shl i32 %321, 30583
  %324 = add i32 %321, 30583
  store i32 %324, ptr %14, align 4
  br label %205

325:                                              ; preds = %226, %217
  %326 = load i32, ptr %14, align 4
  br label %226
}

