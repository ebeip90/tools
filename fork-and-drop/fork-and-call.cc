#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
int main(int argc, char** argv) {
    if(argc < 2) {
        printf("Usage: %s <prog> <args...>\n", argv[0]);
    }
    if(fork() == 0) {
        execvp(argv[1], &argv[1]);
    }
    return 0;
}
