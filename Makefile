SRCS := dwarf.cpp runtime.cpp
OBJS := $(SRCS:%.cpp=%.o)

LIB := libmincrt.a

all: $(LIB)

$(LIB): $(OBJS)
	ar rcs libmincrt.a $(OBJS)

.cpp.o:
	clang++ -std=c++14 -c $<

clean:
	rm $(OBJS)
