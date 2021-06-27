#include <ctype.h>
#include <errno.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#ifndef EXTRA_ARGS
# define EXTRA_ARGS
# define EXTRA_ARGS_DECL
# define EXTRA_ARGS_VALUE
#endif
#define CONCAT(a,b) CONCAT1(a,b)
#define CONCAT1(a,b) a##b
#ifndef STRUCTURE
# define STRUCTURE ENTNAME
#endif
struct parser_data
  {
#ifdef ENTDATA
    struct ENTDATA entdata;
# define ENTDATA_DECL(data) struct ENTDATA *const entdata = &data->entdata;
#else
# define ENTDATA_DECL(data)
#endif
    char linebuffer[0];
  };
#ifdef ENTDATA
# define parser_stclass static
# define nss_files_parse_hidden_def(name)
#else
# define parser_stclass /* Global */
# define parse_line CONCAT(_nss_files_parse_,ENTNAME)
# if __ANDROID__
#  define nss_files_parse_hidden_def(name) libc_hidden_def (name)
# else
#  define nss_files_parse_hidden_def(name) libnss_files_hidden_def (name)
# endif
#endif
#ifdef EXTERN_PARSER
extern int parse_line (char *line, struct STRUCTURE *result,
                       struct parser_data *data, size_t datalen, int *errnop
                       EXTRA_ARGS_DECL);
# define LINE_PARSER(EOLSET, BODY) /* Do nothing */
#else
# define LINE_PARSER(EOLSET, BODY)                                              \
parser_stclass int                                                              \
parse_line (char *line, struct STRUCTURE *result,                              \
            struct parser_data *data, size_t datalen, int *errnop              \
            EXTRA_ARGS_DECL)                                                      \
{                                                                              \
  ENTDATA_DECL (data)                                                              \
  BUFFER_PREPARE                                                              \
  char *p = strpbrk (line, EOLSET "\n");                                      \
  if (p != NULL)                                                              \
    *p = '\0';                                                                      \
  BODY;                                                                              \
  TRAILING_LIST_PARSER;                                                              \
  return 1;                                                                      \
}                                                                              \
nss_files_parse_hidden_def (parse_line)
# define STRING_FIELD(variable, terminator_p, swallow)                              \
  {                                                                              \
    variable = line;                                                              \
    while (*line != '\0' && !terminator_p (*line))                              \
      ++line;                                                                      \
    if (*line != '\0')                                                              \
      {                                                                              \
        *line = '\0';                                                              \
        do                                                                      \
          ++line;                                                              \
        while (swallow && terminator_p (*line));                              \
      }                                                                              \
  }
# define STRING_LIST(variable, terminator_c) \
  {                                                                              \
    char **list = parse_list (&line, buf_start, buf_end, terminator_c,              \
                              errnop);                                              \
    if (list)                                                                      \
      variable = list;                                                              \
    else                                                                      \
      return -1;                /* -1 indicates we ran out of space.  */      \
                                                                              \
    while (*list != NULL)                                                      \
      ++list;                                                                      \
    buf_start = (char *) (list + 1);                                              \
  }
static inline uint32_t
__attribute__ ((always_inline))
strtou32 (const char *nptr, char **endptr, int base)
{
  unsigned long int val = strtoul (nptr, endptr, base);
  if (sizeof (long int) > 4 && val > 0xffffffff)
    val = 0xffffffff;
  return val;
}
# define INT_FIELD(variable, terminator_p, swallow, base, convert)              \
  {                                                                              \
    char *endp;                                                                      \
    variable = convert (strtou32 (line, &endp, base));                              \
    if (endp == line)                                                              \
      return 0;                                                                      \
    else if (terminator_p (*endp))                                              \
      do                                                                      \
        ++endp;                                                                      \
      while (swallow && terminator_p (*endp));                                      \
    else if (*endp != '\0')                                                      \
      return 0;                                                                      \
    line = endp;                                                              \
  }
