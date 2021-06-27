#ifndef _SHADOW_H
#define _SHADOW_H        1

#include <paths.h>

#define        __need_FILE
#include <stdio.h>
#define __need_size_t
#include <stddef.h>

#define        SHADOW _PATH_SHADOW


__BEGIN_DECLS

struct spwd
  {
    char *sp_namp;                /* Login name.  */
    char *sp_pwdp;                /* Encrypted password.  */
    long int sp_lstchg;                /* Date of last change.  */
    long int sp_min;                /* Minimum number of days between changes.  */
    long int sp_max;                /* Maximum number of days between changes.  */
    long int sp_warn;                /* Number of days to warn user to change
                                   the password.  */
    long int sp_inact;                /* Number of days the account may be
                                   inactive.  */
    long int sp_expire;                /* Number of days since 1970-01-01 until
                                   account expires.  */
    unsigned long int sp_flag;        /* Reserved.  */
  };


extern void setspent (void);

extern void endspent (void);

extern struct spwd *getspent (void);

extern struct spwd *getspnam (__const char *__name);

extern struct spwd *sgetspent (__const char *__string);

extern struct spwd *fgetspent (FILE *__stream);

extern int putspent (__const struct spwd *__p, FILE *__stream);


#ifdef __USE_MISC
extern int getspent_r (struct spwd *__result_buf, char *__buffer,
                       size_t __buflen, struct spwd **__result);

extern int getspnam_r (__const char *__name, struct spwd *__result_buf,
                       char *__buffer, size_t __buflen,
                       struct spwd **__result);

extern int sgetspent_r (__const char *__string, struct spwd *__result_buf,
                        char *__buffer, size_t __buflen,
                        struct spwd **__result);

extern int fgetspent_r (FILE *__stream, struct spwd *__result_buf,
                        char *__buffer, size_t __buflen,
                        struct spwd **__result);
#endif        /* misc */



extern int lckpwdf (void);

extern int ulckpwdf (void);

__END_DECLS

#endif /* shadow.h */
