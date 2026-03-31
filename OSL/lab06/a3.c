// Write a program which creates a message queue and writes message into queue which contains number of users working on the machine along with observed time in hours and minutes. This is repeated for every 10 minutes. Write another program which reads this information form the queue and calculates on average in each hour how many users are working.

#include <stdio.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <time.h>
#include <unistd.h>

struct msg_buffer
{
    long msg_type;
    int users;
    int hour;
    int minute;
};

int main()
{
    key_t key;
    int msgid;
    struct msg_buffer msg;

    key = ftok("msgfile", 65);
    msgid = msgget(key, 0666 | IPC_CREAT);

    msg.msg_type = 1;

    for (int i = 0; i < 6; i++)
    {
        time_t now = time(NULL);
        struct tm *t = localtime(&now);

        msg.hour = t->tm_hour;
        msg.minute = t->tm_min;

        msg.users = 10 + i;

        msgsnd(msgid, &msg, sizeof(msg) - sizeof(long), 0);

        printf("Written -> Users: %d | Time: %02d:%02d\n",
               msg.users, msg.hour, msg.minute);

        sleep(1);
    }

    return 0;
}