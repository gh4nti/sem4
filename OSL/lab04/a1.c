// Write a C program to simulate the unix commands: ls -l, cp and wc commands. [NOTE: DON’T DIRECTLY USE THE BUILT-IN COMMANDS]

#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>

void sim_ls(char *dirname);
void sim_cp(char *src, char *dest);
void sim_wc(char *filename);

int main(int argc, char *argv[])
{
    if (argc < 2)
    {
        printf("Usage:\n");
        printf("./unix_sim ls <directory>\n");
        printf("./unix_sim cp <source> <destination>\n");
        printf("./unix_sim wc <file>\n");
        return 1;
    }

    if (strcmp(argv[1], "ls") == 0 && argc == 3)
        sim_ls(argv[2]);
    else if (strcmp(argv[1], "cp") == 0 && argc == 4)
        sim_cp(argv[2], argv[3]);
    else if (strcmp(argv[1], "wc") == 0 && argc == 3)
        sim_wc(argv[2]);
    else
        printf("Invalid command or arguments\n");

    return 0;
}

// ls -l
void sim_ls(char *dirname)
{
    DIR *dir;
    struct dirent *entry;
    struct stat fileStat;
    char path[1024];

    dir = opendir(dirname);
    if (!dir)
    {
        perror("opendir");
        return;
    }

    printf("Permissions   Links   Size   Name\n");

    while ((entry = readdir(dir)) != NULL)
    {
        snprintf(path, sizeof(path), "%s%s", dirname, entry->d_name);

        if (stat(path, &fileStat) == -1)
        {
            perror("stat");
            continue;
        }

        printf((S_ISDIR(fileStat.st_mode)) ? "d" : "-");
        printf((fileStat.st_mode & S_IRUSR) ? "r" : "-");
        printf((fileStat.st_mode & S_IWUSR) ? "w" : "-");
        printf((fileStat.st_mode & S_IXUSR) ? "x" : "-");
        printf((fileStat.st_mode & S_IRGRP) ? "r" : "-");
        printf((fileStat.st_mode & S_IWGRP) ? "w" : "-");
        printf((fileStat.st_mode & S_IXGRP) ? "x" : "-");
        printf((fileStat.st_mode & S_IROTH) ? "r" : "-");
        printf((fileStat.st_mode & S_IWOTH) ? "w" : "-");
        printf((fileStat.st_mode & S_IXOTH) ? "x" : "-");

        printf("   %ld   %ld   %s\n",
               (long)fileStat.st_nlink,
               (long)fileStat.st_size,
               entry->d_name);
    }

    closedir(dir);
}

// cp
void sim_cp(char *src, char *dest)
{
    int fd1, fd2;
    char buffer[1024];
    int bytes;

    fd1 = open(src, O_RDONLY);
    if (fd1 < 0)
    {
        perror("open source");
        return;
    }

    fd2 = open(dest, O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (fd2 < 0)
    {
        perror("open destination");
        return;
    }

    while ((bytes = read(fd1, buffer, sizeof(buffer))) > 0)
        write(fd2, buffer, bytes);

    printf("File copied successfully.\n");

    close(fd1);
    close(fd2);
}

// wc
void sim_wc(char *filename)
{
    FILE *fp;
    char ch;
    int lines = 0, words = 0, chars = 0;
    int in_word = 0;

    fp = fopen(filename, 'r');
    if (!fp)
    {
        perror("open");
        return;
    }

    while ((ch = fgetc(fp)) != EOF)
    {
        chars++;

        if (ch == '\n')
            lines++;

        if (ch == ' ' || ch == '\n' || ch == '\t')
            in_word = 0;
        else if (!in_word)
        {
            in_word = 1;
            words++;
        }
    }

    printf("Lines: %d  Words: %d  Characters: %d\n", lines, words, chars);
    fclose(fp);
}