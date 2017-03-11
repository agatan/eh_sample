; ModuleID = 'catch.cpp'
source_filename = "catch.cpp"
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.12.0"

@_ZTIi = external constant i8*
@_ZTId = external constant i8*

; Function Attrs: ssp uwtable
define void @_Z1fv() #0 personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
  %1 = alloca i8*
  %2 = alloca i32
  %3 = alloca double, align 8
  %4 = alloca i32, align 4
  %5 = call i8* @__cxa_allocate_exception(i64 4) #3
  %6 = bitcast i8* %5 to i32*
  store i32 1, i32* %6, align 8
  invoke void @__cxa_throw(i8* %5, i8* bitcast (i8** @_ZTIi to i8*), i8* null) #4
          to label %45 unwind label %7

; <label>:7:                                      ; preds = %0
  ; TypeInfo int とか TypeInfo double を catch する langindpad をつくる
  %8 = landingpad { i8*, i32 }
          catch i8* bitcast (i8** @_ZTIi to i8*)
          catch i8* bitcast (i8** @_ZTId to i8*)
  ; %9 は 例外オブジェクトへのポインタ
  %9 = extractvalue { i8*, i32 } %8, 0
  store i8* %9, i8** %1, align 8
  ; %10 は selector value (?)
  %10 = extractvalue { i8*, i32 } %8, 1
  store i32 %10, i32* %2, align 4
  br label %11

; <label>:11:                                     ; preds = %7
  %12 = load i32, i32* %2, align 4
  ; @_ZTIi は int のランタイム型情報
  ; でも crystal はこのへんは使っていないぽい？
  %13 = call i32 @llvm.eh.typeid.for(i8* bitcast (i8** @_ZTIi to i8*)) #3
  %14 = icmp eq i32 %12, %13
  br i1 %14, label %15, label %23

; <label>:15:                                     ; preds = %11
  %16 = load i8*, i8** %1, align 8
  %17 = call i8* @__cxa_begin_catch(i8* %16) #3
  %18 = bitcast i8* %17 to i32*
  %19 = load i32, i32* %18, align 4
  store i32 %19, i32* %4, align 4
  %20 = load i32, i32* %4, align 4
  invoke void @_Z4exiti(i32 %20)
          to label %21 unwind label %36

; <label>:21:                                     ; preds = %15
  call void @__cxa_end_catch() #3
  br label %22

; <label>:22:                                     ; preds = %21, %31
  ret void

; <label>:23:                                     ; preds = %11
  %24 = call i32 @llvm.eh.typeid.for(i8* bitcast (i8** @_ZTId to i8*)) #3
  %25 = icmp eq i32 %12, %24
  br i1 %25, label %26, label %40

; <label>:26:                                     ; preds = %23
  %27 = load i8*, i8** %1, align 8
  %28 = call i8* @__cxa_begin_catch(i8* %27) #3
  %29 = bitcast i8* %28 to double*
  %30 = load double, double* %29, align 8
  store double %30, double* %3, align 8
  invoke void @_Z4exiti(i32 10000)
          to label %31 unwind label %32

; <label>:31:                                     ; preds = %26
  call void @__cxa_end_catch() #3
  br label %22

; <label>:32:                                     ; preds = %26
  %33 = landingpad { i8*, i32 }
          cleanup
  %34 = extractvalue { i8*, i32 } %33, 0
  store i8* %34, i8** %1, align 8
  %35 = extractvalue { i8*, i32 } %33, 1
  store i32 %35, i32* %2, align 4
  call void @__cxa_end_catch() #3
  br label %40

; <label>:36:                                     ; preds = %15
  %37 = landingpad { i8*, i32 }
          cleanup
  %38 = extractvalue { i8*, i32 } %37, 0
  store i8* %38, i8** %1, align 8
  %39 = extractvalue { i8*, i32 } %37, 1
  store i32 %39, i32* %2, align 4
  call void @__cxa_end_catch() #3
  br label %40

; <label>:40:                                     ; preds = %36, %32, %23
  %41 = load i8*, i8** %1, align 8
  %42 = load i32, i32* %2, align 4
  %43 = insertvalue { i8*, i32 } undef, i8* %41, 0
  %44 = insertvalue { i8*, i32 } %43, i32 %42, 1
  resume { i8*, i32 } %44

; <label>:45:                                     ; preds = %0
  unreachable
}

declare i8* @__cxa_allocate_exception(i64)

declare void @__cxa_throw(i8*, i8*, i8*)

declare i32 @__gxx_personality_v0(...)

; Function Attrs: nounwind readnone
declare i32 @llvm.eh.typeid.for(i8*) #1

declare i8* @__cxa_begin_catch(i8*)

declare void @_Z4exiti(i32) #2

declare void @__cxa_end_catch()

attributes #0 = { ssp uwtable "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="core2" "target-features"="+cx16,+fxsr,+mmx,+sse,+sse2,+sse3,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
attributes #2 = { "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="core2" "target-features"="+cx16,+fxsr,+mmx,+sse,+sse2,+sse3,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }
attributes #4 = { noreturn }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"PIC Level", i32 2}
!1 = !{!"clang version 3.9.1 (tags/RELEASE_391/final)"}
