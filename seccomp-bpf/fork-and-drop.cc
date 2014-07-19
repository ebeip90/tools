#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <dlfcn.h>
#include <sys/types.h>
#include <pwd.h>

void drop_privs_user(char* username) {
    passwd * pw = getpwnam(username);
    if(!pw) {
        perror("getpwnam");
        return;
    }

    setresuid(pw->pw_uid, pw->pw_uid, pw->pw_uid);
    setresgid(pw->pw_gid, pw->pw_gid, pw->pw_gid);
}

char* fork_user = "jwarcd";
int fork_count = 0;

int (*real_fork)();

int fork() {
    *(void**)&real_fork = dlsym(RTLD_NEXT, "fork");
    int pid = real_fork();

    if(fork_count++ >= 1 && 0 == pid) {
        drop_privs_user(fork_user);
    }

    return pid;
}
