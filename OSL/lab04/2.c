// Write a C program to load the binary executable of the previous program in a child process using exec system call.

#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

int main()
{
    pid_t pid;

    pid = fork();

    if (pid < 0)
    {
        perror("Fork failed\n");
        return 1;
    }

    else if (pid == 0)
    {
        // Child process
        printf("\n--- Child Process ---\n");
        printf("Child PID  : %d\n", getpid());
        printf("Parent PID : %d\n", getppid());

        execl("./1", "1", NULL);

        perror("Exec failed");
    }

    else
    {
        // Parent process
        printf("\n--- Parent Process ---\n");
        printf("Parent PID : %d\n", getpid());
        printf("Waiting for child to complete...\n");

        wait(NULL);

        printf("Child process completed.\n");
    }

    return 0;
}
