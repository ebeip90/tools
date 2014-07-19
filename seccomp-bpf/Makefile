.phony:all
all:
	clang -fPIE -fpic -g -m32 -o nokill32 main.c
	clang -fPIE -fpic -g -m64 -o nokill64 main.c
	clang++ -fPIE -fpic -g -m32 -shared -o fork-and-drop.32.so fork-and-drop.cc -ldl
	clang++ -fPIE -fpic -g -m64 -shared -o fork-and-drop.64.so fork-and-drop.cc -ldl
