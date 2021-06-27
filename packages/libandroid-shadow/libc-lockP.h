#ifndef _LIBC_LOCKP_H
#define _LIBC_LOCKP_H 1
#include <pthread.h>
#define __need_NULL
#include <stddef.h>
#include <linux/tls.h>
#ifndef __ANDROID__
typedef pthread_mutex_t __libc_lock_t;
#else
typedef int __libc_lock_t;
#endif
typedef struct { pthread_mutex_t mutex; } __rtld_lock_recursive_t;
typedef pthread_rwlock_t __libc_rwlock_t;
/* Type for key to thread-specific data.  */
typedef pthread_key_t __libc_key_t;
/* Define a lock variable NAME with storage class CLASS.  The lock must be
   initialized with __libc_lock_init before it can be used (or define it
   with __libc_lock_define_initialized, below).  Use `extern' for CLASS to
   declare a lock defined in another module.  In public structure
   definitions you must use a pointer to the lock structure (i.e., NAME
   begins with a `*'), because its storage size will not be known outside
   of libc.  */
#define __libc_lock_define(CLASS,NAME) \
  CLASS __libc_lock_t NAME;
#define __libc_rwlock_define(CLASS,NAME) \
  CLASS __libc_rwlock_t NAME;
#define __rtld_lock_define_recursive(CLASS,NAME) \
  CLASS __rtld_lock_recursive_t NAME;
/* Define an initialized lock variable NAME with storage class CLASS.
   For the C library we take a deeper look at the initializer.  For
   this implementation all fields are initialized to zero.  Therefore
   we don't initialize the variable which allows putting it into the
   BSS section.  (Except on PA-RISC and other odd architectures, where
   initialized locks must be set to one due to the lack of normal
   atomic operations.) */
#define _LIBC_LOCK_INITIALIZER LLL_LOCK_INITIALIZER
#ifndef __ANDROID__
# if LLL_LOCK_INITIALIZER == 0
#  define __libc_lock_define_initialized(CLASS,NAME) \
  CLASS __libc_lock_t NAME;
# else
#  define __libc_lock_define_initialized(CLASS,NAME) \
  CLASS __libc_lock_t NAME = LLL_LOCK_INITIALIZER;
# endif
#else
# define __libc_lock_define_initialized(CLASS,NAME) \
  CLASS __libc_lock_t NAME;
#endif
#define __libc_rwlock_define_initialized(CLASS,NAME) \
  CLASS __libc_rwlock_t NAME = PTHREAD_RWLOCK_INITIALIZER;
#define __rtld_lock_define_initialized_recursive(CLASS,NAME) \
  CLASS __rtld_lock_recursive_t NAME = _RTLD_LOCK_RECURSIVE_INITIALIZER;
#define _RTLD_LOCK_RECURSIVE_INITIALIZER \
  {PTHREAD_RECURSIVE_MUTEX_INITIALIZER_NP}
#define __rtld_lock_initialize(NAME) \
  (void) ((NAME) = (__rtld_lock_recursive_t) _RTLD_LOCK_RECURSIVE_INITIALIZER)
/* If we check for a weakly referenced symbol and then perform a
   normal jump to it te code generated for some platforms in case of
   PIC is unnecessarily slow.  What would happen is that the function
   is first referenced as data and then it is called indirectly
   through the PLT.  We can make this a direct jump.  */
#ifdef __PIC__
# define __libc_maybe_call(FUNC, ARGS, ELSE) \
  (__extension__ ({ __typeof (FUNC) *_fn = (FUNC); \
                    _fn != NULL ? (*_fn) ARGS : ELSE; }))
#else
# define __libc_maybe_call(FUNC, ARGS, ELSE) \
  (FUNC != NULL ? FUNC ARGS : ELSE)
