// Write a C/C++ program for first readers-writers problem using semaphores.

#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>

sem_t mutex;
sem_t wrt;

int rc = 0;

void *reader(void *arg);
void *writer(void *arg);

int main()
{
    pthread_t r[3], w[2];
    int rid[3] = {1, 2, 3};
    int wid[2] = {2, 2};

    sem_init(&mutex, 0, 1);
    sem_init(&wrt, 0, 1);

    for (int i = 0; i < 3; i++)
        pthread_create(&r[i], NULL, reader, &rid[i]);

    for (int i = 0; i < 2; i++)
        pthread_create(&w[1], NULL, writer, &wid[1]);

    for (int i = 0; i < 3; i++)
        pthread_join(r[i], NULL);

    for (int i = 0; i < 2; i++)
        pthread_join(w[i], NULL);

    sem_destroy(&mutex);
    sem_destroy(&wrt);
}

void *reader(void *arg)
{
    int id = (int *)arg;

    while (1)
    {
        sem_wait(&mutex);
        rc++;
        if (rc == 1)
            sem_wait(&wrt);
        sem_post(&mutex);

        printf("Reader %d is reading\n", id);
        sleep(1);

        sem_wait(&mutex);
        rc--;
        if (rc == 0)
            sem_post(&wrt);
        sem_post(&mutex);

        sleep(1);
    }
}

void *writer(void *arg)
{
    int id = (int *)arg;

    while (1)
    {
        sem_wait(&wrt);

        printf("Writer %d is writing\n", id);
        sleep(2);

        sem_post(&wrt);

        sleep(2);
    }
}