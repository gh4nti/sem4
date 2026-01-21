// Write a multithreaded program that performs different sorting algorithms. The program should work as follows: the user enters on the command line the number of elements to sort and the elements themselves. The program then creates separate threads, each using a different sorting algorithm. Each thread sorts the array using its corresponding algorithm and displays the time taken to produce the result. The main thread waits for all threads to finish and then displays the final sorted array.

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <time.h>
#include <string.h>

int n;
int *orig, *sorted;

void swap(int *x, int *y);
void bubbleSort(int *arr, int n);
void selectionSort(int *arr, int n);
void insertionSort(int *arr, int n);
void sort_thread(void *arg);

int main(int argc, char *argv[])
{
    if (argc < 3)
    {
        printf("Usage: %s <n> <elements>\n", argv[0]);
        return 1;
    }

    n = atoi(argv[1]);

    orig = (int *)malloc(n * sizeof(int));
    sorted = (int *)malloc(n * sizeof(int));

    for (int i = 0; i < n; i++)
        orig[i] = atoi(argv[i + 2]);

    pthread_t t1, t2, t3;

    pthread_create(&t1, NULL, sort_thread, "bubble");
    pthread_create(&t2, NULL, sort_thread, "selection");
    pthread_create(&t3, NULL, sort_thread, "insertion");

    pthread_join(t1, NULL);
    pthread_join(t2, NULL);
    pthread_join(t3, NULL);

    printf("\nFinal Sorted Array:\n");
    for (int i = 0; i < n; i++)
        printf("%d ", sorted[i]);
    printf("\n");

    free(orig);
    free(sorted);

    return 0;
}

void swap(int *x, int *y)
{
    int temp = *x;
    *x = *y;
    *y = temp;
}

void bubbleSort(int *arr, int n)
{
    for (int i = 0; i < n - 1; i++)
        for (int j = 0; j < n - i - 1; j++)
            if (arr[j] > arr[j + 1])
                swap(&arr[j], &arr[j + 1]);
}

void selectionSort(int *arr, int n)
{
    for (int i = 0; i < n - 1; i++)
    {
        int min = i;
        for (int j = i + 1; j < n; j++)
            if (arr[j] < arr[min])
                min = j;
        swap(&arr[min], &arr[i]);
    }
}

void insertionSort(int *arr, int n)
{
    for (int i = 1; i < n; i++)
    {
        int key = arr[i], j = i - 1;
        while (j >= 0 && arr[j] > key)
        {
            arr[j + 1] = arr[j];
            j--;
        }
        arr[j + 1] = key;
    }
}

void sort_thread(void *arg)
{
    char *algo = (char *)arg;

    int *arr = (int *)malloc(n * sizeof(int));
    memcpy(arr, orig, n * sizeof(int));

    clock_t start = clock();

    if (strcmp(algo, "bubble") == 0)
        bubbleSort(arr, n);
    else if (strcmp(algo, "selection") == 0)
        selectionSort(arr, n);
    else if (strcmp(algo, "insertion") == 0)
        insertionSort(arr, n);

    clock_t end = clock();
    double time = (double)(end - start) / CLOCKS_PER_SEC;

    printf("%s sort completed in %f seconds\n", algo, time);

    memcpy(sorted, arr, n * sizeof(int));

    free(arr);
    pthread_exit(NULL);
}