#endif
/* Call thread functions through the function pointer table.  */
#ifndef __ANDROID__
# define PTFAVAIL(NAME) __libc_pthread_functions_init
# define __libc_ptf_call(FUNC, ARGS, ELSE) \
  (__libc_pthread_functions_init ? PTHFCT_CALL (ptr_##FUNC, ARGS) : ELSE)
# define __libc_ptf_call_always(FUNC, ARGS) \
  PTHFCT_CALL (ptr_##FUNC, ARGS)
#else
# define PTFAVAIL(NAME) (NAME != NULL)
# define __libc_ptf_call(FUNC, ARGS, ELSE) \
  __libc_maybe_call (FUNC, ARGS, ELSE)
# define __libc_ptf_call_always(FUNC, ARGS) \
  FUNC ARGS
#endif
/* Initialize the named lock variable, leaving it in a consistent, unlocked
   state.  */
#ifndef __ANDROID__
# define __libc_lock_init(NAME) \
  ((void) ((NAME) = LLL_LOCK_INITIALIZER))
#else
# define __libc_lock_init(NAME) \
  __libc_maybe_call (__pthread_mutex_init, (&(NAME), NULL), 0)
#endif
#ifndef __ANDROID__
# define __libc_rwlock_init(NAME) \
  ((void) __builtin_memset (&(NAME), '\0', sizeof (NAME)))
#else
# define __libc_rwlock_init(NAME) \
  __libc_maybe_call (__pthread_rwlock_init, (&(NAME), NULL), 0)
#endif
#ifndef __ANDROID__
# define __libc_lock_fini(NAME) ((void) 0)
#else
# define __libc_lock_fini(NAME) \
  __libc_maybe_call (__pthread_mutex_destroy, (&(NAME)), 0)
#endif
#ifndef __ANDROID__
# define __libc_rwlock_fini(NAME) ((void) 0)
#else
# define __libc_rwlock_fini(NAME) \
  __libc_maybe_call (__pthread_rwlock_destroy, (&(NAME)), 0)
#endif
/* Lock the named lock variable.  */
#ifndef __ANDROID__
# ifndef __libc_lock_lock
#  define __libc_lock_lock(NAME) \
  ({ lll_lock (NAME, LLL_PRIVATE); 0; })
# endif
#else
# undef __libc_lock_lock
# define __libc_lock_lock(NAME) \
  __libc_maybe_call (__pthread_mutex_lock, (&(NAME)), 0)
#endif
#define __libc_rwlock_rdlock(NAME) \
  __libc_ptf_call (__pthread_rwlock_rdlock, (&(NAME)), 0)
#define __libc_rwlock_wrlock(NAME) \
  __libc_ptf_call (__pthread_rwlock_wrlock, (&(NAME)), 0)
/* Try to lock the named lock variable.  */
#ifndef __ANDROID__
# ifndef __libc_lock_trylock
#  define __libc_lock_trylock(NAME) \
  lll_trylock (NAME)
# endif
#else
# undef __libc_lock_trylock
# define __libc_lock_trylock(NAME) \
  __libc_maybe_call (__pthread_mutex_trylock, (&(NAME)), 0)
#endif
#define __libc_rwlock_tryrdlock(NAME) \
  __libc_maybe_call (__pthread_rwlock_tryrdlock, (&(NAME)), 0)
#define __libc_rwlock_trywrlock(NAME) \
  __libc_maybe_call (__pthread_rwlock_trywrlock, (&(NAME)), 0)
#define __rtld_lock_trylock_recursive(NAME) \
  __libc_maybe_call (__pthread_mutex_trylock, (&(NAME).mutex), 0)
/* Unlock the named lock variable.  */
#ifndef __ANDROID__
# define __libc_lock_unlock(NAME) \
  lll_unlock (NAME, LLL_PRIVATE)
#else
# define __libc_lock_unlock(NAME) \
  __libc_maybe_call (__pthread_mutex_unlock, (&(NAME)), 0)
#endif
#define __libc_rwlock_unlock(NAME) \
  __libc_ptf_call (__pthread_rwlock_unlock, (&(NAME)), 0)
#ifdef SHARED
# define __rtld_lock_default_lock_recursive(lock) \
  ++((pthread_mutex_t *)(lock))->__data.__count;
# define __rtld_lock_default_unlock_recursive(lock) \
  --((pthread_mutex_t *)(lock))->__data.__count;
# define __rtld_lock_lock_recursive(NAME) \
  GL(dl_rtld_lock_recursive) (&(NAME).mutex)
# define __rtld_lock_unlock_recursive(NAME) \
  GL(dl_rtld_unlock_recursive) (&(NAME).mutex)
#else
# define __rtld_lock_lock_recursive(NAME) \
  __libc_maybe_call (__pthread_mutex_lock, (&(NAME).mutex), 0)
# define __rtld_lock_unlock_recursive(NAME) \
  __libc_maybe_call (__pthread_mutex_unlock, (&(NAME).mutex), 0)
#endif
/* Define once control variable.  */
#if PTHREAD_ONCE_INIT == 0
/* Special case for static variables where we can avoid the initialization
   if it is zero.  */
# define __libc_once_define(CLASS, NAME) \
  CLASS pthread_once_t NAME
#else
# define __libc_once_define(CLASS, NAME) \
  CLASS pthread_once_t NAME = PTHREAD_ONCE_INIT
#endif
/* Call handler iff the first call.  */
#define __libc_once(ONCE_CONTROL, INIT_FUNCTION) \
  do {                                                                              \
    if (PTFAVAIL (__pthread_once))                                              \
      __libc_ptf_call_always (__pthread_once, (&(ONCE_CONTROL),                      \
                                               INIT_FUNCTION));                      \
    else if ((ONCE_CONTROL) == PTHREAD_ONCE_INIT) {                              \
      INIT_FUNCTION ();                                                              \
      (ONCE_CONTROL) |= 2;                                                      \
    }                                                                              \
  } while (0)
/* Get once control variable.  */
#define __libc_once_get(ONCE_CONTROL)        ((ONCE_CONTROL) != PTHREAD_ONCE_INIT)
/* Note that for I/O cleanup handling we are using the old-style
   cancel handling.  It does not have to be integrated with C++ snce
   no C++ code is called in the middle.  The old-style handling is
   faster and the support is not going away.  */
extern void _pthread_cleanup_push (struct _pthread_cleanup_buffer *buffer,
                                   void (*routine) (void *), void *arg);
extern void _pthread_cleanup_pop (struct _pthread_cleanup_buffer *buffer,
                                  int execute);
extern void _pthread_cleanup_push_defer (struct _pthread_cleanup_buffer *buffer,
                                         void (*routine) (void *), void *arg);
extern void _pthread_cleanup_pop_restore (struct _pthread_cleanup_buffer *buffer,
                                          int execute);
/* Sometimes we have to exit the block in the middle.  */
#define __libc_cleanup_end(DOIT) \
    if (_avail) {                                                              \
      __libc_ptf_call_always (_pthread_cleanup_pop_restore, (&_buffer, DOIT));\
    } else if (DOIT)                                                              \
      _buffer.__routine (_buffer.__arg)

#define __libc_cleanup_push(fct, arg) \
  do {                                                                              \
    struct __pthread_cleanup_frame __clframe                                      \
      __attribute__ ((__cleanup__ (__libc_cleanup_routine)))                      \
      = { .__cancel_routine = (fct), .__cancel_arg = (arg),                      \
          .__do_it = 1 };
#define __libc_cleanup_pop(execute) \
    __clframe.__do_it = (execute);                                              \
  } while (0)
/* Create thread-specific key.  */
#define __libc_key_create(KEY, DESTRUCTOR) \
  __libc_ptf_call (__pthread_key_create, (KEY, DESTRUCTOR), 1)
/* Get thread-specific data.  */
#define __libc_getspecific(KEY) \
  __libc_ptf_call (__pthread_getspecific, (KEY), NULL)
/* Set thread-specific data.  */
#define __libc_setspecific(KEY, VALUE) \
  __libc_ptf_call (__pthread_setspecific, (KEY, VALUE), 0)
/* Register handlers to execute before and after `fork'.  Note that the
   last parameter is NULL.  The handlers registered by the libc are
   never removed so this is OK.  */
extern int __register_atfork (void (*__prepare) (void),
                              void (*__parent) (void),
                              void (*__child) (void),
                              void *__dso_handle);
/* Functions that are used by this file and are internal to the GNU C
   library.  */
extern int __pthread_mutex_init (pthread_mutex_t *__mutex,
                                 const pthread_mutexattr_t *__mutex_attr);
extern int __pthread_mutex_destroy (pthread_mutex_t *__mutex);
extern int __pthread_mutex_trylock (pthread_mutex_t *__mutex);
extern int __pthread_mutex_lock (pthread_mutex_t *__mutex);
extern int __pthread_mutex_unlock (pthread_mutex_t *__mutex);
extern int __pthread_mutexattr_init (pthread_mutexattr_t *__attr);
extern int __pthread_mutexattr_destroy (pthread_mutexattr_t *__attr);
extern int __pthread_mutexattr_settype (pthread_mutexattr_t *__attr,
                                        int __kind);
extern int __pthread_rwlock_init (pthread_rwlock_t *__rwlock,
                                  const pthread_rwlockattr_t *__attr);
extern int __pthread_rwlock_destroy (pthread_rwlock_t *__rwlock);
extern int __pthread_rwlock_rdlock (pthread_rwlock_t *__rwlock);
extern int __pthread_rwlock_tryrdlock (pthread_rwlock_t *__rwlock);
extern int __pthread_rwlock_wrlock (pthread_rwlock_t *__rwlock);
extern int __pthread_rwlock_trywrlock (pthread_rwlock_t *__rwlock);
extern int __pthread_rwlock_unlock (pthread_rwlock_t *__rwlock);
extern int __pthread_key_create (pthread_key_t *__key,
                                 void (*__destr_function) (void *));
extern int __pthread_setspecific (pthread_key_t __key,
                                  const void *__pointer);
extern void *__pthread_getspecific (pthread_key_t __key);
extern int __pthread_once (pthread_once_t *__once_control,
                           void (*__init_routine) (void));
extern int __pthread_atfork (void (*__prepare) (void),
                             void (*__parent) (void),
                             void (*__child) (void));
extern int __pthread_setcancelstate (int state, int *oldstate);
/* Make the pthread functions weak so that we can elide them from
   single-threaded processes.  */
#ifndef __NO_WEAK_PTHREAD_ALIASES
# ifdef weak_extern
weak_extern (__pthread_mutex_init)
weak_extern (__pthread_mutex_destroy)
weak_extern (__pthread_mutex_lock)
weak_extern (__pthread_mutex_trylock)
weak_extern (__pthread_mutex_unlock)
weak_extern (__pthread_mutexattr_init)
weak_extern (__pthread_mutexattr_destroy)
weak_extern (__pthread_mutexattr_settype)
weak_extern (__pthread_rwlock_init)
weak_extern (__pthread_rwlock_destroy)
weak_extern (__pthread_rwlock_rdlock)
weak_extern (__pthread_rwlock_tryrdlock)
weak_extern (__pthread_rwlock_wrlock)
weak_extern (__pthread_rwlock_trywrlock)
weak_extern (__pthread_rwlock_unlock)
weak_extern (__pthread_key_create)
weak_extern (__pthread_setspecific)
weak_extern (__pthread_getspecific)
weak_extern (__pthread_once)
weak_extern (__pthread_initialize)
weak_extern (__pthread_atfork)
weak_extern (__pthread_setcancelstate)
weak_extern (_pthread_cleanup_push_defer)
weak_extern (_pthread_cleanup_pop_restore)
# else
#  pragma weak __pthread_mutex_init
#  pragma weak __pthread_mutex_destroy
#  pragma weak __pthread_mutex_lock
#  pragma weak __pthread_mutex_trylock
#  pragma weak __pthread_mutex_unlock
#  pragma weak __pthread_mutexattr_init
#  pragma weak __pthread_mutexattr_destroy
#  pragma weak __pthread_mutexattr_settype
#  pragma weak __pthread_rwlock_destroy
#  pragma weak __pthread_rwlock_rdlock
#  pragma weak __pthread_rwlock_tryrdlock
#  pragma weak __pthread_rwlock_wrlock
#  pragma weak __pthread_rwlock_trywrlock
#  pragma weak __pthread_rwlock_unlock
#  pragma weak __pthread_key_create
#  pragma weak __pthread_setspecific
#  pragma weak __pthread_getspecific
#  pragma weak __pthread_once
#  pragma weak __pthread_atfork
#  pragma weak __pthread_setcancelstate
#  pragma weak _pthread_cleanup_push_defer
#  pragma weak _pthread_cleanup_pop_restore
# endif
#endif
#endif        /* libc-lockP.h */
