/*
Write a C/C++ Program to simulate the following algorithms and find the total
number of cylinder movements for various input requests:
- LOOK
- C-LOOK
*/

#include <stdio.h>
#include <stdlib.h>

#define MAX 100

int compareAsc(const void *a, const void *b);
int totalMovements(int sequence[], int size);
void printSequence(const char *title, int sequence[], int size, int total);
void look(int requests[], int n, int head, int direction);
void clook(int requests[], int n, int head, int direction);

int main()
{
	int n, head, direction;
	int requests[MAX];

	printf("=== LOOK and C-LOOK Disk Scheduling Simulator ===\n\n");

	printf("Enter the number of disk requests: ");
	scanf("%d", &n);

	printf("Enter the disk requests (space-separated):\n");
	for (int i = 0; i < n; i++)
	{
		scanf("%d", &requests[i]);
	}

	printf("Enter the initial head position: ");
	scanf("%d", &head);

	printf("Enter the initial direction (1 for higher cylinders, 0 for lower cylinders): ");
	scanf("%d", &direction);

	printf("\n========================================\n");
	look(requests, n, head, direction);
	clook(requests, n, head, direction);
	printf("\n========================================\n");

	return 0;
}

int compareAsc(const void *a, const void *b)
{
	return (*(int *)a - *(int *)b);
}

int totalMovements(int sequence[], int size)
{
	int total = 0;

	for (int i = 1; i < size; i++)
	{
		total += abs(sequence[i] - sequence[i - 1]);
	}

	return total;
}

void printSequence(const char *title, int sequence[], int size, int total)
{
	printf("\n=== %s ===\n", title);
	printf("Service Order: ");

	for (int i = 0; i < size; i++)
	{
		printf("%d ", sequence[i]);
	}

	printf("\nTotal Cylinder Movements: %d\n", total);
}

void look(int requests[], int n, int head, int direction)
{
	int left[MAX], right[MAX];
	int leftCount = 0, rightCount = 0;
	int sequence[MAX + 1];
	int idx = 0;

	sequence[idx++] = head;

	for (int i = 0; i < n; i++)
	{
		if (requests[i] < head)
		{
			left[leftCount++] = requests[i];
		}
		else if (requests[i] > head)
		{
			right[rightCount++] = requests[i];
		}
		else
		{
			sequence[idx++] = requests[i];
		}
	}

	qsort(left, leftCount, sizeof(int), compareAsc);
	qsort(right, rightCount, sizeof(int), compareAsc);

	if (direction == 1)
	{
		for (int i = 0; i < rightCount; i++)
		{
			sequence[idx++] = right[i];
		}

		for (int i = leftCount - 1; i >= 0; i--)
		{
			sequence[idx++] = left[i];
		}
	}
	else
	{
		for (int i = leftCount - 1; i >= 0; i--)
		{
			sequence[idx++] = left[i];
		}

		for (int i = 0; i < rightCount; i++)
		{
			sequence[idx++] = right[i];
		}
	}

	printSequence("LOOK", sequence, idx, totalMovements(sequence, idx));
}

void clook(int requests[], int n, int head, int direction)
{
	int left[MAX], right[MAX];
	int leftCount = 0, rightCount = 0;
	int sequence[MAX + 1];
	int idx = 0;

	sequence[idx++] = head;

	for (int i = 0; i < n; i++)
	{
		if (requests[i] < head)
		{
			left[leftCount++] = requests[i];
		}
		else if (requests[i] > head)
		{
			right[rightCount++] = requests[i];
		}
		else
		{
			sequence[idx++] = requests[i];
		}
	}

	qsort(left, leftCount, sizeof(int), compareAsc);
	qsort(right, rightCount, sizeof(int), compareAsc);

	if (direction == 1)
	{
		for (int i = 0; i < rightCount; i++)
		{
			sequence[idx++] = right[i];
		}

		for (int i = 0; i < leftCount; i++)
		{
			sequence[idx++] = left[i];
		}
	}
	else
	{
		for (int i = leftCount - 1; i >= 0; i--)
		{
			sequence[idx++] = left[i];
		}

		for (int i = rightCount - 1; i >= 0; i--)
		{
			sequence[idx++] = right[i];
		}
	}

	printSequence("C-LOOK", sequence, idx, totalMovements(sequence, idx));
}
