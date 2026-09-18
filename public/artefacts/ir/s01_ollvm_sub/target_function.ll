define dso_local dllexport i32 @demo_substitution(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca [8 x i32], align 16
  store i32 %0, ptr %2, align 4
  %4 = load i32, ptr %2, align 4
  %5 = add i32 %4, 115893687
  %6 = add i32 %5, 16843009
  %7 = sub i32 %6, 115893687
  %8 = add i32 %4, 16843009
  %9 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 0
  store volatile i32 %7, ptr %9, align 16
  %10 = load i32, ptr %2, align 4
  %11 = sub i32 %10, -2076646197
  %12 = add i32 %11, 33686018
  %13 = add i32 %12, -2076646197
  %14 = add i32 %10, 33686018
  %15 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 1
  store volatile i32 %13, ptr %15, align 4
  %16 = load i32, ptr %2, align 4
  %17 = sub i32 0, 50529027
  %18 = sub i32 %16, %17
  %19 = add i32 %16, 50529027
  %20 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 2
  store volatile i32 %18, ptr %20, align 8
  %21 = load i32, ptr %2, align 4
  %22 = sub i32 0, 67372036
  %23 = sub i32 %21, %22
  %24 = add i32 %21, 67372036
  %25 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 3
  store volatile i32 %23, ptr %25, align 4
  %26 = load i32, ptr %2, align 4
  %27 = sub i32 0, %26
  %28 = sub i32 0, 84215045
  %29 = add i32 %27, %28
  %30 = sub i32 0, %29
  %31 = add i32 %26, 84215045
  %32 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 4
  store volatile i32 %30, ptr %32, align 16
  %33 = load i32, ptr %2, align 4
  %34 = sub i32 %33, -1244396371
  %35 = add i32 %34, 101058054
  %36 = add i32 %35, -1244396371
  %37 = add i32 %33, 101058054
  %38 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 5
  store volatile i32 %36, ptr %38, align 4
  %39 = load i32, ptr %2, align 4
  %40 = sub i32 %39, -1866409818
  %41 = add i32 %40, 117901063
  %42 = add i32 %41, -1866409818
  %43 = add i32 %39, 117901063
  %44 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 6
  store volatile i32 %42, ptr %44, align 8
  %45 = load i32, ptr %2, align 4
  %46 = add i32 %45, 162601411
  %47 = add i32 %46, 134744072
  %48 = sub i32 %47, 162601411
  %49 = add i32 %45, 134744072
  %50 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 7
  store volatile i32 %48, ptr %50, align 4
  %51 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 0
  %52 = load volatile i32, ptr %51, align 16
  %53 = xor i32 %52, -1
  %54 = and i32 792306821, %53
  %55 = xor i32 792306821, -1
  %56 = and i32 %52, %55
  %57 = xor i32 305419896, -1
  %58 = and i32 %57, 792306821
  %59 = and i32 305419896, %55
  %60 = or i32 %54, %56
  %61 = or i32 %58, %59
  %62 = xor i32 %60, %61
  %63 = xor i32 %52, 305419896
  store volatile i32 %62, ptr %51, align 16
  %64 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 1
  %65 = load volatile i32, ptr %64, align 4
  %66 = xor i32 %65, -1
  %67 = and i32 305419896, %66
  %68 = xor i32 305419896, -1
  %69 = and i32 %65, %68
  %70 = or i32 %67, %69
  %71 = xor i32 %65, 305419896
  store volatile i32 %70, ptr %64, align 4
  %72 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 2
  %73 = load volatile i32, ptr %72, align 8
  %74 = xor i32 %73, -1
  %75 = and i32 305419896, %74
  %76 = xor i32 305419896, -1
  %77 = and i32 %73, %76
  %78 = or i32 %75, %77
  %79 = xor i32 %73, 305419896
  store volatile i32 %78, ptr %72, align 8
  %80 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 3
  %81 = load volatile i32, ptr %80, align 4
  %82 = xor i32 %81, -1
  %83 = and i32 305419896, %82
  %84 = xor i32 305419896, -1
  %85 = and i32 %81, %84
  %86 = or i32 %83, %85
  %87 = xor i32 %81, 305419896
  store volatile i32 %86, ptr %80, align 4
  %88 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 4
  %89 = load volatile i32, ptr %88, align 16
  %90 = xor i32 %89, -1
  %91 = and i32 217622974, %90
  %92 = xor i32 217622974, -1
  %93 = and i32 %89, %92
  %94 = xor i32 305419896, -1
  %95 = and i32 %94, 217622974
  %96 = and i32 305419896, %92
  %97 = or i32 %91, %93
  %98 = or i32 %95, %96
  %99 = xor i32 %97, %98
  %100 = xor i32 %89, 305419896
  store volatile i32 %99, ptr %88, align 16
  %101 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 5
  %102 = load volatile i32, ptr %101, align 4
  %103 = xor i32 %102, -1
  %104 = and i32 822135996, %103
  %105 = xor i32 822135996, -1
  %106 = and i32 %102, %105
  %107 = xor i32 305419896, -1
  %108 = and i32 %107, 822135996
  %109 = and i32 305419896, %105
  %110 = or i32 %104, %106
  %111 = or i32 %108, %109
  %112 = xor i32 %110, %111
  %113 = xor i32 %102, 305419896
  store volatile i32 %112, ptr %101, align 4
  %114 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 6
  %115 = load volatile i32, ptr %114, align 8
  %116 = xor i32 %115, -1
  %117 = and i32 -1337692733, %116
  %118 = xor i32 -1337692733, -1
  %119 = and i32 %115, %118
  %120 = xor i32 305419896, -1
  %121 = and i32 %120, -1337692733
  %122 = and i32 305419896, %118
  %123 = or i32 %117, %119
  %124 = or i32 %121, %122
  %125 = xor i32 %123, %124
  %126 = xor i32 %115, 305419896
  store volatile i32 %125, ptr %114, align 8
  %127 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 7
  %128 = load volatile i32, ptr %127, align 4
  %129 = xor i32 %128, -1
  %130 = and i32 305419896, %129
  %131 = xor i32 305419896, -1
  %132 = and i32 %128, %131
  %133 = or i32 %130, %132
  %134 = xor i32 %128, 305419896
  store volatile i32 %133, ptr %127, align 4
  %135 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 0
  %136 = load volatile i32, ptr %135, align 16
  %137 = sub i32 %136, 257601360
  %138 = add i32 %137, 4919
  %139 = add i32 %138, 257601360
  %140 = add i32 %136, 4919
  store volatile i32 %139, ptr %135, align 16
  %141 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 1
  %142 = load volatile i32, ptr %141, align 4
  %143 = add i32 %142, 609959148
  %144 = add i32 %143, 4919
  %145 = sub i32 %144, 609959148
  %146 = add i32 %142, 4919
  store volatile i32 %145, ptr %141, align 4
  %147 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 2
  %148 = load volatile i32, ptr %147, align 8
  %149 = add i32 %148, -2124207412
  %150 = add i32 %149, 4919
  %151 = sub i32 %150, -2124207412
  %152 = add i32 %148, 4919
  store volatile i32 %151, ptr %147, align 8
  %153 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 3
  %154 = load volatile i32, ptr %153, align 4
  %155 = sub i32 0, %154
  %156 = sub i32 0, 4919
  %157 = add i32 %155, %156
  %158 = sub i32 0, %157
  %159 = add i32 %154, 4919
  store volatile i32 %158, ptr %153, align 4
  %160 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 4
  %161 = load volatile i32, ptr %160, align 16
  %162 = sub i32 %161, 821329771
  %163 = add i32 %162, 4919
  %164 = add i32 %163, 821329771
  %165 = add i32 %161, 4919
  store volatile i32 %164, ptr %160, align 16
  %166 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 5
  %167 = load volatile i32, ptr %166, align 4
  %168 = sub i32 0, 4919
  %169 = sub i32 %167, %168
  %170 = add i32 %167, 4919
  store volatile i32 %169, ptr %166, align 4
  %171 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 6
  %172 = load volatile i32, ptr %171, align 8
  %173 = sub i32 0, %172
  %174 = sub i32 0, 4919
  %175 = add i32 %173, %174
  %176 = sub i32 0, %175
  %177 = add i32 %172, 4919
  store volatile i32 %176, ptr %171, align 8
  %178 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 7
  %179 = load volatile i32, ptr %178, align 4
  %180 = sub i32 0, %179
  %181 = sub i32 0, 4919
  %182 = add i32 %180, %181
  %183 = sub i32 0, %182
  %184 = add i32 %179, 4919
  store volatile i32 %183, ptr %178, align 4
  %185 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 0
  %186 = load volatile i32, ptr %185, align 16
  %187 = add i32 %186, 1025155060
  %188 = sub i32 %187, 4369
  %189 = sub i32 %188, 1025155060
  %190 = sub i32 %186, 4369
  store volatile i32 %189, ptr %185, align 16
  %191 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 1
  %192 = load volatile i32, ptr %191, align 4
  %193 = add i32 %192, 573594774
  %194 = sub i32 %193, 4369
  %195 = sub i32 %194, 573594774
  %196 = sub i32 %192, 4369
  store volatile i32 %195, ptr %191, align 4
  %197 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 2
  %198 = load volatile i32, ptr %197, align 8
  %199 = sub i32 0, 4369
  %200 = add i32 %198, %199
  %201 = sub i32 %198, 4369
  store volatile i32 %200, ptr %197, align 8
  %202 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 3
  %203 = load volatile i32, ptr %202, align 4
  %204 = add i32 %203, -1173223581
  %205 = sub i32 %204, 4369
  %206 = sub i32 %205, -1173223581
  %207 = sub i32 %203, 4369
  store volatile i32 %206, ptr %202, align 4
  %208 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 4
  %209 = load volatile i32, ptr %208, align 16
  %210 = add i32 %209, -81039370
  %211 = sub i32 %210, 4369
  %212 = sub i32 %211, -81039370
  %213 = sub i32 %209, 4369
  store volatile i32 %212, ptr %208, align 16
  %214 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 5
  %215 = load volatile i32, ptr %214, align 4
  %216 = add i32 %215, -1194432479
  %217 = sub i32 %216, 4369
  %218 = sub i32 %217, -1194432479
  %219 = sub i32 %215, 4369
  store volatile i32 %218, ptr %214, align 4
  %220 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 6
  %221 = load volatile i32, ptr %220, align 8
  %222 = sub i32 %221, 1177492334
  %223 = sub i32 %222, 4369
  %224 = add i32 %223, 1177492334
  %225 = sub i32 %221, 4369
  store volatile i32 %224, ptr %220, align 8
  %226 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 7
  %227 = load volatile i32, ptr %226, align 4
  %228 = sub i32 %227, 8554378
  %229 = sub i32 %228, 4369
  %230 = add i32 %229, 8554378
  %231 = sub i32 %227, 4369
  store volatile i32 %230, ptr %226, align 4
  %232 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 0
  %233 = load volatile i32, ptr %232, align 16
  %234 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 1
  %235 = load volatile i32, ptr %234, align 4
  %236 = xor i32 %233, -1
  %237 = and i32 -1734007491, %236
  %238 = xor i32 -1734007491, -1
  %239 = and i32 %233, %238
  %240 = xor i32 %235, -1
  %241 = and i32 %240, -1734007491
  %242 = and i32 %235, %238
  %243 = or i32 %237, %239
  %244 = or i32 %241, %242
  %245 = xor i32 %243, %244
  %246 = xor i32 %233, %235
  %247 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 2
  %248 = load volatile i32, ptr %247, align 8
  %249 = xor i32 %245, -1
  %250 = and i32 %248, %249
  %251 = xor i32 %248, -1
  %252 = and i32 %245, %251
  %253 = or i32 %250, %252
  %254 = xor i32 %245, %248
  %255 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 3
  %256 = load volatile i32, ptr %255, align 4
  %257 = xor i32 %253, -1
  %258 = and i32 -1702841694, %257
  %259 = xor i32 -1702841694, -1
  %260 = and i32 %253, %259
  %261 = xor i32 %256, -1
  %262 = and i32 %261, -1702841694
  %263 = and i32 %256, %259
  %264 = or i32 %258, %260
  %265 = or i32 %262, %263
  %266 = xor i32 %264, %265
  %267 = xor i32 %253, %256
  %268 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 4
  %269 = load volatile i32, ptr %268, align 16
  %270 = xor i32 %266, -1
  %271 = and i32 %269, %270
  %272 = xor i32 %269, -1
  %273 = and i32 %266, %272
  %274 = or i32 %271, %273
  %275 = xor i32 %266, %269
  %276 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 5
  %277 = load volatile i32, ptr %276, align 4
  %278 = xor i32 %274, -1
  %279 = and i32 %277, %278
  %280 = xor i32 %277, -1
  %281 = and i32 %274, %280
  %282 = or i32 %279, %281
  %283 = xor i32 %274, %277
  %284 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 6
  %285 = load volatile i32, ptr %284, align 8
  %286 = xor i32 %282, -1
  %287 = and i32 1201192903, %286
  %288 = xor i32 1201192903, -1
  %289 = and i32 %282, %288
  %290 = xor i32 %285, -1
  %291 = and i32 %290, 1201192903
  %292 = and i32 %285, %288
  %293 = or i32 %287, %289
  %294 = or i32 %291, %292
  %295 = xor i32 %293, %294
  %296 = xor i32 %282, %285
  %297 = getelementptr inbounds [8 x i32], ptr %3, i64 0, i64 7
  %298 = load volatile i32, ptr %297, align 4
  %299 = xor i32 %295, -1
  %300 = and i32 %298, %299
  %301 = xor i32 %298, -1
  %302 = and i32 %295, %301
  %303 = or i32 %300, %302
  %304 = xor i32 %295, %298
  ret i32 %303
}

