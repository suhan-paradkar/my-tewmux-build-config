#ifndef _NSS_H
#define _NSS_H        1
#include <features.h>
#include <stdint.h>
__BEGIN_DECLS
enum nss_status
{
  NSS_STATUS_TRYAGAIN = -2,
  NSS_STATUS_UNAVAIL,
  NSS_STATUS_NOTFOUND,
  NSS_STATUS_SUCCESS,
  NSS_STATUS_RETURN
};
struct gaih_addrtuple
  {
    struct gaih_addrtuple *next;
    char *name;
    int family;
    uint32_t addr[4];
    uint32_t scopeid;
  };
extern int __nss_configure_lookup (const char *__dbname,
                                   const char *__string);
__END_DECLS
#endif
