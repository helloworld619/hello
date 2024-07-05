writer
#include <stdio.h>
#include <sys/ipc.h>
#include <sys/msg.h>

#define MAX 100

// structure for message queue
struct mesg_buffer {
    long mesg_type;
    char mesg_text[100];
} message;

int main() {
    key_t key;
    int msgid;

    // ftok to generate unique key
    key = ftok("progfile", 65);

    // msgget creates a message queue and returns identifier
    msgid = msgget(key, 0666 | IPC_CREAT);

    message.mesg_type = 1;

    printf("Write Data : ");
    if (fgets(message.mesg_text, MAX, stdin) == NULL) {
        perror("fgets");
        return 1;
    }

    // msgsnd to send message
    if (msgsnd(msgid, &message, sizeof(message), 0) == -1) {
        perror("msgsnd");
        return 1;
    }

    // display the message
    printf("Data sent is: %s \n", message.mesg_text);

    return 0;
}
out
gcc writer.c -o writer
gcc reader.c -o reader

./writer
