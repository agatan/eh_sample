; ModuleID = 'panic.cgu-0.rs'
source_filename = "panic.cgu-0.rs"
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-darwin"

%str_slice = type { i8*, i64 }
%"core::any::TypeId" = type { i64 }
%"unwind::libunwind::_Unwind_Exception" = type { i64, void (i32, %"unwind::libunwind::_Unwind_Exception"*)*, [6 x i64] }
%"unwind::libunwind::_Unwind_Context" = type {}

@vtable.0 = internal unnamed_addr constant { void (i8*)*, i64, i64, i64 (%str_slice*)* } { void (i8*)* @_ZN4drop17h0340bc9370ba6b76E, i64 16, i64 8, i64 (%str_slice*)* @"_ZN36_$LT$T$u20$as$u20$core..any..Any$GT$11get_type_id17he7670e7786c854d9E" }, align 8
@str.1 = internal constant [0 x i8] zeroinitializer
@str.2 = internal constant [10 x i8] c"./panic.rs"
@_ZN5panic1f10_FILE_LINE17hcc0f71eda0057eadE = internal constant { %str_slice, i32, [4 x i8] } { %str_slice { i8* getelementptr inbounds ([10 x i8], [10 x i8]* @str.2, i32 0, i32 0), i64 10 }, i32 2, [4 x i8] undef }, align 8

; Function Attrs: uwtable
define internal i64 @"_ZN36_$LT$T$u20$as$u20$core..any..Any$GT$11get_type_id17he7670e7786c854d9E"(%str_slice* noalias readonly dereferenceable(16)) unnamed_addr #0 {
entry-block:
  %abi_cast = alloca i64
  %_0 = alloca %"core::any::TypeId"
  br label %start

start:                                            ; preds = %entry-block
  %1 = call i64 @_ZN4core3any6TypeId2of17h5049bf402bd810daE()
  store i64 %1, i64* %abi_cast
  %2 = bitcast %"core::any::TypeId"* %_0 to i8*
  %3 = bitcast i64* %abi_cast to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %2, i8* %3, i64 8, i32 8, i1 false)
  br label %bb1

bb1:                                              ; preds = %start
  %4 = bitcast %"core::any::TypeId"* %_0 to i64*
  %5 = load i64, i64* %4, align 8
  ret i64 %5
}

; Function Attrs: cold noinline noreturn uwtable
define internal void @_ZN3std9panicking11begin_panic17h24314fc258983c1aE(i8* noalias nonnull readonly, i64, { %str_slice, i32 }* noalias readonly dereferenceable(24)) unnamed_addr #1 personality i32 (i32, i32, i64, %"unwind::libunwind::_Unwind_Exception"*, %"unwind::libunwind::_Unwind_Context"*)* @rust_eh_personality {
entry-block:
  %personalityslot = alloca { i8*, i32 }
  br label %start

start:                                            ; preds = %entry-block
  %3 = invoke i8* @_ZN5alloc4heap15exchange_malloc17hb66c562281343ee9E(i64 16, i64 8)
          to label %"_ZN35_$LT$alloc..boxed..Box$LT$T$GT$$GT$3new17hd6143b18950386c1E.exit" unwind label %cleanup

"_ZN35_$LT$alloc..boxed..Box$LT$T$GT$$GT$3new17hd6143b18950386c1E.exit": ; preds = %start
  %4 = bitcast i8* %3 to %str_slice*
  %5 = getelementptr inbounds %str_slice, %str_slice* %4, i32 0, i32 0
  store i8* %0, i8** %5, !noalias !1
  %6 = getelementptr inbounds %str_slice, %str_slice* %4, i32 0, i32 1
  store i64 %1, i64* %6
  br label %bb2

bb1:                                              ; preds = %cleanup
  %7 = load { i8*, i32 }, { i8*, i32 }* %personalityslot
  resume { i8*, i32 } %7

