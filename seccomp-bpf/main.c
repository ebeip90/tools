#include <errno.h>
#include <linux/audit.h>
#include <linux/filter.h>
#include <linux/seccomp.h>
#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>
#include <sys/prctl.h>
#include <unistd.h>
#include <string.h>

static int install_filter(int nr, int arch)
{
  struct sock_filter filter[] = {
    BPF_STMT(BPF_LD+BPF_W+BPF_ABS, (offsetof(struct seccomp_data, arch))),
    BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, arch, 0, 3),
    BPF_STMT(BPF_LD+BPF_W+BPF_ABS, (offsetof(struct seccomp_data, nr))),
    BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, nr, 0, 1),
    BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_KILL),
    BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_ALLOW),
  };
  struct sock_fprog prog = {
    .len = (unsigned short)(sizeof(filter)/sizeof(filter[0])),
    .filter = filter,
  };

  if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
   perror("prctl(NO_NEW_PRIVS)");
   return 1;
  }
  if (prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog)) {
    perror("prctl(SECCOMP)");
    return 1;
  }
  return 0;
}

int do_child(int argc, char **argv) {
    char *args [argc+1];
    memcpy(args, argv, argc * sizeof(char*));
    args[argc] = NULL;
    return execvp(args[0], args);
}


int main(int argc, char** argv)
{
#include <asm/unistd_32.h>
    printf("%i\n", __NR_kill);
    install_filter(__NR_kill, AUDIT_ARCH_I386);
#include <asm/unistd_64.h>
    printf("%i\n", __NR_kill);
    install_filter(__NR_kill, AUDIT_ARCH_X86_64);

    if(argc > 1)
      return do_child(argc-1, argv+1);
    return 0;
}
