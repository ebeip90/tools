
# -- Compilers --
CC  ?= gcc
CXX ?= g++

# -- Output files --
OUT ?= a.out

# -- Directories --
SRC ?= .

# -- Flags --
CFLAGS		+= -ggdb -O0

# -- Input Files --
C_FILES   = $(wildcard $(SRC)/*.c)
CPP_FILES = $(wildcard $(SRC)/*.cpp)
OBJ_FILES = $(patsubst %.c, %.o, $(C_FILES)) $(patsubst %.cpp, %.o, $(CPP_FILES))

# -- Dependencies --
DEPFILE = .depfile

all: $(OBJ_FILES)
	$(CC) $(CFLAGS) -o $(OUT) $<

$(OUT): $(OBJ_FILES)
	$(CXX) $< -p $@

.c.o:
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

.cpp.o:
	$(CXX) $(CFLAGS) $(INCLUDES) -c $< -o $@

$(DEPFILE):
	rm -f $(DEPFILE)
	$(CC)  -E -MM $(CFLAGS) $(INCLUDES) $(C_FILES)   >> $(DEPFILE)
	$(CXX) -E -MM $(CFLAGS) $(INCLUDES) $(CPP_FILES) >> $(DEPFILE)

clean:
	rm $(OUT) $(SRC)/*.o

-include $(DEPFILE)

.SUFFIXES: .c .cpp
.PHONY: all clean install