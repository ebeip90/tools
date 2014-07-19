#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <dlfcn.h>
#include <sys/types.h>
#include <pwd.h>
#include <grp.h>

int   fd        = atoi(getenv("FILE_DESC") ? getenv("FILE_DESC") : "3");


int fork() {
    int (*_fork)()  = (int(*)()) dlsym(RTLD_NEXT, "fork");
    int pid = _fork();

    if(0 == pid) {
        close(fd);
    }

    return pid;
}
