#include <ctype.h>
#include <errno.h>
#include <shadow.h>
#include <stdio.h>
#include <string.h>
#define STRUCTURE        spwd
#define ENTNAME                spent
struct spent_data {};
#define FALSEP(arg) 0
#include "files-parse.c"
LINE_PARSER
(,
 STRING_FIELD (result->sp_namp, ISCOLON, 0);
 if (line[0] == '\0'
     && (result->sp_namp[0] == '+' || result->sp_namp[0] == '-'))
   {
     result->sp_pwdp = NULL;
     result->sp_lstchg = 0;
     result->sp_min = 0;
     result->sp_max = 0;
     result->sp_warn = -1l;
     result->sp_inact = -1l;
     result->sp_expire = -1l;
     result->sp_flag = ~0ul;
   }
 else
   {
     STRING_FIELD (result->sp_pwdp, ISCOLON, 0);
     INT_FIELD_MAYBE_NULL (result->sp_lstchg, ISCOLON, 0, 10, (long int) (int),
                           (long int) -1);
     INT_FIELD_MAYBE_NULL (result->sp_min, ISCOLON, 0, 10, (long int) (int),
                           (long int) -1);
     INT_FIELD_MAYBE_NULL (result->sp_max, ISCOLON, 0, 10, (long int) (int),
                           (long int) -1);
     while (isspace (*line))
       ++line;
     if (*line == '\0')
       {
         result->sp_warn = -1l;
         result->sp_inact = -1l;
         result->sp_expire = -1l;
         result->sp_flag = ~0ul;
       }
     else
       {
         INT_FIELD_MAYBE_NULL (result->sp_warn, ISCOLON, 0, 10,
                               (long int) (int), (long int) -1);
         INT_FIELD_MAYBE_NULL (result->sp_inact, ISCOLON, 0, 10,
                               (long int) (int), (long int) -1);
         INT_FIELD_MAYBE_NULL (result->sp_expire, ISCOLON, 0, 10,
                               (long int) (int), (long int) -1);
         if (*line != '\0')
           INT_FIELD_MAYBE_NULL (result->sp_flag, FALSEP, 0, 10,
                                 (unsigned long int), ~0ul)
         else
           result->sp_flag = ~0ul;
       }
   }
 )
int __sgetspent_r (const char *string, struct spwd *resbuf, char *buffer,
               size_t buflen, struct spwd **result)
{
  buffer[buflen - 1] = '\0';
  char *sp = strncpy (buffer, string, buflen);
  if (buffer[buflen - 1] != '\0')
    return ERANGE;
  int parse_result = parse_line (sp, resbuf, NULL, 0, &errno);
  *result = parse_result > 0 ? resbuf : NULL;
  return *result == NULL ? errno : 0;
}
