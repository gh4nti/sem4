// Create a child process which returns a 0 exit status when the minute of time is odd and returning a non-zero (can be 1) status when the minute of time is even.

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <time.h>

int main()
{
    pid_t pid;
    int status;

    pid = fork();

    if (pid < 0)
    {
        perror("Fork failed");
        exit(1);
    }

    else if (pid == 0)
    {
        // Child process
        time_t t = time(NULL);
        struct tm *tm_info = localtime(&t);

        int minute = tm_info->tm_min;

        printf("Child PID : %d\n", getpid());
        printf("Current minute: %d\n", minute);

        if (minute % 2 == 1)
        {
            printf("Minute is ODD → exiting with status 0\n");
            exit(0);
        }

        else
        {
            printf("Minute is EVEN → exiting with status 1\n");
            exit(1);
        }
    }

    else
    {
        // Parent process
        wait(&status);

        if (WIFEXITED(status))
        {
            int exit_code = WEXITSTATUS(status);
            printf("Parent PID : %d\n", getpid());
            printf("Child exit status: %d\n", exit_code);
        }
    }

    return 0;
}
