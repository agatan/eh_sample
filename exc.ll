@test_type_0 = external constant i8*
@test_type_1 = external constant i8*
@.str = private unnamed_addr constant [12 x i8] c"function f!\00", align 1

define i32 @f() personality i8* bitcast (i32 (...)* @my_personality to i8*) {
entry:
    call i32 @puts(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str, i32 0, i32 0))
    invoke void @my_throw_exception(i64 0) noreturn
        to label %merge unwind label %exn
exn:
    %ret = landingpad { i8*, i32 }
            catch i8* bitcast (i8** @test_type_0 to i8*)
            catch i8* bitcast (i8** @test_type_1 to i8*)
    br label %merge
merge:
    ret i32 0
}

define i32 @main() {
entry:
    call i32 @f()
    %m = call i8* @my_alloc_exception(i64 4);
    store i8 3, i8* %m
    %r = load i8, i8* %m
    %sr = sext i8 %r to i32
    ret i32 %sr
}

declare i32 @puts(i8*)
declare i8* @my_alloc_exception(i64);
declare void @my_throw_exception(i64);
declare i32 @my_personality(...)
