// Demonstrate creation, writing to and reading from a pipe.

#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <sys/wait.h>

int main()
{
    int fd[2];
    char write_msg[] = "Hello from Parent Process";
    char read_msg[100];

    if (pipe(fd) == -1)
    {
        perror("Pipe failed\n");
        return -1;
    }

    if (fork() == 0)
    {
        close(fd[1]);

        read(fd[0], read_msg, sizeof(read_msg));
        printf("Child read: %s\n", read_msg);

        close(fd[0]);
    }
    else
    {
        close(fd[0]);

        write(fd[1], write_msg, strlen(write_msg) + 1);
        printf("Parent wrote: %s\n", write_msg);

        close(fd[1]);
        wait(NULL);
    }
    return 0;
}