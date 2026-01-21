// Write a C program to implement SJF, where the arrival time is different for the processes.

#include <stdio.h>
#include <limits.h>

int main()
{
    int n, i, completed = 0, time = 0;
    int pid[20], arrival[20], burst[20];
    int waiting[20], turnaround[20], completion[20];
    int done[20] = {0};

    float avgWT = 0, avgTAT = 0;

    printf("Enter number of processes: ");
    scanf("%d", &n);

    for (i = 0; i < n; i++)
    {
        pid[i] = i + 1;
        printf("Enter Arrival Time and Burst Time for P%d: ", pid[i]);
        scanf("%d %d", &arrival[i], &burst[i]);
    }

    printf("\nGantt Chart:\n|");

    while (completed < n)
    {
        int idx = -1;
        int minBurst = INT_MAX;

        for (i = 0; i < n; i++)
        {
            if (arrival[i] <= time && !done[i] && burst[i] < minBurst)
            {
                minBurst = burst[i];
                idx = i;
            }
        }

        if (idx == -1)
        {
            time++;
            continue;
        }

        printf(" P%d |", pid[idx]);

        time += burst[idx];
        completion[idx] = time;
        turnaround[idx] = completion[idx] - arrival[idx];
        waiting[idx] = turnaround[idx] - burst[idx];

        done[idx] = 1;
        completed++;
    }

    printf("\n\nPID\tAT\tBT\tWT\tTAT\n");
    for (i = 0; i < n; i++)
    {
        avgWT += waiting[i];
        avgTAT += turnaround[i];

        printf("P%d\t%d\t%d\t%d\t%d\n",
               pid[i], arrival[i], burst[i], waiting[i], turnaround[i]);
    }

    printf("\nAverage Waiting Time = %.2f", avgWT / n);
    printf("\nAverage Turnaround Time = %.2f\n", avgTAT / n);

    return 0;
}
