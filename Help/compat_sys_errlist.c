/* Compatibility for sys_errlist (removed in modern glibc) */
#include <string.h>
#include <errno.h>

/* Provide sys_errlist using strerror */
char *sys_errlist[] = {
    [0 ... 255] = "Unknown error"
};

/* This is a minimal implementation - in practice strerror() is used */
const int sys_nerr = 256;