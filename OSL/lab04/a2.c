// Create a orphan process (parent dies before child – adopted by “init” process) and display the PID of parent of child before and after it becomes orphan. Use sleep(n) in the child to delay the termination.

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
        printf("Child process started.\n");
        printf("Child PID           : %d\n", getpid());
        printf("Parent PID (before) : %d\n", getppid());

        sleep(10);

        printf("Parent PID (after)  : %d\n", getppid());
        printf("Child exiting.\n");
    }

    else
    {
        // Parent process
        printf("Parent process running.\n");
        printf("Parent PID : %d\n", getpid());
        printf("Parent exiting now.\n");

        exit(0);
    }

    return 0;
}