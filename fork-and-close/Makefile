.phony:all
all:
	clang++ -fPIE -fpic -g -m32 -shared -o fork-and-close.32.so fork-and-close.cc -ldl
	clang++ -fPIE -fpic -g -m64 -shared -o fork-and-close.64.so fork-and-close.cc -ldl
