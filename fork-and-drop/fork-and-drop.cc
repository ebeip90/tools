#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <dlfcn.h>
#include <sys/types.h>
#include <pwd.h>
#include <grp.h>
void drop_privs_user(char* username) {
    passwd * pw = getpwnam(username);
    if(0 == pw) {
        perror("getpwnam");
        return;
    }

    printf("UID: %i\n", pw->pw_uid);
    printf("GID: %i\n", pw->pw_gid);
    if(0 != initgroups(pw->pw_name, pw->pw_gid))
        perror("initgroups");
    if(0 != setresgid(pw->pw_gid, pw->pw_gid, pw->pw_gid))
        perror("setresgid");
    if(0 != setresuid(pw->pw_uid, pw->pw_uid, pw->pw_uid))
        perror("setresuid");
}

char* fork_user = getenv("TARGET_USER");
int   delay     = atoi(getenv("DROP_DELAY") ? getenv("DROP_DELAY") : "0");


int fork() {
    int (*_fork)()  = (int(*)()) dlsym(RTLD_NEXT, "fork");
    int pid = _fork();

    if(delay == 0) {
        if(0 == pid) {
            drop_privs_user(fork_user);
        }
    } else {
        delay--;
    }

    return pid;
}
