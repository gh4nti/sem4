/*
Write a menu driven C program to simulate the following CPU scheduling algorithms. Display Gantt chart showing the order of execution of each process. Compute waiting time and turnaround time for each process. Hence, compute average waiting time and average turnaround time.
- FCFS
- SRTF
- Round-Robin (quantum = 10)
- non-preemptive priority (higher the number higher the priority)
*/

#include <stdio.h>
#include <limits.h>

#define N 4
#define Q 10

typedef struct
{
    int pid;
    int arrival;
    int burst;
    int remaining;
    int priority;
    int waiting;
    int turnaround;
    int completion;
} Process;

Process p[N];

void init();
void print_stats();
void fcfs();
void srtf();
void round_robin();
void priority_np();

int main()
{
    int ch;
    do
    {
        printf("\n\nCPU Scheduling Algorithms");
        printf("\n1. FCFS");
        printf("\n2. SRTF");
        printf("\n3. Round Robin (Q=10)");
        printf("\n4. Non-Preemptive Priority");
        printf("\n5. Exit");
        printf("\nEnter choice: ");
        scanf("%d", &ch);

        switch (ch)
        {
        case 1:
            fcfs();
            break;
        case 2:
            srtf();
            break;
        case 3:
            round_robin();
            break;
        case 4:
            priority_np();
            break;
        case 5:
            break;
        default:
            printf("Invalid choice");
        }
    } while (ch != 5);

    return 0;
}

void init()
{
    p[0] = (Process){1, 0, 60, 60, 3, 0, 0, 0};
    p[1] = (Process){2, 3, 30, 30, 2, 0, 0, 0};
    p[2] = (Process){3, 4, 40, 40, 1, 0, 0, 0};
    p[3] = (Process){4, 9, 10, 10, 4, 0, 0, 0};
}

void print_stats()
{
    float awt = 0, att = 0;
    printf("\nPID\tWT\tTAT\n");
    for (int i = 0; i < N; i++)
    {
        printf("P%d\t%d\t%d\n", p[i].pid, p[i].waiting, p[i].turnaround);
        awt += p[i].waiting;
        att += p[i].turnaround;
    }
    printf("\nAverage Waiting Time = %.2f", awt / N);
    printf("\nAverage Turnaround Time = %.2f\n", att / N);
}

// FCFS
void fcfs()
{
    init();
    int time = 0;
    printf("\nGantt Chart:\n|");

    for (int i = 0; i < N; i++)
    {
        if (time < p[i].arrival)
            time = p[i].arrival;

        printf(" P%d |", p[i].pid);
        p[i].waiting = time - p[i].arrival;
        time += p[i].burst;
        p[i].completion = time;
        p[i].turnaround = p[i].completion - p[i].arrival;
    }
    print_stats();
}

// SRTF
void srtf()
{
    init();
    int time = 0, completed = 0;
    int last = -1;

    printf("\nGantt Chart:\n|");

    while (completed < N)
    {
        int idx = -1;
        int min = INT_MAX;

        for (int i = 0; i < N; i++)
        {
            if (p[i].arrival <= time && p[i].remaining > 0 &&
                p[i].remaining < min)
            {
                min = p[i].remaining;
                idx = i;
            }
        }

        if (idx == -1)
        {
            time++;
            continue;
        }

        if (last != idx)
        {
            printf(" P%d |", p[idx].pid);
            last = idx;
        }

        p[idx].remaining--;
        time++;

        if (p[idx].remaining == 0)
        {
            completed++;
            p[idx].completion = time;
            p[idx].turnaround = time - p[idx].arrival;
            p[idx].waiting = p[idx].turnaround - p[idx].burst;
        }
    }
    print_stats();
}

// Round Robin
void round_robin()
{
    init();
    int time = 0, completed = 0;
    int queue[100], front = 0, rear = 0;
    int visited[N] = {0};

    printf("\nGantt Chart:\n|");

    while (completed < N)
    {
        for (int i = 0; i < N; i++)
        {
            if (!visited[i] && p[i].arrival <= time)
            {
                queue[rear++] = i;
                visited[i] = 1;
            }
        }

        if (front == rear)
        {
            time++;
            continue;
        }

        int i = queue[front++];
        printf(" P%d |", p[i].pid);

        int exec = (p[i].remaining > Q) ? Q : p[i].remaining;
        p[i].remaining -= exec;
        time += exec;

        for (int j = 0; j < N; j++)
        {
            if (!visited[j] && p[j].arrival <= time)
            {
                queue[rear++] = j;
                visited[j] = 1;
            }
        }

        if (p[i].remaining > 0)
            queue[rear++] = i;
        else
        {
            completed++;
            p[i].completion = time;
            p[i].turnaround = time - p[i].arrival;
            p[i].waiting = p[i].turnaround - p[i].burst;
        }
    }
    print_stats();
}

// Priority (non-preemptive)
void priority_np()
{
    init();
    int time = 0, completed = 0;
    int done[N] = {0};

    printf("\nGantt Chart:\n|");

    while (completed < N)
    {
        int idx = -1;
        int maxp = -1;

        for (int i = 0; i < N; i++)
        {
            if (!done[i] && p[i].arrival <= time &&
                p[i].priority > maxp)
            {
                maxp = p[i].priority;
                idx = i;
            }
        }

        if (idx == -1)
        {
            time++;
            continue;
        }

        printf(" P%d |", p[idx].pid);
        p[idx].waiting = time - p[idx].arrival;
        time += p[idx].burst;
        p[idx].completion = time;
        p[idx].turnaround = time - p[idx].arrival;
        done[idx] = 1;
        completed++;
    }
    print_stats();
}