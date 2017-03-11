SRCS := dwarf.cpp runtime.cpp
OBJS := $(SRCS:%.cpp=%.o)

LIB := libmincrt.a
BIN := exc

all: $(BIN)

run: $(BIN)
	./$(BIN)

$(BIN): $(LIB) exc.ll
	llc exc.ll
	clang++ -L. exc.s -lmincrt -o $(BIN)

$(LIB): $(OBJS)
	ar rcs libmincrt.a $(OBJS)

.cpp.o:
	clang++ -std=c++14 -c $<

clean:
	rm $(OBJS) $(LIB) $(BIN) *.s
