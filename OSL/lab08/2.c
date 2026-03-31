// Consider the following snapshot of the system. Write C/C++ program to implement deadlock detection algorithm.

#include <stdio.h>
#include <stdbool.h>

int main()
{
    int n, m;

    printf("Enter number of processes: ");
    scanf("%d", &n);

    printf("Enter number of resources: ");
    scanf("%d", &m);

    int alloc[n][m], request[n][m], avail[m];

    printf("\nEnter Allocation matrix:\n");
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < m; j++)
        {
            scanf("%d", &alloc[i][j]);
        }
    }

    printf("\nEnter Request matrix:\n");
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < m; j++)
        {
            scanf("%d", &request[i][j]);
        }
    }

    printf("\nEnter Available vector:\n");
    for (int i = 0; i < m; i++)
    {
        scanf("%d", &avail[i]);
    }

    int work[m];
    bool finish[n];

    for (int i = 0; i < m; i++)
        work[i] = avail[i];

    for (int i = 0; i < n; i++)
        finish[i] = false;

    bool progress = true;

    while (progress)
    {
        progress = false;

        for (int i = 0; i < n; i++)
        {
            if (!finish[i])
            {
                bool canRun = true;

                for (int j = 0; j < m; j++)
                {
                    if (request[i][j] > work[j])
                    {
                        canRun = false;
                        break;
                    }
                }

                if (canRun)
                {
                    for (int j = 0; j < m; j++)
                    {
                        work[j] += alloc[i][j];
                    }
                    finish[i] = true;
                    progress = true;
                }
            }
        }
    }

    bool deadlock = false;

    printf("\nProcesses in deadlock:\n");
    for (int i = 0; i < n; i++)
    {
        if (!finish[i])
        {
            printf("P%d ", i);
            deadlock = true;
        }
    }

    if (!deadlock)
        printf("None (System is safe)");

    printf("\n");

    return 0;
}