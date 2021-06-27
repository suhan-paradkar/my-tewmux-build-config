#include <shadow.h>
#define LOOKUP_TYPE        struct spwd
#define SETFUNC_NAME        setspent
#define        GETFUNC_NAME        getspent
#define        ENDFUNC_NAME        endspent
#define DATABASE_NAME        shadow
#define BUFLEN                1024
#undef        USE_NSCD
