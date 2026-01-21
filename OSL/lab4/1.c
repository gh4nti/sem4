// Write a C program to create a child process. Display different messages in parent @id:ms-vscode.cpptools-extension-packprocess and child process. Display PID and PPID of both parent and child process. Block  parent process until child completes using wait system call.

#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

int main()
{
    pid_t pid;

    pid = fork();

    if (pid < 0)
        printf("Failed to create child process\n");

    else if (pid == 0)
    {
        // Child process
        printf("\n--- Child Process ---\n");
        printf("Child PID  : %d\n", getpid());
        printf("Parent PID : %d\n", getppid());
        printf("Child process is executing...\n");
    }

    else
    {
        // Parent process
        printf("\n--- Parent Process ---\n");
        printf("Parent PID : %d\n", getpid());
        printf("Child PID  : %d\n", pid);

        wait(NULL);

        printf("Child process has completed.\n");
        printf("Parent process resumes execution.\n");
    }

    return 0;
}