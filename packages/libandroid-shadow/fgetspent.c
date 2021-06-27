#include <errno.h>
#include <libc-lock.h>
#include <shadow.h>
#include <stdio.h>
#include <stdlib.h>
#define BUFLEN_SPWD 1024
#ifdef __cplusplus
#define __sec_comment "\n\t#"
#define libc_freeres_ptr(decl) \
  __make_section_unallocated (("__libc_freeres_ptrs, \"aw\", %nobits")) \
  decl __attribute__ ((section ("__libc_freeres_ptrs" __sec_comment)))

  __libc_lock_define_initialized (static, lock);
  libc_freeres_ptr (char* buffer);
#else
char* buffer;
  __libc_lock_define_initialized (static, lock);

#endif

struct spwd *
fgetspent (FILE *stream)
{

  static size_t buffer_size;
  static struct spwd resbuf;
  fpos_t pos;
  struct spwd *result;
  int save;
  if (fgetpos (stream, &pos) != 0)
    return NULL;
  __libc_lock_lock (lock);
  if (buffer == NULL)
    {
      buffer_size = BUFLEN_SPWD;
      buffer = malloc (buffer_size);
    }
  while (buffer != NULL
         && (__fgetspent_r (stream, &resbuf, buffer, buffer_size, &result)
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
      if (fsetpos (stream, &pos) != 0)
        buffer = NULL;
    }
  if (buffer == NULL)
    result = NULL;
  save = errno;
  __libc_lock_unlock (lock);
  __set_errno (save);
  return result;
}
