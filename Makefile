SRCS := dwarf.cpp runtime.cpp
OBJS := $(SRCS:%.cpp=%.o)

all: $(OBJS)
	clang++ -std=c++14 -c $(OBJS)

.cpp.o:
	clang++ -std=c++14 -c $<

clean:
	rm $(OBJS)
