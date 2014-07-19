#include <stdio.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <pwd.h>
int main() {
    FILE *fd = fopen("file.txt", "w+");
    int  pid = fork();
    int  uid = getuid();
    struct passwd* pw = getpwuid(uid);

    fprintf(stdout, "%x %s\n", pid, pw->pw_name);
    if(0 >= fprintf(fd, "%x %s\n", pid, pw->pw_name))
        perror("fprintf");

    return 0;
}

