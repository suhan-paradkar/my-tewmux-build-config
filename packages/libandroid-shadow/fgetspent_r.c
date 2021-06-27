#include <ctype.h>
#include <errno.h>
#include <shadow.h>
#include <stdio.h>
#define flockfile(s) _IO_flockfile (s)
#define funlockfile(s) _IO_funlockfile (s)
#define STRUCTURE        spwd
#define ENTNAME                spent
#define        EXTERN_PARSER        1
struct spent_data {};
int
__fgetspent_r (FILE *stream, struct spwd *resbuf, char *buffer, size_t buflen,
               struct spwd **result)
{
  char *p;
  flockfile (stream);
  do
    {
      buffer[buflen - 1] = '\xff';
      p = fgets_unlocked (buffer, buflen, stream);
      if (p == NULL && feof_unlocked (stream))
        {
          funlockfile (stream);
          *result = NULL;
          __set_errno (ENOENT);
          return errno;
        }
      if (p == NULL || buffer[buflen - 1] != '\xff')
        {
          funlockfile (stream);
          *result = NULL;
          __set_errno (ERANGE);
          return errno;
        }
      while (isspace (*p))
        ++p;
    } while (*p == '\0' || *p == '#' /* Ignore empty and comment lines.  */
             || ! parse_line (buffer, (void *) resbuf, NULL, 0, &errno));
  funlockfile (stream);
  *result = resbuf;
  return 0;
}
