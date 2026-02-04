// Write a producer and consumer program in C using FIFO queue. The producer should write a set of 4 integers into the FIFO queue and the consumer should display the 4 integers.

// Consumer program

#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>

int main()
{
    int fd;
    int arr[4];

    fd = open("myfifo", O_RDONLY);

    read(fd, arr, sizeof(arr));

    printf("Consumer: Data read from FIFO:\n");
    for (int i = 0; i < 4; i++)
        printf("%d ", arr[i]);

    printf("\n");

    close(fd);
    return 0;
}