bb2:                                              ; preds = %"_ZN35_$LT$alloc..boxed..Box$LT$T$GT$$GT$3new17hd6143b18950386c1E.exit"
  %8 = bitcast %str_slice* %4 to i8*
  invoke void @_ZN3std9panicking20rust_panic_with_hook17h8943f907023b7818E(i8* noalias nonnull %8, void (i8*)** nonnull getelementptr inbounds ({ void (i8*)*, i64, i64, i64 (%str_slice*)* }, { void (i8*)*, i64, i64, i64 (%str_slice*)* }* @vtable.0, i32 0, i32 0), { %str_slice, i32 }* noalias readonly dereferenceable(24) %2)
          to label %unreachable unwind label %cleanup

cleanup:                                          ; preds = %start, %bb2
  %9 = landingpad { i8*, i32 }
          cleanup
  store { i8*, i32 } %9, { i8*, i32 }* %personalityslot
  br label %bb1

unreachable:                                      ; preds = %bb2
  unreachable
}

; Function Attrs: uwtable
define internal i64 @_ZN4core3any6TypeId2of17h5049bf402bd810daE() unnamed_addr #0 {
entry-block:
  %tmp_ret = alloca i64
  %_0 = alloca %"core::any::TypeId"
  br label %start

start:                                            ; preds = %entry-block
  store i64 4721040525823384027, i64* %tmp_ret
  %0 = load i64, i64* %tmp_ret
  br label %bb1

bb1:                                              ; preds = %start
  %1 = getelementptr inbounds %"core::any::TypeId", %"core::any::TypeId"* %_0, i32 0, i32 0
  store i64 %0, i64* %1
  %2 = bitcast %"core::any::TypeId"* %_0 to i64*
  %3 = load i64, i64* %2, align 8
  ret i64 %3
}

; Function Attrs: inlinehint uwtable
define internal zeroext i1 @"_ZN4core3ptr31_$LT$impl$u20$$BP$mut$u20$T$GT$7is_null17he1169d7891b0858cE"(i8*) unnamed_addr #2 {
entry-block:
  br label %start

start:                                            ; preds = %entry-block
  %1 = call i8* @_ZN4core3ptr8null_mut17h3dea8d00207e7e09E()
  br label %bb1

bb1:                                              ; preds = %start
  %2 = icmp eq i8* %0, %1
  ret i1 %2
}

; Function Attrs: inlinehint uwtable
define internal i8* @_ZN4core3ptr8null_mut17h3dea8d00207e7e09E() unnamed_addr #2 {
entry-block:
  br label %start

start:                                            ; preds = %entry-block
  ret i8* null
}

define internal void @_ZN4drop17h0340bc9370ba6b76E(i8*) unnamed_addr #3 {
entry-block:
  ret void
}

; Function Attrs: inlinehint uwtable
define internal i8* @_ZN5alloc4heap15exchange_malloc17hb66c562281343ee9E(i64, i64) unnamed_addr #2 {
entry-block:
  %_10 = alloca {}
  %_0 = alloca i8*
  br label %start

start:                                            ; preds = %entry-block
  %2 = icmp eq i64 %0, 0
  br i1 %2, label %bb1, label %bb2

bb1:                                              ; preds = %start
  store i8* inttoptr (i64 1 to i8*), i8** %_0
  br label %bb7

bb2:                                              ; preds = %start
  %3 = call i8* @_ZN5alloc4heap8allocate17h5933fa6bbdae9d89E(i64 %0, i64 %1)
  br label %bb3

bb3:                                              ; preds = %bb2
  %4 = call zeroext i1 @"_ZN4core3ptr31_$LT$impl$u20$$BP$mut$u20$T$GT$7is_null17he1169d7891b0858cE"(i8* %3)
  br label %bb4

bb4:                                              ; preds = %bb3
  br i1 %4, label %bb5, label %bb6

bb5:                                              ; preds = %bb4
  call void @_ZN5alloc3oom3oom17h0d80157e147c2376E()
  unreachable

bb6:                                              ; preds = %bb4
  store i8* %3, i8** %_0
  br label %bb7

