// Write a C program to simulate Earliest-Deadline-First scheduling for real time systems.

#include <stdio.h>
#include <limits.h>

int main()
{
    int n, completed = 0, time = 0;
    int pid[20], burst[20], deadline[20];
    int completion[20], waiting[20], turnaround[20];
    int done[20] = {0};

    float avgWT = 0, avgTAT = 0;

    printf("Enter no. of processes: ");
    scanf("%d", &n);

    for (int i = 0; i < n; i++)
    {
        pid[i] = i + 1;
        printf("Enter Burst Time and Deadline for P%d: ", pid[i]);
        scanf("%d %d", &burst[i], &deadline[i]);
    }

    printf("\nGantt Chart:\n|");

    while (completed < n)
    {
        int idx = -1;
        int minDeadline = INT_MAX;

        for (int i = 0; i < n; i++)
        {
            if (!done[i] && deadline[i] < minDeadline)
            {
                minDeadline = deadline[i];
                idx = i;
            }
        }

        printf(" P%d |", pid[idx]);

        time += burst[idx];
        completion[idx] = time;
        turnaround[idx] = completion[idx];
        waiting[idx] = turnaround[idx] - burst[idx];

        done[idx] = 1;
        completed++;
    }

    printf("\n\nPID\tBT\tDL\tWT\tTAT\n");
    for (int i = 0; i < n; i++)
    {
        avgWT += waiting[i];
        avgTAT += turnaround[i];

        printf("P%d\t%d\t%d\t%d\t%d\n",
               pid[i], burst[i], deadline[i], waiting[i], turnaround[i]);
    }

    printf("\nAverage Waiting Time = %.2f", avgWT / n);
    printf("\nAverage Turnaround Time = %.2f\n", avgTAT / n);

    return 0;
}