#include <signal.h>
#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <seccomp.h>
#include <errno.h>
#include <sys/prctl.h>
#include "seccomp-bpf.h"

static int install_syscall_filter(void)
{
  // This is a bit tedious. Maybe the filter can be:
  // "allow everything except nanosleep()."
  struct sock_filter filter[] = {
    /* Validate architecture. */
    VALIDATE_ARCHITECTURE,
    /* Grab the system call number. */
    EXAMINE_SYSCALL,
    /* List disallowed syscalls. */
    DENY_KILL_SYSCALL(kill),
    DENY_KILL_SYSCALL(getppid),
    DENY_KILL_SYSCALL(getpid),
    ALLOW_PROCESS,
  };
  struct sock_fprog prog;
  prog.len = (unsigned short)(sizeof(filter)/sizeof(filter[0]));
  prog.filter = filter;

  if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
    perror("prctl(NO_NEW_PRIVS)");
    goto failed;
  }
  if (prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog)) {
    perror("prctl(SECCOMP)");
    goto failed;
  }
  return 0;

failed:
  if (errno == EINVAL)
    fprintf(stderr, "SECCOMP_FILTER is not available. :(\n");
  return 1;
}

int do_child(int argc, char **argv) {
    char *args [argc+1];
    memcpy(args, argv, argc * sizeof(char*));
    args[argc] = NULL;
    // ptrace(PTRACE_TRACEME);
    // kill(getpid(), SIGSTOP);
    return execvp(args[0], args);
}


int main(int argc, char** argv)
{
    install_syscall_filter();
    return do_child(argc-1, argv+1);
}
