// Modify the above Producer-Consumer program so that, a producer can produce at the most 10 items more than what the consumer has consumed.

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

#define MAX 10

int prod_count = 0, cons_count = 0;

pthread_mutex_t mutex;
pthread_cond_t cond;

void *producer(void *arg);
void *consumer(void *arg);

int main()
{
    pthread_t prod, cons;

    pthread_mutex_init(&mutex, NULL);
    pthread_cond_init(&cond, NULL);

    pthread_create(&prod, NULL, producer, NULL);
    pthread_create(&cons, NULL, consumer, NULL);

    pthread_join(prod, NULL);
    pthread_join(cons, NULL);

    pthread_mutex_destroy(&mutex);
    pthread_cond_destroy(&cond);

    return 0;
}

void *producer(void *arg)
{
    while (1)
    {
        pthread_mutex_lock(&mutex);

        while (prod_count - cons_count >= MAX)
        {
            printf("Producer waiting... Limit reached\n");
            pthread_cond_wait(&cond, &mutex);
        }

        prod_count++;
        printf("Produced item %d\n", prod_count);

        pthread_cond_signal(&cond);
        pthread_mutex_unlock(&mutex);

        sleep(1);
    }
}

void *consumer(void *arg)
{
    while (1)
    {
        pthread_mutex_lock(&mutex);

        while (prod_count == cons_count)
        {
            printf("Consumer waiting... No items\n");
            pthread_cond_wait(&cond, &mutex);
        }

        cons_count++;
        printf("Consumed item %d\n", cons_count);

        pthread_cond_signal(&cond);
        pthread_mutex_unlock(&mutex);

        sleep(2);
    }
}