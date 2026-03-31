// Write a multithreaded program that implements the banker's algorithm. Create n threads that request and release resources from the bank. The banker will grant the request only if it leaves the system in a safe state. You may write this program using either Pthreads. It is important that shared data be safe from  concurrent access. To ensure safe access to shared data, you can use mutex locks, which are available in the Pthreads libraries.

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

#define N 5
#define M 3

int available[M] = {3, 3, 2};

int max[N][M] = {
    {7, 5, 3},
    {3, 2, 2},
    {9, 0, 2},
    {2, 2, 2},
    {4, 3, 3}};

int allocation[N][M] = {
    {0, 1, 0},
    {2, 0, 0},
    {3, 0, 2},
    {2, 1, 1},
    {0, 0, 2}};

int need[N][M];

pthread_mutex_t lock;

int isSafe();
int requestResources(int pid, int request[]);
void releaseResources(int pid);
void *process(void *arg);

int main()
{
    pthread_t threads[N];
    int ids[N];

    pthread_mutex_init(&lock, NULL);

    // Calculate Need matrix
    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < M; j++)
        {
            need[i][j] = max[i][j] - allocation[i][j];
        }
    }

    // Create threads
    for (int i = 0; i < N; i++)
    {
        ids[i] = i;
        pthread_create(&threads[i], NULL, process, &ids[i]);
    }

    // Join threads
    for (int i = 0; i < N; i++)
    {
        pthread_join(threads[i], NULL);
    }

    pthread_mutex_destroy(&lock);

    return 0;
}

int isSafe()
{
    int work[M];
    int finish[N] = {0};

    for (int i = 0; i < M; i++)
        work[i] = available[i];

    int count = 0;

    while (count < N)
    {
        int found = 0;

        for (int i = 0; i < N; i++)
        {
            if (!finish[i])
            {
                int j;
                for (j = 0; j < M; j++)
                {
                    if (need[i][j] > work[j])
                        break;
                }

                if (j == M)
                {
                    for (int k = 0; k < M; k++)
                        work[k] += allocation[i][k];

                    finish[i] = 1;
                    found = 1;
                    count++;
                }
            }
        }

        if (!found)
            return 0;
    }

    return 1;
}

int requestResources(int pid, int request[])
{
    pthread_mutex_lock(&lock);

    printf("\nP%d requesting: ", pid);
    for (int i = 0; i < M; i++)
        printf("%d ", request[i]);

    for (int i = 0; i < M; i++)
    {
        if (request[i] > need[pid][i] || request[i] > available[i])
        {
            pthread_mutex_unlock(&lock);
            return 0;
        }
    }

    for (int i = 0; i < M; i++)
    {
        available[i] -= request[i];
        allocation[pid][i] += request[i];
        need[pid][i] -= request[i];
    }

    if (isSafe())
    {
        printf(" -> Granted\n");
        pthread_mutex_unlock(&lock);
        return 1;
    }
    else
    {
        for (int i = 0; i < M; i++)
        {
            available[i] += request[i];
            allocation[pid][i] -= request[i];
            need[pid][i] += request[i];
        }

        printf(" -> Denied (unsafe)\n");
        pthread_mutex_unlock(&lock);
        return 0;
    }
}

void releaseResources(int pid)
{
    pthread_mutex_lock(&lock);

    printf("P%d releasing resources\n", pid);

    for (int i = 0; i < M; i++)
    {
        available[i] += allocation[pid][i];
        allocation[pid][i] = 0;
        need[pid][i] = max[pid][i];
    }

    pthread_mutex_unlock(&lock);
}

void *process(void *arg)
{
    int pid = *((int *)arg);

    int request[M];

    for (int i = 0; i < M; i++)
    {
        request[i] = rand() % (need[pid][i] + 1);
    }

    requestResources(pid, request);
    sleep(1);
    releaseResources(pid);
    pthread_exit(NULL);
}