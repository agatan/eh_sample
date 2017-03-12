@test_type_0 = external constant i8*
@test_type_1 = external constant i8*
@.str = private unnamed_addr constant [12 x i8] c"function f!\00", align 1
@.str2 = private unnamed_addr constant [12 x i8] c"landing pad\00", align 1
@.str3 = private unnamed_addr constant [12 x i8] c"matched t0 \00", align 1
@.str4 = private unnamed_addr constant [12 x i8] c"not matched\00", align 1

define i32 @f() personality i8* bitcast (i32 (...)* @my_personality to i8*) {
entry:
    call i32 @puts(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str, i32 0, i32 0))
    %selected_e_id = call i64 @select_exception_index()
    invoke void @my_throw_exception(i64 %selected_e_id) noreturn
        to label %merge unwind label %exn
exn:
    %ret = landingpad { i8*, i32 }
        cleanup
    call i32 @puts(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str2, i32 0, i32 0))

    %e_object = extractvalue { i8*, i32 } %ret, 0
    %e_typeid = extractvalue { i8*, i32 } %ret, 1

    br label %catch_0
catch_0:
    %is_matched_0 = icmp eq i32 0, %e_typeid

    br i1 %is_matched_0, label %matched_to_t0, label %not_matched_to_t0

matched_to_t0:
    call i32 @puts(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str3, i32 0, i32 0))
    br label %merge

not_matched_to_t0:
    call i32 @puts(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str4, i32 0, i32 0))
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
declare i64 @select_exception_index();
declare void @my_throw_exception(i64);
declare i32 @my_personality(...)
declare i32 @llvm.eh.typeid.for(i8*) #1
