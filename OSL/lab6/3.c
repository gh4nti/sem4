// Implement a parent process, which sends an English alphabet to child process using shared memory. Child process responds back with next English alphabet to the parent. Parent displays the reply from the Child.

#include <stdio.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <unistd.h>
#include <sys/wait.h>

int main()
{
    key_t key;
    int shmid;
    char *shm;

    key = ftok("shmfile", 65);
    shmid = shmget(key, sizeof(char), 0666 | IPC_CREAT);
    shm = (char *)shmat(shmid, NULL, 0);

    if (fork() == 0)
    {
        sleep(1);

        char received = *shm;
        printf("Child received: %c\n", received);

        if (received == 'Z' || received == 'z')
            *shm = received;
        else
            *shm = received + 1;

        shmdt(shm);
    }
    else
    {
        char ch;
        printf("Parent: Enter an English alphabet: ");
        scanf(" %c", &ch);

        *shm = ch;

        wait(NULL);

        printf("Parent received reply from child: %c\n", *shm);

        shmdt(shm);
        shmctl(shmid, IPC_RMID, NULL);
    }
    return 0;
}