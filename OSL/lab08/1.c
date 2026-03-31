// Consider the following snapshot of the system. Write C/C++ program to implement Banker's algorithm for deadlock avoidance. The program has to accept all inputs from the user. Assume the total number of instances of A, B and C are 10, 5 and 7 respectively.

#include <stdio.h>
#include <stdbool.h>

int main()
{
    int n, m;

    printf("Enter number of processes: ");
    scanf("%d", &n);

    printf("Enter number of resources: ");
    scanf("%d", &m);

    int alloc[n][m], max[n][m], need[n][m], avail[m];

    printf("\nEnter Allocation matrix:\n");
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < m; j++)
        {
            scanf("%d", &alloc[i][j]);
        }
    }

    printf("\nEnter Max matrix:\n");
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < m; j++)
        {
            scanf("%d", &max[i][j]);
        }
    }

    printf("\nEnter Available resources:\n");
    for (int i = 0; i < m; i++)
    {
        scanf("%d", &avail[i]);
    }

    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < m; j++)
        {
            need[i][j] = max[i][j] - alloc[i][j];
        }
    }

    bool finish[n];
    int safeSeq[n];

    for (int i = 0; i < n; i++)
    {
        finish[i] = false;
    }

    int count = 0;

    while (count < n)
    {
        bool found = false;

        for (int i = 0; i < n; i++)
        {
            if (!finish[i])
            {
                bool possible = true;

                for (int j = 0; j < m; j++)
                {
                    if (need[i][j] > avail[j])
                    {
                        possible = false;
                        break;
                    }
                }

                if (possible)
                {
                    for (int j = 0; j < m; j++)
                    {
                        avail[j] += alloc[i][j];
                    }

                    safeSeq[count++] = i;
                    finish[i] = true;
                    found = true;
                }
            }
        }

        if (!found)
        {
            printf("\nSystem is NOT in a safe state.\n");
            return 0;
        }
    }

    printf("\nSystem is in SAFE state.\nSafe sequence: ");
    for (int i = 0; i < n; i++)
    {
        printf("P%d ", safeSeq[i]);
    }

    printf("\n");

    return 0;
}