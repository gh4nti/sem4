// Process A wants to send a number to Process B. Once received, Process B has to check whether the number is palindrome or not. Write a C program to implement this interprocess communication using message queue.

#include <stdio.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <unistd.h>

struct msg_buffer
{
    long msg_type;
    int number;
};

int isPalindrome(int n);

int main()
{
    key_t key;
    int msgid;
    struct msg_buffer message;

    key = ftok("progfile", 65);
    msgid = msgget(key, 0666 | IPC_CREAT);

    if (fork() == 0)
    {
        msgrcv(msgid, &message, sizeof(message.number), 1, 0);
        printf("Process B received number: %d\n", message.number);
        if (isPalindrome(message.number))
            printf("%d is a palindrome\n", message.number);
        else
            printf("%d is not a palindrome.\n", message.number);

        msgctl(msgid, IPC_RMID, NULL);
    }
    else
    {
        message.msg_type = 1;

        printf("Process A: Enter a number: ");
        scanf("%d", &message.number);

        msgsnd(msgid, &message, sizeof(message.number), 0);
        printf("Process A sent number: %d\n", message.number);

        wait(NULL);
    }
    return 0;
}

int isPalindrome(int n)
{
    int orig = n, rev = 0, rem;

    while (n > 0)
    {
        rem = n % 10;
        rev = rev * 10 + rem;
        n /= 10;
    }

    return orig == rev;
}