bb7:                                              ; preds = %bb1, %bb6
  %5 = load i8*, i8** %_0
  ret i8* %5
}

; Function Attrs: inlinehint uwtable
define internal i8* @_ZN5alloc4heap8allocate17h5933fa6bbdae9d89E(i64, i64) unnamed_addr #2 {
entry-block:
  br label %start

start:                                            ; preds = %entry-block
  br label %bb1

bb1:                                              ; preds = %start
  %2 = call i8* @__rust_allocate(i64 %0, i64 %1)
  br label %bb2

bb2:                                              ; preds = %bb1
  ret i8* %2
}

; Function Attrs: uwtable
define internal void @_ZN5panic1f17h2c4cb65ca5620285E() unnamed_addr #0 {
entry-block:
  br label %start

start:                                            ; preds = %entry-block
  call void @_ZN3std9panicking11begin_panic17h24314fc258983c1aE(i8* noalias nonnull readonly getelementptr inbounds ([0 x i8], [0 x i8]* @str.1, i32 0, i32 0), i64 0, { %str_slice, i32 }* noalias readonly dereferenceable(24) bitcast ({ %str_slice, i32, [4 x i8] }* @_ZN5panic1f10_FILE_LINE17hcc0f71eda0057eadE to { %str_slice, i32 }*))
  unreachable
}

; Function Attrs: uwtable
define internal void @_ZN5panic4main17hb9924e956a885844E() unnamed_addr #0 {
entry-block:
  %_0 = alloca {}
  br label %start

start:                                            ; preds = %entry-block
  call void @_ZN5panic1f17h2c4cb65ca5620285E()
  br label %bb1

bb1:                                              ; preds = %start
  ret void
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i32, i1) #4

; Function Attrs: nounwind
declare i32 @rust_eh_personality(i32, i32, i64, %"unwind::libunwind::_Unwind_Exception"*, %"unwind::libunwind::_Unwind_Context"*) unnamed_addr #5

; Function Attrs: cold noinline noreturn
declare void @_ZN3std9panicking20rust_panic_with_hook17h8943f907023b7818E(i8* noalias nonnull, void (i8*)** nonnull, { %str_slice, i32 }* noalias readonly dereferenceable(24)) unnamed_addr #6

; Function Attrs: cold noinline noreturn
declare void @_ZN5alloc3oom3oom17h0d80157e147c2376E() unnamed_addr #6

; Function Attrs: nounwind
declare noalias i8* @__rust_allocate(i64, i64) unnamed_addr #5

define i64 @main(i64, i8**) unnamed_addr #3 {
top:
  %2 = call i64 @_ZN3std2rt10lang_start17h3242da5422f8b0a3E(i8* bitcast (void ()* @_ZN5panic4main17hb9924e956a885844E to i8*), i64 %0, i8** %1)
  ret i64 %2
}

declare i64 @_ZN3std2rt10lang_start17h3242da5422f8b0a3E(i8*, i64, i8**) unnamed_addr #3

attributes #0 = { uwtable "no-frame-pointer-elim"="true" }
attributes #1 = { cold noinline noreturn uwtable "no-frame-pointer-elim"="true" }
attributes #2 = { inlinehint uwtable "no-frame-pointer-elim"="true" }
attributes #3 = { "no-frame-pointer-elim"="true" }
attributes #4 = { argmemonly nounwind }
attributes #5 = { nounwind "no-frame-pointer-elim"="true" }
attributes #6 = { cold noinline noreturn "no-frame-pointer-elim"="true" }

!llvm.module.flags = !{!0}

!0 = !{i32 1, !"PIE Level", i32 2}
!1 = !{!2}
!2 = distinct !{!2, !3, !"_ZN35_$LT$alloc..boxed..Box$LT$T$GT$$GT$3new17hd6143b18950386c1E: argument 0"}
!3 = distinct !{!3, !"_ZN35_$LT$alloc..boxed..Box$LT$T$GT$$GT$3new17hd6143b18950386c1E"}
