; ModuleID = 'throw.cpp'
source_filename = "throw.cpp"
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.12.0"

@_ZTIi = external constant i8*

; Function Attrs: ssp uwtable
define void @_Z1fv() #0 {
  %1 = call i8* @__cxa_allocate_exception(i64 4) #1
  %2 = bitcast i8* %1 to i32*
  store i32 1, i32* %2, align 8
  call void @__cxa_throw(i8* %1, i8* bitcast (i8** @_ZTIi to i8*), i8* null) #2
  unreachable
                                                  ; No predecessors!
  ret void
}

declare i8* @__cxa_allocate_exception(i64)

declare void @__cxa_throw(i8*, i8*, i8*)

attributes #0 = { ssp uwtable "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="core2" "target-features"="+cx16,+fxsr,+mmx,+sse,+sse2,+sse3,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind }
attributes #2 = { noreturn }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"PIC Level", i32 2}
!1 = !{!"clang version 3.9.1 (tags/RELEASE_391/final)"}
