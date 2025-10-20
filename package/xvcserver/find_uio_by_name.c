#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <dirent.h>

int main(int argc, char *argv[])
{
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <uio_name>\n", argv[0]);
        return 1;
    }

    const char *target_name = argv[1];
    DIR *dir = opendir("/sys/class/uio");
    if (!dir) {
        perror("opendir /sys/class/uio");
        return 1;
    }

    struct dirent *entry;
    char namepath[128];
    char devpath[128];
    char namebuf[64];
    FILE *fp;

    while ((entry = readdir(dir)) != NULL) {
        if (strncmp(entry->d_name, "uio", 3) != 0)
            continue;

        snprintf(namepath, sizeof(namepath), "/sys/class/uio/%s/name", entry->d_name);
        fp = fopen(namepath, "r");
        if (!fp)
            continue;

        if (fgets(namebuf, sizeof(namebuf), fp)) {
            namebuf[strcspn(namebuf, "\n")] = '\0';
            if (strcmp(namebuf, target_name) == 0) {
                snprintf(devpath, sizeof(devpath), "%s", entry->d_name);
                printf("%s\n", devpath);
                fclose(fp);
                closedir(dir);
                return 0;
            }
        }
        fclose(fp);
    }

    closedir(dir);
    fprintf(stderr, "UIO device named '%s' not found\n", target_name);
    return 2;
}
