// Write a C program to simulate multi-level feedback queue scheduling algorithm.

#include <stdio.h>

#define MAX 10

typedef struct
{
    int pid;
    int burst;
    int remaining;
    int completion;
    int waiting;
    int turnaround;
} Process;

int main()
{
    int n, i, time = 0;
    int tq1 = 8, tq2 = 16;

    Process p[MAX];

    printf("Enter number of processes: ");
    scanf("%d", &n);

    for (i = 0; i < n; i++)
    {
        p[i].pid = i + 1;
        printf("Enter burst time for P%d: ", p[i].pid);
        scanf("%d", &p[i].burst);
        p[i].remaining = p[i].burst;
    }

    printf("\nGantt Chart:\n|");

    // Queue 1 (RR - tq = 8)
    for (i = 0; i < n; i++)
    {
        if (p[i].remaining > 0)
        {
            printf(" P%d |", p[i].pid);
            if (p[i].remaining > tq1)
            {
                time += tq1;
                p[i].remaining -= tq1;
            }
            else
            {
                time += p[i].remaining;
                p[i].remaining = 0;
                p[i].completion = time;
            }
        }
    }

    // Queue 2 (RR - tq = 16)
    for (i = 0; i < n; i++)
    {
        if (p[i].remaining > 0)
        {
            printf(" P%d |", p[i].pid);
            if (p[i].remaining > tq2)
            {
                time += tq2;
                p[i].remaining -= tq2;
            }
            else
            {
                time += p[i].remaining;
                p[i].remaining = 0;
                p[i].completion = time;
            }
        }
    }

    // Queue 3 (FCFS)
    for (i = 0; i < n; i++)
    {
        if (p[i].remaining > 0)
        {
            printf(" P%d |", p[i].pid);
            time += p[i].remaining;
            p[i].remaining = 0;
            p[i].completion = time;
        }
    }

    float avgWT = 0, avgTAT = 0;

    printf("\n\nPID\tBT\tWT\tTAT\n");
    for (i = 0; i < n; i++)
    {
        p[i].turnaround = p[i].completion;
        p[i].waiting = p[i].turnaround - p[i].burst;

        avgWT += p[i].waiting;
        avgTAT += p[i].turnaround;

        printf("P%d\t%d\t%d\t%d\n",
               p[i].pid, p[i].burst, p[i].waiting, p[i].turnaround);
    }

    printf("\nAverage Waiting Time = %.2f", avgWT / n);
    printf("\nAverage Turnaround Time = %.2f\n", avgTAT / n);

    return 0;
}