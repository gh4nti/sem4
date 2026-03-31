/*
We have five segments numbered 0 through 4. The segments are stored in physical memory as shown in the following Fig 10.3. Write a C program to create segment table. Write methods for converting logical address to physical address. Compute the physical address for the following.
- 53 byte of segment 2
- 852 byte of segment 3
- 1222 byte of segment 0
*/

#include <stdio.h>

struct Segment
{
    int base, limit;
};

int main()
{
    struct Segment segTable[5] = {
        {1400, 1000},
        {6300, 400},
        {4300, 400},
        {3200, 1100},
        {4700, 700}};

    int segNo, offset;

    printf("Enter segment number (0-4): ");
    scanf("%d", &segNo);

    printf("Enter offset: ");
    scanf("%d", &offset);

    if (offset >= segTable[segNo].limit)
        printf("Invalid address (Segmentation Fault)\n");
    else
    {
        int physical_address = segTable[segNo].base + offset;
        printf("Physical Address = %d\n", physical_address);
    }

    return 0;
}