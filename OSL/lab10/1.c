// Write a C/C++ program to simulate page replacement algorithms: FIFO and optimal. Frame allocation has to be done as per user input and use dynamic allocation for all data structures.

#include <stdio.h>
#include <stdlib.h>

int isHit(int *frames, int f, int page);
void display(int *frames, int f);
void fifo(int *pages, int n, int f);
int findOptimal(int *frames, int f, int *pages, int n, int curr);
void optimal(int *pages, int n, int f);

int main()
{
	int n, f;

	printf("Enter no. of pages: ");
	scanf("%d", &n);

	int *pages = (int *)malloc(n * sizeof(int));

	printf("Enter page reference string:\n");
	for (int i = 0; i < n; i++)
		scanf("%d", &pages[i]);

	printf("Enter no. of frames: ");
	scanf("%d", &f);

	fifo(pages, n, f);
	optimal(pages, n, f);

	free(pages);

	return 0;
}

int isHit(int *frames, int f, int page)
{
	for (int i = 0; i < f; i++)
		if (frames[i] == page)
			return 1;

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

void fifo(int *pages, int n, int f)
{
	int *frames = (int *)malloc(f * sizeof(int));

	for (int i = 0; i < f; i++)
		frames[i] = -1;

	int idx = 0, faults = 0;

	printf("\nFIFO Page Replacement:\n");

	for (int i = 0; i < n; i++)
	{
		if (!isHit(frames, f, pages[i]))
		{
			frames[idx] = pages[i];
			idx = (idx + 1) % f;
			faults++;
		}
		display(frames, f);
	}

	printf("Total page faults (FIFO): %d\n", faults);
}

int findOptimal(int *frames, int f, int *pages, int n, int curr)
{
	int farthest = curr, idx = -1;

	for (int i = 0; i < f; i++)
	{
		int j;
		for (j = curr + 1; j < n; j++)
		{
			if (frames[i] == pages[j])
			{
				if (j > farthest)
				{
					farthest = j;
					idx = i;
				}
				break;
			}
		}
		if (j == n)
			return i;
	}

	return (idx == -1) ? 0 : idx;
}

void optimal(int *pages, int n, int f)
{
	int *frames = (int *)malloc(f * sizeof(int));

	for (int i = 0; i < f; i++)
		frames[i] = -1;

	int faults = 0;

	printf("\nOptimal Page Replacement:\n");

	for (int i = 0; i < n; i++)
	{
		if (!isHit(frames, f, pages[i]))
		{
			int pos = findOptimal(frames, f, pages, n, i);
			frames[pos] = pages[i];
			faults++;
		}
		display(frames, f);
	}

	printf("Total Page Faults (Optimal): %d\n", faults);

	free(frames);
}