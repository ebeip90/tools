
# -- Compilers --
CC  ?= gcc
CXX ?= g++

# -- Output files --
OUT ?= a.out

# -- Directories --
SRC ?= .

C_FILES   = $(wildcard $(SRC)/*.c)
CPP_FILES = $(wildcard $(SRC)/*.cpp)
OBJ_FILES = $(patsubst %.c, %.o, $(C_FILES)) $(patsubst %.cpp, %.o, $(CPP_FILES))

all: $(OBJ_FILES)
	$(CC) $(CFLAGS) -o $(OUT) $<

%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

%.o: %.cpp
	$(CXX) $(CFLAGS) $(INCLUDES) -c $< -o $@

.PHONY: clean
clean:
	rm $(OUT) $(SRC)/*.o
	
