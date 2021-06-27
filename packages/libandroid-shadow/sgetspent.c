#include <errno.h>
#include <libc-lock.h>
#include <shadow.h>
#include <stdlib.h>
#define BUFLEN_SPWD 1024
__libc_lock_define_initialized (static, lock);
struct spwd *
sgetspent (const char *string)
{
  static char *buffer;
  static size_t buffer_size;
  static struct spwd resbuf;
  struct spwd *result;
  int save;
  __libc_lock_lock (lock);
  if (buffer == NULL)
    {
      buffer_size = BUFLEN_SPWD;
      buffer = malloc (buffer_size);
    }
  while (buffer != NULL
         && (__sgetspent_r (string, &resbuf, buffer, buffer_size, &result)
             == ERANGE))
    {
      char *new_buf;
      buffer_size += BUFLEN_SPWD;
      new_buf = realloc (buffer, buffer_size);
      if (new_buf == NULL)
        {
          save = errno;
          free (buffer);
          __set_errno (save);
        }
      buffer = new_buf;
    }
  if (buffer == NULL)
    result = NULL;
  save = errno;
  __libc_lock_unlock (lock);
  __set_errno (save);
  return result;
}
