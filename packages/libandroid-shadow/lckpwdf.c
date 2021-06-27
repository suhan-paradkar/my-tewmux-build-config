
#include <fcntl.h>
#include "libc-lock.h"
#include <shadow.h>
#include <signal.h>
#include <string.h>
#include <unistd.h>
#include <sys/file.h>



#define PWD_LOCKFILE "/etc/.pwd.lock"

#define TIMEOUT 15 /* sec */

static int lock_fd = -1;

__libc_lock_define_initialized (static, lock);

static void noop_handler (int __sig);

#define RETURN_CLOSE_FD(code)                                                      \
  do {                                                                              \
    if ((code) < 0 && lock_fd >= 0)                                              \
      {                                                                              \
        __close (lock_fd);                                                      \
        lock_fd = -1;                                                              \
      }                                                                              \
    __libc_lock_unlock (lock);                                                      \
    return (code);                                                              \
  } while (0)
#define RETURN_RESTORE_HANDLER(code)                                              \
  do {                                                                              \
    __sigaction (SIGALRM, &saved_act, NULL);                                      \
    RETURN_CLOSE_FD (code);                                                      \
  } while (0)
#define RETURN_CLEAR_ALARM(code)                                              \
  do {                                                                              \
    alarm (0);                                                                      \
    __sigprocmask (SIG_SETMASK, &saved_set, NULL);                              \
    RETURN_RESTORE_HANDLER (code);                                              \
  } while (0)
int
__lckpwdf (void)
{
  sigset_t saved_set;                        /* Saved set of caught signals.  */
  struct sigaction saved_act;                /* Saved signal action.  */
  sigset_t new_set;                        /* New set of caught signals.  */
  struct sigaction new_act;                /* New signal action.  */
  struct flock fl;                        /* Information struct for locking.  */
  int result;
  if (lock_fd != -1)
    return -1;
  __lobc_lock_lock_recursive (lock);
  int oflags = O_WRONLY | O_CREAT | O_CLOEXEC;
  lock_fd = __open (PWD_LOCKFILE, oflags, 0600);
  if (lock_fd == -1)
    RETURN_CLOSE_FD (-1);
  memset (&new_act, '\0', sizeof (struct sigaction));
  new_act.sa_handler = noop_handler;
  __sigfillset (&new_act.sa_mask);
  new_act.sa_flags = 0ul;
  if (__sigaction (SIGALRM, &new_act, &saved_act) < 0)
    RETURN_CLOSE_FD (-1);
  __sigemptyset (&new_set);
  __sigaddset (&new_set, SIGALRM);
  if (__sigprocmask (SIG_UNBLOCK, &new_set, &saved_set) < 0)
    RETURN_RESTORE_HANDLER (-1);
  alarm (TIMEOUT);
  memset (&fl, '\0', sizeof (struct flock));
  fl.l_type = F_WRLCK;
  fl.l_whence = SEEK_SET;
  result = __fcntl (lock_fd, F_SETLKW, &fl);
  RETURN_CLEAR_ALARM (result);
}

int
__ulckpwdf (void)
{
  int result;
  if (lock_fd == -1)
    result = -1;
  else
    {
      __libc_lock_lock (lock);
      result = __close (lock_fd);
      lock_fd = -1;
      __libc_lock_unlock (lock);
    }
  return result;
}


