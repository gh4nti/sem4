// Demonstrate creation of a process which writes through a pipe while the parent process reads from it.

#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <sys/wait.h>

int main()
{
    int fd[2];
    char buffer[100];

    if (pipe(fd) == -1)
    {
        perror("Pipe creation failed");
        return 1;
    }

    if (fork() == 0)
    {
        close(fd[0]);

        char msg[] = "Message from Child Process";
        write(fd[1], msg, strlen(msg) + 1);

        close(fd[1]);
    }
    else
    {
        close(fd[1]);

        read(fd[0], buffer, sizeof(buffer));
        printf("Parent read: %s\n", buffer);

        close(fd[0]);
        wait(NULL);
    }
    return 0;
}
