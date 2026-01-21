// Create a zombie (defunct) child process (a child with exit() call, but no corresponding wait() in the sleeping parent) and allow the init process to adopt it (after parent terminates). Run the process as background process and run “ps” command.

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>

int main()
{
    pid_t pid;

    pid = fork();

    if (pid < 0)
    {
        perror("Fork failed");
        exit(1);
    }

    else if (pid == 0)
    {
        // Child process
        printf("Child process created.\n");
        printf("Child PID  : %d\n", getpid());
        printf("Parent PID : %d\n", getppid());

        exit(0);
    }

    else
    {
        // Parent process
        printf("Parent process running.\n");
        printf("Parent PID : %d\n", getpid());
        printf("Child PID  : %d\n", pid);

        sleep(20);

        printf("Parent exiting now.\n");
    }

    return 0;
}