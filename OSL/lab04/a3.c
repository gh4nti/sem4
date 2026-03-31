// Modify the program in the previous question to include wait (&status) in the parent and to display the exit return code (left most byte of status) of the child.

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h>

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
        printf("Child process started.\n");
        printf("Child PID  : %d\n", getpid());
        printf("Parent PID : %d\n", getppid());

        sleep(5);

        printf("Child exiting with exit code 7\n");
        exit(7);
    }

    else
    {
        // Parent process
        printf("Parent process running.\n");
        printf("Parent PID : %d\n", getpid());

        wait(&status);

        int exit_code = status >> 8;

        printf("Child terminated.\n");
        printf("Exit return code of child: %d\n", exit_code);
    }

    return 0;
}
