// Write a C/C++  program for Dining-Philosophers problem using semaphores.

#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>

#define N 5

#define THINKING 0
#define HUNGRY 1
#define EATING 2

int state[N];
int phil[N] = {0, 1, 2, 3, 4};

sem_t mutex;
sem_t S[N];

int LEFT(int i);
int RIGHT(int i);
void test(int i);
void take_fork(int i);
void put_fork(int i);
void *philosopher(void *num);

int main()
{
    pthread_t thread_id[N];

    sem_init(&mutex, 0, 1);

    for (int i = 0; i < N; i++)
        sem_init(&S[i], 0, 0);

    for (int i = 0; i < N; i++)
        pthread_create(&thread_id[i], NULL, philosopher, &phil[i]);

    for (int i = 0; i < N; i++)
        pthread_join(thread_id[i], NULL);

    return 0;
}

int LEFT(int i) { return (i + N - 1) % N; }
int RIGHT(int i) { return (i + 1) % N; }

void test(int i)
{
    if (state[i] == HUNGRY &&
        state[LEFT(i)] != EATING &&
        state[RIGHT(i)] != EATING)
    {

        state[i] = EATING;
        sem_post(&S[i]);
    }
}

void take_fork(int i)
{
    sem_wait(&mutex);

    state[i] = HUNGRY;
    printf("Philosopher %d is Hungry\n", i + 1);

    test(i);

    sem_post(&mutex);

    sem_wait(&S[i]);
}

void put_fork(int i)
{
    sem_wait(&mutex);

    state[i] = THINKING;
    printf("Philosopher %d is Thinking\n", i + 1);

    test(LEFT(i));
    test(RIGHT(i));

    sem_post(&mutex);
}

void *philosopher(void *num)
{
    int i = *(int *)num;

    while (1)
    {

        printf("Philosopher %d is Thinking\n", i + 1);
        sleep(1);

        take_fork(i);

        printf("Philosopher %d is Eating\n", i + 1);
        sleep(2);

        put_fork(i);
    }
}