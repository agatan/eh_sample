@.str = private unnamed_addr constant [12 x i8] c"function f!\00", align 1

define i32 @f() {
entry:
    ; call i32 @puts( i8* getelementptr inbounds ([12 x i8]* @.str, i32 0, i32 0) )
    call i32 @puts(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str, i32 0, i32 0))
    ret i32 0
}

define i32 @main() {
entry:
    call i32 @f()
    ret i32 0
}

declare i32 @puts(i8*)
