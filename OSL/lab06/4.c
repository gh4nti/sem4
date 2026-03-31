// Write a producer-consumer program in C in which producer writes a set of words into shared memory and then consumer reads the set of words from the shared memory. The shared memory need to be detached and deleted after use.

#include <stdio.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <unistd.h>
#include <string.h>
#include <sys/wait.h>

int main()
{
    key_t key;
    int shmid;
    char *shm;

    key = ftok("shmfile", 75);
    shmid = shmget(key, 1024, 0666 | IPC_CREAT);
    shm = (char *)shmat(shmid, NULL, 0);

    if (fork() == 0)
    {
        sleep(1);

        printf("Consumer read from shared memory:\n");
        printf("%s\n", shm);

        shmdt(shm);
    }
    else
    {
        char words[1024];

        printf("Producer: Enter a set of words:\n");
        fgets(words, sizeof(words), stdin);

        strcpy(shm, words);

        wait(NULL);

        shmdt(shm);
        shmctl(shmid, IPC_RMID, NULL);
    }
    return 0;
}