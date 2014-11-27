/**
 * @file    utils.c
 *
 * @brief   General/Generic functions for the fwknop server.
 *
 *  Fwknop is developed primarily by the people listed in the file 'AUTHORS'.
 *  Copyright (C) 2009-2014 fwknop developers and contributors. For a full
 *  list of contributors, see the file 'CREDITS'.
 *
 *  License (GNU General Public License):
 *
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU General Public License
 *  as published by the Free Software Foundation; either version 2
 *  of the License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
 *  USA
 */

#include "fwknopd_common.h"
#include "utils.h"
#include "log_msg.h"
#include <stdarg.h>

#define ASCII_LEN 16

/* Generic hex dump function.
*/
void
hex_dump(const unsigned char *data, const int size)
{
    int ln=0, i=0, j=0;
    char ascii_str[ASCII_LEN+1] = {0};

    for(i=0; i<size; i++)
    {
        if((i % ASCII_LEN) == 0)
        {
            printf(" %s\n  0x%.4x:  ", ascii_str, i);
            memset(ascii_str, 0x0, ASCII_LEN-1);
            j = 0;
        }

        printf("%.2x ", data[i]);

        ascii_str[j++] = (data[i] < 0x20 || data[i] > 0x7e) ? '.' : data[i];

        if(j == 8)
            printf(" ");
    }

    /* Remainder...
    */
    ln = strlen(ascii_str);
    if(ln > 0)
    {
        for(i=0; i < ASCII_LEN-ln; i++)
            printf("   ");
        if(ln < 8)
            printf(" ");

        printf(" %s\n\n", ascii_str);
    }
    return;
}

/* Basic directory checks (stat() and whether the path is actually
 * a directory).
*/
int
is_valid_dir(const char *path)
{
#if HAVE_STAT
    struct stat st;

    /* If we are unable to stat the given dir, then return with error.
    */
    if(stat(path, &st) != 0)
    {
        log_msg(LOG_ERR, "[-] unable to stat() directory: %s: %s",
            path, strerror(errno));
        return(0);
    }

    if(!S_ISDIR(st.st_mode))
        return(0);
#endif /* HAVE_STAT */

    return(1);
}

int
verify_file_perms_ownership(const char *file)
{
#if HAVE_STAT
    struct stat st;

    /* Every file that fwknopd deals with should be owned
     * by the user and permissions set to 600 (user read/write)
    */
    if((stat(file, &st)) == 0)
    {
        /* Make sure it is a regular file
        */
        if(S_ISREG(st.st_mode) != 1 && S_ISLNK(st.st_mode) != 1)
        {
            log_msg(LOG_WARNING,
                "[-] file: %s is not a regular file or symbolic link.",
                file
            );
            return 0;
        }

        if((st.st_mode & (S_IRWXU|S_IRWXG|S_IRWXO)) != (S_IRUSR|S_IWUSR))
        {
            log_msg(LOG_WARNING,
                "[-] file: %s permissions should only be user read/write (0600, -rw-------)",
                file
            );
            /* when we start in enforcing this instead of just warning
             * the user
            res = 0;
            */
        }

        if(st.st_uid != getuid())
        {
            log_msg(LOG_WARNING, "[-] file: %s not owned by current effective user id",
                file);
            /* when we start in enforcing this instead of just warning
             * the user
            res = 0;
            */
        }
    }
    else
    {
        /* if the path doesn't exist, just return, but otherwise something
         * went wrong
        */
        if(errno != ENOENT)
        {
            log_msg(LOG_ERR, "[-] stat() against file: %s returned: %s",
                file, strerror(errno));
            return 0;
        }
    }

#endif

    return 1;
}

static int
add_argv(char **argv_new, int *argc_new,
        const char *new_arg, const fko_srv_options_t * const opts)
{
    int buf_size = 0;

    if(opts->verbose > 3)
        log_msg(LOG_INFO, "[+] add_argv() + arg: %s", new_arg);

    buf_size = strlen(new_arg) + 1;
    argv_new[*argc_new] = calloc(1, buf_size);

    if(argv_new[*argc_new] == NULL)
    {
        log_msg(LOG_INFO, "[*] Memory allocation error.");
        return 0;
    }
    strlcpy(argv_new[*argc_new], new_arg, buf_size);

    *argc_new += 1;

    if(*argc_new >= MAX_CMDLINE_ARGS-1)
    {
        log_msg(LOG_ERR, "[*] max command line args exceeded.");
        return 0;
    }

    argv_new[*argc_new] = NULL;

    return 1;
}

int
strtoargv(const char * const args_str, char **argv_new, int *argc_new,
        const fko_srv_options_t * const opts)
{
    int       current_arg_ctr = 0, i;
    char      arg_tmp[MAX_LINE_LEN] = {0};

    for (i=0; i < (int)strlen(args_str); i++)
    {
        if (!isspace(args_str[i]))
        {
            arg_tmp[current_arg_ctr] = args_str[i];
            current_arg_ctr++;
        }
        else
        {
            if(current_arg_ctr > 0)
            {
                arg_tmp[current_arg_ctr] = '\0';
                if (add_argv(argv_new, argc_new, arg_tmp, opts) != 1)
                {
                    free_argv(argv_new, argc_new);
                    return 0;
                }
                current_arg_ctr = 0;
            }
        }
    }

    /* pick up the last argument in the string
    */
    if(current_arg_ctr > 0)
    {
        arg_tmp[current_arg_ctr] = '\0';
        if (add_argv(argv_new, argc_new, arg_tmp, opts) != 1)
        {
            free_argv(argv_new, argc_new);
            return 0;
        }
    }
    return 1;
}

void
free_argv(char **argv_new, int *argc_new)
{
    int i;

    if(argv_new == NULL || *argv_new == NULL)
        return;

    for (i=0; i < *argc_new; i++)
    {
        if(argv_new[i] == NULL)
            break;
        else
            free(argv_new[i]);
    }
    return;
}

/***EOF***/
