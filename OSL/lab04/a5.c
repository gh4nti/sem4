// Write a multithreaded program for matrix multiplication.

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define MAX 10

int A[MAX][MAX], B[MAX][MAX], C[MAX][MAX];
int r1, c1, r2, c2;

typedef struct
{
    int row;
} thread_data;

void *mult_row(void *arg);

int main()
{
    pthread_t threads[MAX];
    thread_data td[MAX];

    printf("Enter rows and columns of Matrix A: ");
    scanf("%d %d", &r1, &c1);

    printf("Enter rows and columns of Matrix B: ");
    scanf("%d %d", &r2, &c2);

    if (c1 != r2)
    {
        printf("Matrix multiplication not possible!\n");
        return 1;
    }

    printf("Enter elements of Matrix A:\n");
    for (int i = 0; i < r1; i++)
        for (int j = 0; j < c1; j++)
            scanf("%d", &A[i][j]);

    printf("Enter elements of Matrix B:\n");
    for (int i = 0; i < r2; i++)
        for (int j = 0; j < c2; j++)
            scanf("%d", &B[i][j]);

    for (int i = 0; i < r1; i++)
    {
        td[i].row = i;
        pthread_create(&threads[i], NULL, mult_row, &td[i]);
    }

    for (int i = 0; i < r1; i++)
        pthread_join(threads[i], NULL);

    printf("Resultant Matrix C:\n");
    for (int i = 0; i < r1; i++)
    {
        for (int j = 0; j < c2; j++)
            printf("%d ", C[i][j]);
        printf("\n");
    }

    return 0;
}

void *mult_row(void *arg)
{
    thread_data *data = (thread_data *)arg;
    int row = data->row;

    for (int j = 0; j < c2; j++)
    {
        C[row][j] = 0;
        for (int k = 0; k < c1; k++)
            C[row][j] += A[row][k] * B[k][j];
    }

    pthread_exit(NULL);
}