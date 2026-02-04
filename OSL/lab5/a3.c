// Write a C/C++ program to simulate Rate-Monotonic scheduling for real time systems.

#include <stdio.h>
#include <limits.h>

int main()
{
    int n, completed = 0, time = 0;
    int pid[20], burst[20], period[20];
    int waiting[20], turnaround[20], completion[20];
    int done[20] = {0};

    float avgWT = 0, avgTAT = 0;

    printf("Enter number of tasks: ");
    scanf("%d", &n);

    for (int i = 0; i < n; i++)
    {
        pid[i] = i + 1;
        printf("Enter Execution Time and Period for Task %d: ", pid[i]);
        scanf("%d %d", &burst[i], &period[i]);
    }

    printf("\nGantt Chart:\n|");

    while (completed < n)
    {
        int idx = -1;
        int minPeriod = INT_MAX;

        for (int i = 0; i < n; i++)
        {
            if (!done[i] && period[i] < minPeriod)
            {
                minPeriod = period[i];
                idx = i;
            }
        }

        printf(" T%d |", pid[idx]);

        time += burst[idx];
        completion[idx] = time;
        turnaround[idx] = completion[idx];
        waiting[idx] = turnaround[idx] - burst[idx];

        done[idx] = 1;
        completed++;
    }

    printf("\n\nTask\tET\tPeriod\tWT\tTAT\n");
    for (int i = 0; i < n; i++)
    {
        avgWT += waiting[i];
        avgTAT += turnaround[i];

        printf("T%d\t%d\t%d\t%d\t%d\n",
               pid[i], burst[i], period[i],
               waiting[i], turnaround[i]);
    }

    printf("\nAverage Waiting Time = %.2f", avgWT / n);
    printf("\nAverage Turnaround Time = %.2f\n", avgTAT / n);

    return 0;
}
