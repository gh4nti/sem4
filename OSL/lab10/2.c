// Write a C/C++ program to simulate LRU Page Replacement. Frame allocation must be done as per user input and dynamic allocation for all data structures. Find the total number of page faults and hit ratio for the algorithm.

#include <stdio.h>
#include <stdlib.h>

void display(int *frames, int f);
int findLRU(int *time, int f);
void LRU(int *pages, int n, int f);

int main()
{
	int n, f;

	printf("Enter number of pages: ");
	scanf("%d", &n);

	int *pages = (int *)malloc(n * sizeof(int));

	printf("Enter page reference string:\n");
	for (int i = 0; i < n; i++)
	{
		scanf("%d", &pages[i]);
	}

	printf("Enter number of frames: ");
	scanf("%d", &f);

	LRU(pages, n, f);

	free(pages);

	return 0;
}

void display(int *frames, int f)
{
	for (int i = 0; i < f; i++)
	{
		if (frames[i] == -1)
			printf("- ");
		else
			printf("%d ", frames[i]);
	}
	printf("\n");
}

int findLRU(int *time, int f)
{
	int min = time[0], pos = 0;

	for (int i = 1; i < f; i++)
	{
		if (time[i] < min)
		{
			min = time[i];
			pos = i;
		}
	}
	return pos;
}

void LRU(int *pages, int n, int f)
{
	int *frames = (int *)malloc(f * sizeof(int));
	int *time = (int *)malloc(f * sizeof(int));

	int faults = 0, hits = 0, counter = 0;

	for (int i = 0; i < f; i++)
	{
		frames[i] = -1;
		time[i] = 0;
	}

	printf("\nLRU Page Replacement:\n");

	for (int i = 0; i < n; i++)
	{
		int found = 0;

		for (int j = 0; j < f; j++)
		{
			if (frames[j] == pages[i])
			{
				counter++;
				time[j] = counter;
				hits++;
				found = 1;
				break;
			}
		}

		if (!found)
		{
			int pos = findLRU(time, f);
			counter++;
			frames[pos] = pages[i];
			time[pos] = counter;
			faults++;
		}

		display(frames, f);
	}

	float hit_ratio = (float)hits / n;

	printf("Total Page Faults: %d\n", faults);
	printf("Total Hits: %d\n", hits);
	printf("Hit Ratio: %.2f\n", hit_ratio);

	free(frames);
	free(time);
}