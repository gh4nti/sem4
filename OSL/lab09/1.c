// Write a C/C++ program to simulate First-fit, Best-fit and Worst-fit strategies. Given memory partitions of 100K, 500K, 200K, 300K, and 600K(in order), how would each of the First-fit, Best-fit, and Worst-fit algorithms place processes of 212K, 417K, 112K, and 426K (in order)? Which algorithm makes efficient use of memory?

#include <stdio.h>

void firstFit(int blkSize[], int m, int procSize[], int n);
void bestFit(int blkSize[], int m, int procSize[], int n);
void worstFit(int blkSize[], int m, int procSize[], int n);

int main()
{
    int blkSize1[] = {100, 500, 200, 300, 600};
    int blkSize2[] = {100, 500, 200, 300, 600};
    int blkSize3[] = {100, 500, 200, 300, 600};

    int procSize[] = {212, 417, 112, 426};

    int m = 5, n = 4;

    firstFit(blkSize1, m, procSize, n);
    bestFit(blkSize2, m, procSize, n);
    worstFit(blkSize3, m, procSize, n);

    return 0;
}

void firstFit(int blkSize[], int m, int procSize[], int n)
{
    int alloc[n];

    for (int i = 0; i < n; i++)
        alloc[i] = -1;

    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < m; j++)
        {
            if (blkSize[j] >= procSize[i])
            {
                alloc[i] = j;
                blkSize[j] -= procSize[i];
                break;
            }
        }
    }

    printf("\nFirst Fit Allocation:\n");
    for (int i = 0; i < n; i++)
    {
        if (alloc[i] != -1)
            printf("Process %d (%dK) -> Block %d\n", i + 1, procSize[i], alloc[i] + 1);
        else
            printf("Process %d (%dK) -> Not Allocated\n", i + 1, procSize[i]);
    }
}

void bestFit(int blkSize[], int m, int procSize[], int n)
{
    int alloc[n];

    for (int i = 0; i < n; i++)
        alloc[i] = -1;

    for (int i = 0; i < n; i++)
    {
        int idx = -1;
        for (int j = 0; j < m; j++)
        {
            if (blkSize[j] >= procSize[i])
            {
                if (idx == -1 || blkSize[j] < blkSize[idx])
                    idx = j;
            }
        }

        if (idx != -1)
        {
            alloc[i] = idx;
            blkSize[idx] -= procSize[i];
        }
    }

    printf("\nBest Fit Allocation:\n");
    for (int i = 0; i < n; i++)
    {
        if (alloc[i] != -1)
            printf("Process %d (%dK) -> Block %d\n", i + 1, procSize[i], alloc[i] + 1);
        else
            printf("Process %d (%dK) -> Not Allocated\n", i + 1, procSize[i]);
    }
}

void worstFit(int blkSize[], int m, int procSize[], int n)
{
    int alloc[n];

    for (int i = 0; i < n; i++)
        alloc[i] = -1;

    for (int i = 0; i < n; i++)
    {
        int idx = -1;
        for (int j = 0; j < m; j++)
        {
            if (blkSize[j] >= procSize[i])
            {
                if (idx == -1 || blkSize[j] > blkSize[idx])
                    idx = j;
            }
        }

        if (idx != -1)
        {
            alloc[i] = idx;
            blkSize[idx] -= procSize[i];
        }
    }

    printf("\nWorst Fit Allocation:\n");
    for (int i = 0; i < n; i++)
    {
        if (alloc[i] != -1)
            printf("Process %d (%dK) -> Block %d\n", i + 1, procSize[i], alloc[i] + 1);
        else
            printf("Process %d (%dK) -> Not Allocated\n", i + 1, procSize[i]);
    }
}