# define INT_FIELD_MAYBE_NULL(variable, terminator_p, swallow, base, convert, default)              \
  {                                                                              \
    char *endp;                                                                      \
    if (*line == '\0')                                                              \
      return 0;                                                                      \
    variable = convert (strtou32 (line, &endp, base));                              \
    if (endp == line)                                                              \
      variable = default;                                                      \
    if (terminator_p (*endp))                                                      \
      do                                                                      \
        ++endp;                                                                      \
      while (swallow && terminator_p (*endp));                                      \
    else if (*endp != '\0')                                                      \
      return 0;                                                                      \
    line = endp;                                                              \
  }
# define ISCOLON(c) ((c) == ':')
# ifndef TRAILING_LIST_MEMBER
#  define BUFFER_PREPARE /* Nothing to do.  */
#  define TRAILING_LIST_PARSER /* Nothing to do.  */
# else
# define BUFFER_PREPARE \
  char *buf_start = NULL;                                                      \
  char *buf_end = (char *) data + datalen;                                      \
  if (line >= data->linebuffer && line < buf_end)                              \
    buf_start = strchr (line, '\0') + 1;                                      \
  else                                                                              \
    buf_start = data->linebuffer;                                              \
#  define TRAILING_LIST_PARSER \
{                                                                              \
  if (buf_start == NULL)                                                      \
    {                                                                              \
      if (line >= data->linebuffer && line < buf_end)                              \
        buf_start = strchr (line, '\0') + 1;                                      \
      else                                                                      \
        buf_start = data->linebuffer;                                              \
    }                                                                              \
                                                                              \
  char **list = parse_list (&line, buf_start, buf_end, '\0', errnop);              \
  if (list)                                                                      \
    result->TRAILING_LIST_MEMBER = list;                                      \
  else                                                                              \
    return -1;                /* -1 indicates we ran out of space.  */              \
}
static inline char **
__attribute ((always_inline))
parse_list (char **linep, char *eol, char *buf_end, int terminator_c,
            int *errnop)
{
  char *line = *linep;
  char **list, **p;
  eol += __alignof__ (char *) - 1;
  eol -= (eol - (char *) 0) % __alignof__ (char *);
  list = (char **) eol;
  p = list;
  while (1)
    {
      if ((char *) (p + 2) > buf_end)
        {
          *errnop = ERANGE;
          return NULL;
        }
      if (*line == '\0')
        break;
      if (*line == terminator_c)
        {
          ++line;
          break;
        }
      while (isspace (*line))
        ++line;
      char *elt = line;
      while (1)
        {
          if (*line == '\0' || *line == terminator_c
              || TRAILING_LIST_SEPARATOR_P (*line))
            {
              if (line > elt)
                *p++ = elt;
              if (*line != '\0')
                {
                  char endc = *line;
                  *line++ = '\0';
                  if (endc == terminator_c)
                    goto out;
                }
              break;
            }
          ++line;
        }
    }
 out:
  *p = NULL;
  *linep = line;
  return list;
}
# endif        /* TRAILING_LIST_MEMBER */
#endif        /* EXTERN_PARSER */
#define LOOKUP_NAME(nameelt, aliaselt)                                              \
{                                                                              \
  char **ap;                                                                      \
  if (! strcmp (name, result->nameelt))                                              \
    break;                                                                      \
  for (ap = result->aliaselt; *ap; ++ap)                                      \
    if (! strcmp (name, *ap))                                                      \
      break;                                                                      \
  if (*ap)                                                                      \
    break;                                                                      \
}
#define LOOKUP_NAME_CASE(nameelt, aliaselt)                                      \
{                                                                              \
  char **ap;                                                                      \
  if (! __strcasecmp (name, result->nameelt))                                      \
    break;                                                                      \
  for (ap = result->aliaselt; *ap; ++ap)                                      \
    if (! __strcasecmp (name, *ap))                                              \
      break;                                                                      \
  if (*ap)                                                                      \
    break;                                                                      \
}
