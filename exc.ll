@test_type_0 = external constant i8*
@test_type_1 = external constant i8*
@.str = private unnamed_addr constant [12 x i8] c"function f!\00", align 1
@.str2 = private unnamed_addr constant [12 x i8] c"landing pad\00", align 1
@.str3 = private unnamed_addr constant [12 x i8] c"matched t0 \00", align 1

define i32 @f() personality i8* bitcast (i32 (...)* @my_personality to i8*) {
entry:
    %tmp_e_obj = alloca i8*
    %tmp_e_sel = alloca i32

    call i32 @puts(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str, i32 0, i32 0))
    invoke void @my_throw_exception(i64 0) noreturn
        to label %merge unwind label %exn
exn:
    %ret = landingpad { i8*, i32 }
            catch i8* bitcast (i8** @test_type_0 to i8*)
            catch i8* bitcast (i8** @test_type_1 to i8*)
    call i32 @puts(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str2, i32 0, i32 0))

    %tmp0 = extractvalue { i8*, i32 } %ret, 0
    store i8* %tmp0, i8** %tmp_e_obj
    %tmp1 = extractvalue { i8*, i32 } %ret, 1
    store i32 %tmp1, i32* %tmp_e_sel

    br label %catch_0
catch_0:
    %selected_0 = load i32, i32* %tmp_e_sel
    %target_sel_0 = call i32 @llvm.eh.typeid.for(i8* bitcast (i8** @test_type_0 to i8*)) nounwind
    %is_matched_0 = icmp eq i32 %selected_0, %target_sel_0

    br i1 %is_matched_0, label %matched_to_t0, label %not_matched_to_t0

matched_to_t0:
    call i32 @puts(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str3, i32 0, i32 0))
    br label %merge

not_matched_to_t0:
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
declare i32 @llvm.eh.typeid.for(i8*) #1
