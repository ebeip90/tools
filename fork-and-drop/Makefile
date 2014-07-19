.phony:all
all:
	clang++ -fPIE -fpic -g -m32 -shared -o fork-and-drop.32.so fork-and-drop.cc -ldl
	clang++ -fPIE -fpic -g -m64 -shared -o fork-and-drop.64.so fork-and-drop.cc -ldl
	clang -ofork-and-call fork-and-call.cc
