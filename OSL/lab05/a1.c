// Write C program to implement FCFS. (Assuming all the processes arrive at the same time)

#include <stdio.h>

int main()
{
    int n, i;
    int burst[20], waiting[20], turnaround[20];
    float avgWT = 0, avgTAT = 0;

    printf("Enter number of processes: ");
    scanf("%d", &n);

    for (i = 0; i < n; i++)
    {
        printf("Enter burst time for P%d: ", i + 1);
        scanf("%d", &burst[i]);
    }

    waiting[0] = 0;

    for (i = 1; i < n; i++)
    {
        waiting[i] = waiting[i - 1] + burst[i - 1];
    }

    for (i = 0; i < n; i++)
    {
        turnaround[i] = waiting[i] + burst[i];
    }

    printf("\nGantt Chart:\n|");
    for (i = 0; i < n; i++)
    {
        printf(" P%d |", i + 1);
    }

    printf("\n\nPID\tBT\tWT\tTAT\n");
    for (i = 0; i < n; i++)
    {
        printf("P%d\t%d\t%d\t%d\n",
               i + 1, burst[i], waiting[i], turnaround[i]);

        avgWT += waiting[i];
        avgTAT += turnaround[i];
    }

    printf("\nAverage Waiting Time = %.2f", avgWT / n);
    printf("\nAverage Turnaround Time = %.2f\n", avgTAT / n);

    return 0;
}
