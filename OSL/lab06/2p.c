// Write a producer and consumer program in C using FIFO queue. The producer should write a set of 4 integers into the FIFO queue and the consumer should display the 4 integers.

// Producer program

#include <stdio.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <unistd.h>

int main()
{
    int fd;
    int arr[4];

    mkfifo("myfifo", 0666);

    printf("Producer: Enter 4 integers:\n");
    for (int i = 0; i < 4; i++)
    {
        scanf("%d", &arr[i]);
    }

    fd = open("myfifo", O_WRONLY);
    write(fd, arr, sizeof(arr));

    printf("Producer: Data written to FIFO\n");

    close(fd);
    return 0;
}