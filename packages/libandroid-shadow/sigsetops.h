#ifndef _SIGSETOPS_H
#define _SIGSETOPS_H 1
#include <signal.h>
/* Return a mask that includes the bit for SIG only.  */
# define __sigmask(sig) \
  (((unsigned long int) 1) << (((sig) - 1) % (8 * sizeof (unsigned long int))))
/* Return the word index for SIG.  */
# define __sigword(sig) (((sig) - 1) / (8 * sizeof (unsigned long int)))
# define __sigemptyset(set)                                        \
  (__extension__ ({                                                \
    int __cnt = _SIGSET_NWORDS;                                        \
    sigset_t *__set = (set);                                        \
    while (--__cnt >= 0)                                        \
      __set->__val[__cnt] = 0;                                        \
    (void)0;                                                        \
  }))
# define __sigfillset(set)                                        \
  (__extension__ ({                                                \
    int __cnt = _SIGSET_NWORDS;                                        \
    sigset_t *__set = (set);                                        \
    while (--__cnt >= 0)                                        \
      __set->__val[__cnt] = ~0UL;                                \
    (void)0;                                                        \
  }))
# define __sigisemptyset(set)                                        \
  (__extension__ ({                                                \
    int __cnt = _SIGSET_NWORDS;                                        \
    const sigset_t *__set = (set);                                \
    int __ret = __set->__val[--__cnt];                                \
    while (!__ret && --__cnt >= 0)                                \
      __ret = __set->__val[__cnt];                                \
    __ret == 0;                                                        \
  }))
# define __sigandset(dest, left, right)                                \
  (__extension__ ({                                                \
    int __cnt = _SIGSET_NWORDS;                                        \
    sigset_t *__dest = (dest);                                        \
    const sigset_t *__left = (left);                                \
    const sigset_t *__right = (right);                                \
    while (--__cnt >= 0)                                        \
      __dest->__val[__cnt] = (__left->__val[__cnt]                \
                              & __right->__val[__cnt]);                \
    (void)0;                                                        \
  }))
# define __sigorset(dest, left, right)                                \
  (__extension__ ({                                                \
    int __cnt = _SIGSET_NWORDS;                                        \
    sigset_t *__dest = (dest);                                        \
    const sigset_t *__left = (left);                                \
    const sigset_t *__right = (right);                                \
    while (--__cnt >= 0)                                        \
      __dest->__val[__cnt] = (__left->__val[__cnt]                \
                              | __right->__val[__cnt]);                \
    (void)0;                                                        \
  }))
/* These macros needn't check for a bogus signal number;
   error checking is done in the non-__ versions.  */
# define __sigismember(set, sig)                                \
  (__extension__ ({                                                \
    unsigned long int __mask = __sigmask (sig);                        \
    unsigned long int __word = __sigword (sig);                        \
    (set)->__val[__word] & __mask ? 1 : 0;                        \
  }))
# define __sigaddset(set, sig)                                        \
  (__extension__ ({                                                \
    unsigned long int __mask = __sigmask (sig);                        \
    unsigned long int __word = __sigword (sig);                        \
    (set)->__val[__word] |= __mask;                                \
    (void)0;                                                        \
  }))
# define __sigdelset(set, sig)                                        \
  (__extension__ ({                                                \
    unsigned long int __mask = __sigmask (sig);                        \
    unsigned long int __word = __sigword (sig);                        \
    (set)->__val[__word] &= ~__mask;                                \
    (void)0;                                                        \
 }))
#endif /* bits/sigsetops.h */
