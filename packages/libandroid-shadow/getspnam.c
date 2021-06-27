#include <shadow.h>
#define LOOKUP_TYPE        struct spwd
#define FUNCTION_NAME        getspnam
#define DATABASE_NAME        shadow
#define ADD_PARAMS        const char *name
#define ADD_VARIABLES        name
#define BUFLEN                1024
#undef        USE_NSCD
